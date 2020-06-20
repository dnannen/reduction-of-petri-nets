# frozen_string_literal: true

# Importiere die Petri-Netz Klasse, um mit Netzen arbeiten zu können
require File.join(Dir.pwd, 'petri_netz.rb')

# Importiere alle Reduktionsalgorithmen
require File.join(Dir.pwd, 'lebendige_transitionen.rb')
require File.join(Dir.pwd, 'tote_stellen.rb')
require File.join(Dir.pwd, 'parallele_stellen.rb')
require File.join(Dir.pwd, 'aequivalente_stellen.rb')
#require File.join(Dir.pwd, 'vor_und_nachtransitionen.rb')
#require File.join(Dir.pwd, 'vor_mit_nachtransitionen.rb')
#require File.join(Dir.pwd, 'schlingen.rb')
#require File.join(Dir.pwd, 'lauf_stellen.rb')
#require File.join(Dir.pwd, 'vor_mit_nachstellen.rb')

# Erzeuge das Petri-Netz für die Reduktion
petrinetz = PetriNetz.new('s1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1;;', '0,1,0,0')

#reduziere_lebendige_transitionen(petrinetz)

#reduziere_tote_stellen(petrinetz)

#reduziere_parallele_stellen(petrinetz)

reduziere_aequivalente_stellen(petrinetz)

#verschmelze_vor_und_nachbereich(petrinetz)

#verschmelze_vor_mit_nachbereich(petrinetz)

#reduziere_schlingen(petrinetz)

#reduziere_laufstellen(petrinetz)

#verschmelze_vor_mit_nachstellen

petrinetz.testnetz
petrinetz.gv('test')