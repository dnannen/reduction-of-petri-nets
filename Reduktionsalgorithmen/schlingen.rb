# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

schlinge = PetriNetz.new('s1:t1,t2;s2:t1,t2;;t1:s1,s2;t2:;;', '0,0')

# Prüfe jede Transition
schlinge.transitionen.each do |t|
  # Teste den Nachbereich jeder Transition t
  schlinge.fluss.values_at(t).join(', ').split(', ').each do |n|
    # Prüfe ob der gesamte Nachbereich die Transition im Vorbereich enthält.
    next unless schlinge.fluss.values_at(n).join(', ').split(', ').include?(t)

    # Prüfe ob es eine Transition t0 gibt, die mindestens alle Stellen
    # aus dem Vorbereich von t enthält
    schlinge.transitionen.each do |t0|
      if t0 != t
        if schlinge.fluss.values_at(n).join(', ').split(', ').include?(t0)
          # Streiche t aus allen Nachbereichen in denen sie vorkommt
          schlinge.stellen.each do |s|
            if schlinge.fluss.values_at(s).join(', ') == t
              schlinge.fluss.delete(s)
            else
              schlinge.fluss[s] = schlinge.fluss[s] - [t]
            end
          end
          # Streiche den Nachbereich von t

          # Streiche den Übergang zum Nachbereich von t
          schlinge.fluss.delete(t)
          # Streiche t
          schlinge.transitionen.delete(t)
        end
      end
    end
  end
end

schlinge.testnetz
schlinge.gv
