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
          # Streiche den Nachbereich von t
          schlinge.fluss[t].each do |s|
            # Streiche die Markierung der Stelle s
            schlinge.markierung.delete(schlinge.stellen.index(s))

            # Streiche alle Übergänge
            schlinge.entferne_knoten(s)

            # Streiche die Stelle selber
            schlinge.stellen.delete(s)
          end
          # Streiche t aus allen Übergängen
          schlinge.entferne_knoten(t)
          # Streiche zum Schluss t
          schlinge.transitionen.delete(t)
        end
      end
    end
  end
end

# Zuletzt werden alle isolierten Knoten gestrichen
schlinge.deisoliere

schlinge.testnetz
schlinge.gv
