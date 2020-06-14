# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

schlinge = PetriNetz.new('s1:t1,t2;s2:t1,t2;;t1:s1,s2;t2:;;', '0,0')

# Prüfe jede Transition
schlinge.transitionen.each do |t|
  schlinge.hin.each do |_h|
    # Vorbereich identisch mit Nachbereich
    next unless schlinge.hin.join(', ').split(', ')[schlinge.transitionen.index(t)] ==
                schlinge.her.join(', ').split(', ')[schlinge.transitionen.index(t)]
    # TODO
  end
end

schlinge.testnetz
schlinge.gv
