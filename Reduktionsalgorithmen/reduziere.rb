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

# Dem Nutzer wird gesagt, wie das Petri-Netz eingegeben werden soll.
puts("Bitte den pn-String und anschließend die Markierung als String eingeben, Beispiel:")
puts("s1:t2;s2:t3;s3:t1;s4:t4;;t1:s2;t2:s4;t3:s4;t4:s1;; und als Markierung 0,0,0,0")
puts("Für Hilfe beim Reduzieren, der Funktion Parameter 'help' übergeben.")
petrinetz = PetriNetz.new(gets.chomp, gets.chomp)

# Gehe die angegebenen Funktionsparameter durch
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
    verschmelze_vor_mit_nachbereich(petrinetz)

    # Regel 7: Laufstellen
  when 'run'
    reduziere_laufstellen(petrinetz)

    # Regel 8: Schlingen
  when 's'
    reduziere_schlingen(petrinetz)

    # Regel 9: Vor- mit Nachstellen
  when 'vmits'
    verschmelze_vor_mit_nachstellen(petrinetz)

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

    # Gibt dem Nutzer Hilfestellung, sofern kein Parameter fürs Reduzieren übergeben wurde
  when 'help'
    puts("Das erste Mal hier? So wird reduziert:")
    puts("Einfach die Abkürzung des Namen vom Reduktionsschritt hinter der Funktion eingeben:")
    puts("lt - Lebendige Transitionen")
    puts("ts - Tote Stellen")
    puts("ps - Parallele Stellen")
    puts("aes - Aequivalente Stellen")
    puts("vundt - Verscmhelze Vor- und Nachbereichstransitionen (Regel 5")
    puts("vmitt - Verschmelze Vor- mit Nachbereichstransitionen (Regel 6")
    puts("run - Reduziere Laufstellen")
    puts("s - Reduziere Schlingen")
    puts("vmits - Verschmelze Vor- mit Nachbereichsstellen (Regel 9)")
    puts("Für genaue Ausgabe des Netzes bitte 'test' als Parameter eingeben.")

    # Genauere Ausgabe für Testzwecke. Gibt alle Teilaspekte des Netzes mit aus.
  when 'test'
    petrinetz.testnetz
  end
end

# Entferne zum Schluss alle isolierte Knoten und gib das Netz aus.
petrinetz.deisoliere
petrinetz.ausgabe
