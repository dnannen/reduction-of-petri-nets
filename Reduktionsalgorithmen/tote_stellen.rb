# frozen_string_literal: true

require 'C:\Users\Domin\RubymineProjects\reduction-of-petri-nets\petri_netz.rb'
# TODO: Pfad später ändern auf lib, ...

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new("s1:t1;s2:t3,t4;s3:t1;s4:t4;;t1:s2;t2:s3;t3:s4;t4:s3;;", "0,1,1,0")

tot.stellen.each do |s|

end