# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
aequivalent = PetriNetz.new('s1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1', '0,1,0,0')

# Zwei parallele Knoten haben jeweils genau eine Transition im Nachbereich,
# die jeweiligen Bögen haben die Vielfachheit 1.
# Die entsprechenden Nachtransitionen haben zu allen anderen Stellen
# entweder identische Verbindung, oder gar keine.



aequivalent.testnetz
aequivalent.gv