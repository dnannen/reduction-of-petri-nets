# frozen_string_literal: true

# Importiere die Petri-Netz Klasse, um mit Netzen arbeiten zu können
require File.join(Dir.pwd, 'petri_netz.rb')

# Importiere alle Reduktionsalgorithmen
require File.join(Dir.pwd, 'lebendige_transitionen.rb')
require File.join(Dir.pwd, 'tote_stellen.rb')
require File.join(Dir.pwd, 'parallele_stellen.rb')
require File.join(Dir.pwd, 'aequivalente_stellen.rb')
require File.join(Dir.pwd, 'vor_und_nachtransitionen.rb')
# require File.join(Dir.pwd, 'vor_mit_nachtransitionen.rb')
require File.join(Dir.pwd, 'schlingen.rb')
require File.join(Dir.pwd, 'lauf_stellen.rb')
# require File.join(Dir.pwd, 'vor_mit_nachstellen.rb')

# Beispiel
petrinetz = PetriNetz.new('s1:tp1;sp1:tp2;sp2:tp2;s2:t2;s3:;ts:t1;;tl1:s1;tl2:s1;tp1:sp1,sp2;tp2:s2;t1:s2;t2:s3;;', '1,0,1,0,0,0')
# 's1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1;;', '0,0,0,0'
# 's1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0'

ARGV.each do |arg|
  case arg

    # Regel 1: lebendige Transitionen
  when 'lt'
    reduziere_lebendige_transitionen(petrinetz)

    # Regel 2: tote Stellen
  when 'ts'
    reduziere_tote_stellen(petrinetz)

    # Regel 3: parallele Stellen
  when 'ps'
    reduziere_parallele_stellen(petrinetz)

    # Regel 4: äquivalente Stellen
  when 'aes'
    reduziere_aequivalente_stellen(petrinetz)

    # Regel 5: Vor- und Nachbereich
  when 'vundt'
    verschmelze_vor_und_nachbereich(petrinetz)

    # Regel 6: Vor- mit Nachbereich
  when 'vmitt'
    # verschmelze_vor_mit_nachbereich(petrinetz)

    # Regel 7: Schlingen
  when 's'
    reduziere_schlingen(petrinetz)

    # Regel 8: Laufstellen
  when 'run'
    reduziere_laufstellen(petrinetz)

    # Regel 9: Vor- mit Nachstellen
  when 'vmits'
    # verschmelze_vor_mit_nachstellen(petrinetz)

  else
    # Gebe ohne Parameter das Netz aus
    petrinetz.testnetz
    petrinetz.ausgabe
  end
end

petrinetz.testnetz
petrinetz.ausgabe
