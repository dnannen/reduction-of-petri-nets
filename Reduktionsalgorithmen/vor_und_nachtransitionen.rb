# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '1,1,0,0')

# Regel 5:
#




# Erstelle ein Array mit den Stellen, die alle Voraussetzungen erfüllen.
kandidaten = []
# Definiere die Vielfachheit, die für die Reduktion benötigt wird
vielfachheit = 0

# Prüfe alle Stellen
vorundnach.stellen.each do |s|

  # Vor- oder Nachbereich dürfen nicht leer sein
  next if vorundnach.vorbereich(s) == [] || vorundnach.fluss[s].nil?

  # Es gibt keine Schlinge an s
  next if vorundnach.vorbereich(s).include? vorundnach.fluss[s].join(', ')

  # Füge alle bisher zutreffenden Stellen zu den Kandidaten hinzu
  kandidaten.append(s)
end

# Sortiere die Kandidaten weiter aus
kandidaten.each do |k|
  # Prüfe alle Nachbereichstransitionen von k
  vorundnach.fluss[k].each do |nt|

    # Entferne k aus den Kandidaten, sofern die Nachbereichstransitionen
    # noch andere Stellen außer k im Vorbereich haben
    # Die Vielfachheit der von k ausgehenden Kanten ist immer gleich
    # Definiere die Vielfachheit des ersten Übergangs
    vielfachheit = vorundnach.fluss[k].count(nt)
    vorundnach.fluss[k].each do |v|
      # Entferne den Kandidaten, wenn die Vielfachheit verschieden ist
      kandidaten.delete(k) if vorundnach.fluss[k].count(v) != vielfachheit
    end
  end

  # Letzte Fallunterscheidung
  # Entweder hat k nur eine Transition im Nachbereich
  if vorundnach.fluss[k].length == 1
    # Prüfe alle Vorbereichstransitionen
    vorundnach.vorbereich(k).each do |v|
      # Vielfachheit von oben teilt die Vielfachheit des Übergang
      kandidaten.delete(k) unless vorundnach.fluss[v].join(', ').split(', ').count(k) % vielfachheit.zero?
    end
  # oder mehr als eine Transition im Nachbereich
  elsif vorundnach.fluss[k].length > 1
    # Die Vielfachheit ist größer als die Anzahl an Marken aus s.
    if vorundnach.markierung[vorundnach.stellen.index(k)].to_i < vielfachheit
      # Die Anzahl der Kanten der Vorbereichstransitionen zui s entspricht der Vielfachheit.
      vorundnach.vorbereich(k).each do |v|
        kandidaten.delete(k) unless vorundnach.fluss[v].join(', ').split(', ').count(k) == vielfachheit
      end
    end
  end
end

# Alle Einträge im Array Kandidaten erfüllen alle Voraussetzungen, werden also reduziert
kandidaten.each do |k|
  # Ist die Anzahl der Marken auf k größer als die Vielfachheit
  if vorundnach.markierung[vorundnach.markierung[vorundnach.stellen.index(k)].to_i].to_i >= vielfachheit
    vorundnach.schalte(k)
  end
end

p vielfachheit
p kandidaten

vorundnach.testnetz
vorundnach.gv('test')