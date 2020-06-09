# frozen_string_literal: true

require 'C:\Users\Domin\RubymineProjects\reduction-of-petri-nets\petri_netz.rb'
# TODO: Pfad später ändern auf lib, ...

# Testobjekt für diesen Reduktionsschritt
lebendig = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')

# Gehe nacheinander die Transitionen durch und prüfe, ob von ihnen Kanten ausgehen,
# wenn ja, prüfe ob auch Kanten eingehen.
# Sobald eine Kante gefunden wurde, die der Voraussetzung entspricht,
# lösche sie und ihren Nachbereich.
lebendig.transitionen.each do |t|
  lebendig.fluss.each do |von, nach|
    # Falls die Transition bereits im Nachbereich vorkommt,
    # ist die Nachfolgende Überprüfung redundant.
    break if nach.include? t
    # Geht ein Bogen von t aus, so kommt er für die Reduktion in Frage,
    # allerdings gilt jetzt noch zu klären ob auch ein Bogen zu t führt.
    # Ist dem so, wurde kein Reduktionsfall gefunden.
    next unless (von.include? t) && !(nach.include? t)

    # Ist dem so, wurde kein Reduktionsfall gefunden.
    # Andernfalls entferne t, ...
    lebendig.transitionen.delete(t)
    # ... alle Stellen im Nachbereich und ihre Übergänge ...
    lebendig.stellen.each do |s|
      # s ist im Nachbereich von t
      next unless s.to_s == lebendig.fluss[t].join(', ')

      lebendig.fluss.delete(s)
      # lebendig.fluss.values.delete(s)
      lebendig.stellen.delete(s)
    end
    # ... und zum Schluss den an t anhängenden Übergang.
    lebendig.fluss.delete(t)
  end
end

lebendig.testnetz
lebendig.gv
