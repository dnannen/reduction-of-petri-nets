# frozen_string_literal: true

# Importiere die Petri-Netz Klasse, um mit Netzen arbeiten zu können
require File.join(Dir.pwd, 'petri_netz.rb')

# Importiere alle Reduktionsalgorithmen
require File.join(Dir.pwd, 'lebendige_transitionen.rb')
require File.join(Dir.pwd, 'tote_stellen.rb')

# Erzeuge das Petri-Netz für die Reduktion
petrinetz = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')

reduziere_lebendige_transitionen(petrinetz)

#reduziere_tote_stellen(petrinetz)

petrinetz.testnetz
petrinetz.gv