# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0')

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

def verschmelze_vor_und_nachbereich(vorundnach)
  # Prüfe alle Stellen
  vorundnach.stellen.each do |s|
    # Vor- oder Nachbereich dürfen nicht leer sein
    next if vorundnach.vorbereich(s) == [] || vorundnach.fluss[s].nil?

    # Es gibt keine Schlinge an s
    next if vorundnach.vorbereich(s).include? vorundnach.fluss[s].join(', ')

    # Die Nachbereichstransitionen dürfen keine anderen Stellen außer s im Vorbereich haben
    next if vorundnach.fluss[s].any? { |nach| s == vorundnach.vorbereich(nach) }

    # Alle Nachbereichstransitionen haben identische Vielfachheit
    # Speichere diese Vielfachheit für später
    vielfachheit = vorundnach.fluss[s].count(vorundnach.fluss[s].last)
    next unless vorundnach.fluss[s].all? { |c| vorundnach.fluss[s].count(c) == vielfachheit }

    # Letzte Fallunterscheidung
    # Füge eine Kontrollvariable ein
    fuenf = false
    # Entweder hat s nur eine Transition im Nachbereich
    if vorundnach.fluss[s].length == 1
      # Prüfe alle Vorbereichstransitionen
      vorundnach.vorbereich(s).each do |v|
        # Die obere Vielfachheit teilt die Vielfachheit aller Kanten vom Vorbereich zu s
        break unless vorundnach.fluss[v].all? { |nv| vorundnach.fluss[v].count(nv) % vielfachheit == 0 }

        fuenf = true
      end

    # Oder s hat mehr als eine Transition im Nachbereich
    elsif vorundnach.fluss[s].length > 1
      # Die Vielfachheit ist größer als die Anzahl an Marken aus s.
      if vorundnach.markierung[vorundnach.stellen.index(s)].to_i < vielfachheit
        # Die Anzahl der Kanten der Vorbereichstransitionen zui s entspricht der Vielfachheit.
        vorundnach.vorbereich(s).each do |v|
          break unless vorundnach.fluss[v].join(', ').split(', ').count(s) == vielfachheit

          fuenf = true
        end
      end
    end

    # Gilt die vorherige Überprüfung in keinem Fall, überspringe diese Stelle
    next unless fuenf

    # Alle hier noch bearbeiteten Stellen erfüllen alle Voraussetzungen
    # Ist die Anzahl der Marken auf k größer als die Vielfachheit
    while vorundnach.markierung[vorundnach.markierung[vorundnach.stellen.index(s)].to_i].to_i >= vielfachheit
      vorundnach.schalte(vorundnach.fluss.values_at(s).join(', ').split(', ')[0])
    end

    # Füge neue Transitionen ein
    # Für jede Vorbereichstransition
    vorundnach.vorbereich(s).each_with_index do |v, i|
      # Für jede Nachbereichstransition
      vorundnach.fluss.values_at(s).join(', ').split(', ').each_with_index do |n, j|
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
        (vorundnach.fluss[v].count(s) / vielfachheit).times do
          nachbereich.append(vorundnach.fluss[n])
        end
        # Füge den Rest in die neuen Übergänge ein.
        vorundnach.fluss.store(vorundnach.transitionen.last, nachbereich.join(', ').split(', '))

        # Entferne k aus dem Nachbereich der neuen Transitionen, damit k später sicher entfernt werden kann
        vorundnach.fluss[vorundnach.transitionen.last].delete(s)
      end
      # Streiche den Vorbereich
      vorundnach.vorbereich(s).each do |vb|
        vorundnach.reduziere_knoten(vb)
      end

      # Streiche den Nachbereich
      vorundnach.fluss[s].each do |n|
        vorundnach.reduziere_knoten(n)
      end

      # Streiche den Knoten
      vorundnach.reduziere_knoten(s)
    end
  end

  # Fürs Protokoll
  puts("Vor- mit Nachbereichstransitionen verschmolzen!")
end
