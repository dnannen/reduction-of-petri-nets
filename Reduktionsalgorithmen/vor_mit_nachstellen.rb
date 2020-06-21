# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

vormitnach = PetriNetz.new('s1:t;s2:t1;s3:t3,t3,t3,t4;s4:t3,t3,t4,t4,t4;s5:t2;;t1:s1,s1,s3;t2:s1;t:s3,s4;t3:s2;t4:s5;;',
                            '2,0,1,0,1')

# Regel 9:
#

vormitnach.transitionen.each do |t|
  # t hat genau eine Vorbereichsstelle
  next if vormitnach.vorbereich(t).length != 1


  # Definiere Kontrollwert
  # Von s zu t verläuft genau eine Kante und von t verläuft keine Kante zu s
  voraussetzung = vormitnach.fluss.values_at(vormitnach.vorbereich(t).join(', ')).join(', ').split(', ').length == 1 &&
                  !vormitnach.fluss.values_at(t).join(', ').split(', ').include?(vormitnach.vorbereich(t).join(', '))
  # Überspringe sofern die Regel nicht gilt
  next unless voraussetzung

  # Der Nachbereich der Transition ist nicht leer
  next if vormitnach.fluss[t].nil?

  p t
  vormitnach.schalte(t)

end

vormitnach.testnetz
vormitnach.gv('test')