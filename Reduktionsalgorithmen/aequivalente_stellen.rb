# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

aequ = PetriNetz.new('s1:t2;s2:t3;s3:t1;s4:t4;s5:t2,t3;;t1:s2;t2:s4;t3:s4;t4:s1;;', '0,1,0,0')

# Regel 4: Es gilt
# Es gibt zwei Stellen mit genau einer Kante zum Nachbereich und keinem leeren Vorbereich
# Die Transitionen im Nachbereich der Stellen sind nicht gleich
# Der Nachbereich der Transitionen im Nachbereich der Stellen ist gleich
# Für alle Stellen s die nicht die aequivalenten Stellen sind gilt:
# Liegt s im Vorbereich von t1, so auch im Vorbereich von t2

# Das Vorgehen hier ist wiefolgt:
# Treffen alle Voraussetzungen auf eine Stelle zu, füge diese zu einem Array hinzu.
# Reduziere später alle Stellen in diesem Array.
def reduziere_aequivalente_stellen(aequ)
  # Fülle das Array Kandidaten mit den Stellen, die der Voraussetzung entsprechen
  kandidaten = []
  # Prüfe jeweils zwei Stellen
  aequ.stellen.each do |s|
    # Die Stelle darf nicht mehr als eine Einfachkante zum Nachbereich haben.
    next if aequ.fluss.values_at(s).join(', ').split(', ').length > 1
    # Die Stelle darf keinen leeren Vorbereich haben.
    next unless aequ.hin[aequ.stellen.index(s)].include?(1)

    kandidaten.append(s)
  end

  # Prüfe jeweils zwei Kandidaten
  kandidaten.each do |s1|
    kandidaten.each do |s2|

      # Sofern die Nachbereiche der Stellen nicht identisch sind ...
      next if aequ.her[aequ.stellen.index(s1)] == aequ.her[aequ.stellen.index(s2)]

      # und die Nachbereiche der Nachbereiche identisch sind
      next unless aequ.fluss.values_at(aequ.fluss.values_at(s1).join(', ')).join(', ') ==
                  aequ.fluss.values_at(aequ.fluss.values_at(s2).join(', ')).join(', ')

      # Prüfe alle Stellen die nicht s1 oder s2 sind
      aequ.stellen.each do |s|
        next unless s != s1 || s != s2
        unless aequ.fluss.values_at(s).join(', ').include?(aequ.fluss.values_at(s1).join(', ')) &&
               aequ.fluss.values_at(s).join(', ').include?(aequ.fluss.values_at(s2).join(', '))
          # Gibt es eine solche Stelle die die Bedingung missachtet,
          # breche die Reduktion ab und suche weiter
          break
        end
      end
      # Hier findet die eigentliche Reduktion statt
      # Lösche den Nachbereich der Stelle s2
      aequ.transitionen.delete(aequ.fluss[s2].join(', '))
      # Die eingehenden Übergägne bei s2 werden auf s1 umgeleitet
      unless aequ.fluss[aequ.fluss.key([s2])].nil?
        aequ.fluss[aequ.fluss.key([s2])] = aequ.fluss[aequ.fluss.key([s2])] - [s2] + [s1]
      end
      # Addiere die Marken beider Stellen und lege sie auf s1
      aequ.markierung[aequ.stellen.index(s1)] = (aequ.markierung[aequ.stellen.index(s1)].to_i +
                                                aequ.markierung[aequ.stellen.index(s2)].to_i).to_s

      # Lösche alle unbenötigten Übergänge
      aequ.fluss.values.each do |f|
        # Sofern nur t2 vorkommt, lösche den gesamten Übergang
        if f == aequ.fluss.values_at(s2).join(', ').split(', ')
          aequ.fluss.delete(f.join(', '))
        # Ansonsten entferne nur s aus dem entsprechenden Nachbereich
        elsif f.include?(aequ.fluss.values_at(s2).join(', '))
          aequ.fluss[aequ.fluss.key(f)] = aequ.fluss[aequ.fluss.key(f)] - aequ.fluss.values_at(s2).join(', ').split(', ')
        end
      end
      # Lösche die Übergänge der Stelle s2
      aequ.fluss.delete(s2)
      # Lösche die Stelle s2
      aequ.stellen.delete(s2)
    end
    break
  end

  # Fürs Protokoll
  puts("Aequivalente Stellen reduziert!")
end
