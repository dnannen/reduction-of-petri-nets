# frozen_string_literal: true

# Importiere die Petri-Netz Klasse, um mit Netzen arbeiten zu können
require File.join(Dir.pwd, 'petri_netz.rb')

# Importiere alle Reduktionsalgorithmen
require File.join(Dir.pwd, 'lebendige_transitionen.rb')
require File.join(Dir.pwd, 'tote_stellen.rb')
require File.join(Dir.pwd, 'parallele_stellen.rb')
require File.join(Dir.pwd, 'aequivalente_stellen.rb')
require File.join(Dir.pwd, 'vor_und_nachtransitionen.rb')
require File.join(Dir.pwd, 'vor_mit_nachtransitionen.rb')
require File.join(Dir.pwd, 'schlingen.rb')
require File.join(Dir.pwd, 'lauf_stellen.rb')
require File.join(Dir.pwd, 'vor_mit_nachstellen.rb')

# Tests
petrinetz = PetriNetz.new('s1:tp1;sp1:tp2;sp2:tp2;s2:t2;s3:;ts:t1;;tl1:s1;tl2:s1;tp1:sp1,sp2;tp2:s2;t1:s2;t2:s3;;', '1,0,1,0,0,0')
# 's1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1;;', '0,0,0,0'
# 's1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0'
# 's1:t1,t2,t2,t3;;t1:s1;t2:s1,s1;t3:s1;t4:', '2'
# 's1:tp1;sp1:tp2;sp2:tp2;s2:t2;s3:;ts:t1;;tl1:s1;tl2:s1;tp1:sp1,sp2;tp2:s2;t1:s2;t2:s3;;', '1,0,1,0,0,0'

ARGV.each do |arg|
  case arg

    # Regel 1: lebendige Transitionen
  when 'lt'
    reduziere_lebendige_transitionen(petrinetz)
    puts("Lebendige Transition(en) reduziert!")

    # Regel 2: tote Stellen
  when 'ts'
    reduziere_tote_stellen(petrinetz)
    puts("Tote Stelle(n) reduziert!")

    # Regel 3: parallele Stellen
  when 'ps'
    reduziere_parallele_stellen(petrinetz)
    puts("Parallele Stelle(n) reduziert!")

    # Regel 4: äquivalente Stellen
  when 'aes'
    reduziere_aequivalente_stellen(petrinetz)
    puts("Aequivalente Stelle(n) reduziert!")

    # Regel 5: Vor- und Nachbereich
  when 'vundt'
    verschmelze_vor_und_nachbereich(petrinetz)
    puts("Vor- und Nachbereichstransition(en) verschmolzen! (Regel 5)")

    # Regel 6: Vor- mit Nachbereich
  when 'vmitt'
    verschmelze_vor_mit_nachbereich(petrinetz)
    puts("Vor- mit Nachbereichstransition(en)! (Regel 6)")

    # Regel 7: Laufstellen
  when 'run'
    reduziere_laufstellen(petrinetz)
    puts("Laufstelle(n) reduziert!")

    # Regel 8: Schlingen
  when 's'
    reduziere_schlingen(petrinetz)
    puts("Schlinge(n) reduziert!")

    # Regel 9: Vor- mit Nachstellen
  when 'vmits'
    # verschmelze_vor_mit_nachstellen(petrinetz)
    # puts("Vor- mit Nachbereichsstelle(n) verschmolzen! (Regel 9)")

    # Gehe alle Reduktionsalgorithmen durch
  when 'a'
    reduziere_lebendige_transitionen(petrinetz)
    reduziere_tote_stellen(petrinetz)
    reduziere_parallele_stellen(petrinetz)
    reduziere_aequivalente_stellen(petrinetz)
    verschmelze_vor_und_nachbereich(petrinetz)
    verschmelze_vor_mit_nachbereich(petrinetz)
    reduziere_schlingen(petrinetz)
    reduziere_laufstellen(petrinetz)
    verschmelze_vor_mit_nachstellen(petrinetz)
  end
end

# Entferne isolierte Knoten und gib das Netz aus
petrinetz.deisoliere
# petrinetz.testnetz
petrinetz.ausgabe
