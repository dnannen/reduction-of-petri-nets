# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
parallel = PetriNetz.new('s1:t1,t2;s2:t4;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s3;;', '0,1,0,0')

parallel.testnetz
parallel.gv