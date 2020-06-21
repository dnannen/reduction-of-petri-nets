# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

vormitnachstellen = PetriNetz.new('s1:t;s2:t1;s3:t3,t3,t3,t4;s4:t3,t3,t4,t4,t4;s5:t2;;t1:s1,s1,s3;t2:s1;t:s3,s4;t3:s2;t4:s5;;',
                            '2,0,1,0,1')

# Regel 9:
#

vormitnachstellen.transitionen.each do |t|
  # t hat genau eine Vorbereichsstelle
  next if vormitnachstellen.vorbereich(t).length != 1


  # Definiere Kontrollwert
  # Von s zu t verläuft genau eine Kante und von t verläuft keine Kante zu s
  voraussetzung = vormitnachstellen.fluss.values_at(vormitnachstellen.vorbereich(t).join(', ')).join(', ').split(', ').length == 1 &&
                  !vormitnachstellen.fluss.values_at(t).join(', ').split(', ').include?(vormitnachstellen.vorbereich(t).join(', '))
  # Überspringe sofern die Regel nicht gilt
  next unless voraussetzung

  # Der Nachbereich der Transition ist nicht leer
  next if vormitnachstellen.fluss[t].nil?

  p t
  vormitnachstellen.schalte(t)

end

vormitnachstellen.testnetz
vormitnachstellen.gv('test')