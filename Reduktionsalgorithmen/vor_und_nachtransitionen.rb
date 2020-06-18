# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0')

# Regel 5
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
    # noch andere Stellen außer k im Vorbereich habendd
    # Die Vielfachheit der von k ausgehenden Kanten ist immer gleich
    # Definiere die Vielfachheit des ersten Übergangs
    vielfachheit = vorundnach.fluss[k].count(nt)
    vorundnach.fluss[k].each do |v|
      # Entferne den Kandidaten, wenn die Vielfachheit verschieden ist
      kandidaten.delete(k) if vorundnach.fluss[k].count(v) != vielfachheit
    end
  end
end

# Alle Einträge im Array Kandidaten erfüllen alle Voraussetzungen,
# werden also reduziert
kandidaten.each do |k|
  # TODO wird vielleicht später gelöscht
end

p vielfachheit
p kandidaten

#vorundnach.deisoliere
vorundnach.testnetz
vorundnach.gv