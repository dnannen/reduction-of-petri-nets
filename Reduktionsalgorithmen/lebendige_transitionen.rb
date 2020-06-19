# frozen_string_literal: true
require File.join(Dir.pwd, 'petri_netz.rb')

# Erzeuge das Petri-Netz
lebendig = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')

# Regel 1:
# Es existiert eine Transition ohne Vorbereich
def reduziere_lebendige_transitionen(lebendig)

  # Prüfe alle Transitionen
  lebendig.transitionen.each do |t|
    # Überspringe t, sofern Übergänge zu t laufen
    next if lebendig.fluss.values.join(', ').include?(t)

    # t kommt im Vorbereich mindestens einer Stelle vor
    next unless lebendig.fluss.key?(t)

    # Da wir vorher alle Transitionen übersprungen haben,
    # die keinen leeren Vorbereich haben, sind ab hier
    # alle Transitionen lebendig.

    # Entferne jede Stelle im Nachbereich von t,
    # mitsamt Übergängen
    lebendig.fluss[t].each do |s|
      lebendig.entferne_stelle(s)
    end

    # Entferne die lebendige Transition t
    lebendig.entferne_transition(t)

    # Zuletzt werden alle isolierten Knoten gestrichen
    lebendig.deisoliere
  end
end