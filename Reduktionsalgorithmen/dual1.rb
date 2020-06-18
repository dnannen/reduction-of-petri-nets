# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

dual = PetriNetz.new('s1:t1,t5;s2:t2;s3:t4;s4:t3;;t1:s2;t2:s3,s4;t3:s2;t4:s4;t5:;;', '1,0,0,0')

# Dual zur Regel 1 nach Starke90
# Lösche alle Stellen ohne Vorbereich

dual.testnetz
dual.gv