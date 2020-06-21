# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0')

# Regel 5:
# Es gibt eine Stelle s mit nicht-leerem Vor- und Nachbereich
# An s hängt keine Schlinge
# Der Nachbereich vom Nachbereich der Stelle s ist nicht leer
# Der Vorbereich vom Nachbereich enthält nur s selber
# Die Vielfachheit der im Nachbereich von s eingehenden Kanten ist immer gleich k
# Fallunterscheidung:
# Hat s mehrere Nachbereichstransitionen, ist die Anzahl der Marken aus s kleiner als k
# und die für die Vorbereichstransitionen vons gilt: Die Anzahl der Kanten zwischen
# jeder Vorbereichstransition und s ist gleich k
#
# Hat s nur eine Nachbereichstransition, so gilt für alle Vorbereichstransitionen
# k teilt die Anzahl der Kanten zwischen jeweils jeder Vorbereichstransition und k

# Erstelle ein Array mit den Stellen, die alle Voraussetzungen erfüllen.
@kandidaten = []
# Definiere die Vielfachheit, die für die Reduktion benötigt wird
@vielfachheit = 0
def reduzierbar(vorundnach)

  # Prüfe alle Stellen
  vorundnach.stellen.each do |s|
    # Vor- oder Nachbereich dürfen nicht leer sein
    next if vorundnach.vorbereich(s) == [] || vorundnach.fluss[s].nil?

    # Es gibt keine Schlinge an s
    next if vorundnach.vorbereich(s).include? vorundnach.fluss[s].join(', ')

    # Füge alle bisher zutreffenden Stellen zu den Kandidaten hinzu
    @kandidaten.append(s)
  end

  # Sortiere die Kandidaten weiter aus
  @kandidaten.each do |k|
    # Prüfe alle Nachbereichstransitionen von k
    vorundnach.fluss[k].each do |nt|
      # Entferne k aus den Kandidaten, sofern die Nachbereichstransitionen
      # noch andere Stellen außer k im Vorbereich haben
      # Die Vielfachheit der von k ausgehenden Kanten ist immer gleich
      # Definiere die Vielfachheit des ersten Übergangs
      @vielfachheit = vorundnach.fluss[k].count(nt)
      vorundnach.fluss[k].each do |v|
        # Entferne den Kandidaten, wenn die Vielfachheit verschieden ist
        @kandidaten.delete(k) if vorundnach.fluss[k].count(v) != @vielfachheit
      end
    end

    # Letzte Fallunterscheidung
    # Entweder hat k nur eine Transition im Nachbereich
    if vorundnach.fluss[k].length == 1
      # Prüfe alle Vorbereichstransitionen
      vorundnach.vorbereich(k).each do |v|
        # Vielfachheit von oben teilt die Vielfachheit des Übergang
        @kandidaten.delete(k) unless vorundnach.fluss[v].join(', ').split(', ').count(k) % @vielfachheit == 0
      end
    # oder mehr als eine Transition im Nachbereich
    elsif vorundnach.fluss[k].length > 1
      # Die Vielfachheit ist größer als die Anzahl an Marken aus s.
      if vorundnach.markierung[vorundnach.stellen.index(k)].to_i < @vielfachheit
        # Die Anzahl der Kanten der Vorbereichstransitionen zui s entspricht der Vielfachheit.
        vorundnach.vorbereich(k).each do |v|
          @kandidaten.delete(k) unless vorundnach.fluss[v].join(', ').split(', ').count(k) == @vielfachheit
        end
      end
    end
  end
end

def verschmelze_vor_und_nachbereich(vorundnach)
  # Fülle das Kandidaten-Array
  reduzierbar(vorundnach)
  # Entferne den ersten Eintrag aus den Kandidaten
  @kandidaten.each do |k|
    # Ist die Anzahl der Marken auf k größer als die Vielfachheit
    while vorundnach.markierung[vorundnach.markierung[vorundnach.stellen.index(@kandidaten[0])].to_i].to_i >= @vielfachheit
      vorundnach.schalte(vorundnach.fluss.values_at(@kandidaten[0]).join(', ').split(', ')[0])
    end

    # Füge neue Transitionen ein
    # Für jede Vorbereichstransition
    vorundnach.vorbereich(@kandidaten[0]).each_with_index do |v, i|
      # Für jede Nachbereichstransition
      vorundnach.fluss.values_at(@kandidaten[0]).join(', ').split(', ').each_with_index do |n, j|
        # Füge eine neue Transition ein
        vorundnach.transitionen.append('t' + i.to_s + j.to_s)
        # Der Vorbereich dieser neuen Transition entspricht dem Vorbereich
        # der ehemaligen Vorbereichstransition v
        vorundnach.vorbereich(v).each do |nv|
          vorundnach.fluss[nv] = vorundnach.fluss[nv] + ['t' + i.to_s + j.to_s]
        end
        # Der Nachbereich dieser neuen Transition entspricht folgender Formel
        # n(neu) = v + (F(t1,s)/k) * n
        # Erstelle ein Array für die neue Transition, das später an den Fluss-Hash angebunden wird
        nachbereich = [vorundnach.fluss[v]]
        (vorundnach.fluss[v].count(@kandidaten[0]) / @vielfachheit).times do
          nachbereich.append(vorundnach.fluss[n])
        end
        # Füge den Rest in die neuen Übergänge ein.
        vorundnach.fluss.store(vorundnach.transitionen.last, nachbereich.join(', ').split(', '))

        # Entferne k aus dem Nachbereich der neuen Transitionen, damit k später sicher entfernt werden kann
        vorundnach.fluss[vorundnach.transitionen.last].delete(k)
      end
    end

    vorundnach.vorbereich(@kandidaten[0]).each do |v|
      vorundnach.reduziere_knoten(v)
    end
    vorundnach.fluss[@kandidaten[0]].each do |n|
      vorundnach.reduziere_knoten(n)
    end
    vorundnach.reduziere_knoten(@kandidaten[0])
  end
end
