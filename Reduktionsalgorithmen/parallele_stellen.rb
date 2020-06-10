# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
parallel = PetriNetz.new('s1:t3;s2:t3;;t1:s1,s2;t2:s1,s2;t3:;;', '0, 1')