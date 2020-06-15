# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vormitnach = PetriNetz.new('s1:t1,t2;s2:t0;s3:t2;s4:t4;s5:t5;;t0:s1;t1:s4;t2:s5;t4:s2;t5:s2;;', '0,1,0,0,0')

vormitnach.testnetz
vormitnach.gv