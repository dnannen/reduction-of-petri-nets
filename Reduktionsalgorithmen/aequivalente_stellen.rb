# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
aequivalent = PetriNetz.new('s1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1', '0,1,0,0')

# Zwei parallele Knoten haben jeweils genau eine Transition im Nachbereich,
# die jeweiligen Bögen haben die Vielfachheit 1.
# Die entsprechenden Nachtransitionen haben zu allen anderen Stellen
# entweder identische Verbindung, oder gar keine.

# Zuerst werden unpassende Stellen aus der zu überprüfenden Menge aussortiert:
# Ziel: Fülle die Matrix r mit potentiellen Kandidaten für die Reduktion

# aequivalent.stellen.each_with_index do |s, index|
# Anforderung 1:
# Es gibt genau eine Transition im Nachbereich
# und die jeweiligen Bögen haben die Vielfachheit 1
# if aequivalent.fluss.values_at(s).join(', ').split(', ').length > 1
# r.delete(s)
# end
# Anforderung 2: Der Vorbereich ist nicht leer
# r.delete(s) unless aequivalent.hin[index].include?(1)
# end

# Prüfe jeweils zwei Stellen aus den Kandidaten
aequivalent.stellen.each do |s1|
  # Voraussetzungen für jede Stelle:
  # Die Stelle darf nicht mehr als eine Einfachkante zum Nachbereich haben.
  if aequivalent.fluss.values_at(s1).join(', ').split(', ').length > 1
    next
  # Die Stelle darf keinen leeren Vorbereich haben.
  elsif !aequivalent.hin[aequivalent.stellen.index(s1)].include?(1)
    next
  end

  aequivalent.stellen.each do |s2|
    # Voraussetzungen für jede Stelle, für den zweiten Durchlauf:
    # Die Stelle darf nicht mehr als eine Einfachkante zum Nachbereich haben.
    if aequivalent.fluss.values_at(s1).join(', ').split(', ').length > 1
      next
      # Die Stelle darf keinen leeren Vorbereich haben.
    elsif !aequivalent.hin[aequivalent.stellen.index(s2)].include?(1)
      next
    end
    next if s1 == s2

    # Die Transitionen im Nachbereich dürfen nicht gleich sein
    next if aequivalent.hin[aequivalent.stellen.index(s1)] == aequivalent.hin[aequivalent.stellen.index(s2)]
    p s1
    p aequivalent.hin[aequivalent.stellen.index(s1)]
    p s2
    p aequivalent.hin[aequivalent.stellen.index(s2)]
      # Der Nachbereich der Nachtransitionen der Stellen muss gleich sein.

  end
end
# p r

aequivalent.testnetz
# aequivalent.gv
