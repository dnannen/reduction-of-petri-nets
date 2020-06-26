# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# schlinge = PetriNetz.new('s1:t1,t2;s2:t1,t2;;t1:s1,s2;t2:;;', '0,0')

# Regel 8:
# Für Schlingen an Transitionen gilt:
# Der Vorbereich der Transitionen entspricht dem Nachbereich der selben Transition.
# Außerdem existiert eine weitere Transition, deren Vorbereich den Vorbereich der ersten Transition enthält.

def reduziere_schlingen(schlinge)
  # Prüfe jede Transition
  schlinge.transitionen.each do |t|
    # Teste den Nachbereich jeder Transition t
    schlinge.fluss.values_at(t).join(', ').split(', ').each do |n|
      # Prüfe ob der gesamte Nachbereich die Transition im Vorbereich enthält.
      next unless schlinge.fluss.values_at(n).join(', ').split(', ').include?(t)

      # Prüfe ob es eine Transition t0 gibt, die mindestens alle Stellen
      # aus dem Vorbereich von t enthält
      schlinge.transitionen.each do |t0|
        next unless t0 != t

        next unless schlinge.fluss.values_at(n).join(', ').split(', ').include?(t0)

        # Streiche jede Stelle im Nachbereich von t
        schlinge.fluss[t].each do |s|
          schlinge.reduziere_knoten(s)
        end
        # Streiche zuletzt t
        schlinge.reduziere_knoten(t)
      end
    end
  end

  # Fürs Protokoll
  puts("Schlingen reduziert!")
end
