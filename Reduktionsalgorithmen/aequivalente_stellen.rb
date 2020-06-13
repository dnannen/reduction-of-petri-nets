# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
aequivalent = PetriNetz.new('s1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1', '0,1,0,0')

# Prüfe jeweils zwei Stellen
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
    next if aequivalent.fluss[s1] == aequivalent.fluss[s2]

    #
    if aequivalent.fluss.values_at(aequivalent.fluss[s1].join(', ')).join(', ') ==
       aequivalent.fluss.values_at(aequivalent.fluss[s2].join(', ')).join(', ')

      p s1
      p s2
    end

    # if aequivalent.fluss[s1]
  end
end
# p r

aequivalent.testnetz
# aequivalent.gv
