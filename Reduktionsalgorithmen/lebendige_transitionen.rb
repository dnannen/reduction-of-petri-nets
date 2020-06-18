# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
lebendig = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')

# Prüfe für alle Transitionen, ob sie einen leeren Vorbereich hat
lebendig.transitionen.each do |t|
  # t kommt im Nachbereich vor, ...
  next if lebendig.fluss.values.join(', ').include?(t)
  # ... aber nicht im Vorbereich
  next unless lebendig.fluss.key?(t)

  # Für jede Stelle im Nachbereich von t
  lebendig.fluss[t].each do |s|
    # Entferne den Knoten s aus dem Netz
    lebendig.entferne_knoten(s)

  end
  # Entferne die Transition t
  lebendig.entferne_knoten(t)
end

# Zuletzt werden alle isolierten Knoten gestrichen
lebendig.deisoliere

lebendig.testnetz
lebendig.gv
