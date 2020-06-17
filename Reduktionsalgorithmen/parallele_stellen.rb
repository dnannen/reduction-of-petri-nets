# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
parallel = PetriNetz.new('s1:t3;s2:t3;;t1:s1,s2;t2:s1,s2;t3:;;', '0,1')

# Prüfe je ein Paar an Stellen
parallel.stellen.each_with_index do |s1, i1|
  parallel.stellen.each_with_index do |s2, i2|
    # Ist der Vorbereich identisch?
    next unless parallel.hin[i1] == parallel.hin[i2]

    # Ist auch der Nachbereich identisch?
    if parallel.her[i1] == parallel.her[i2]
      # Streiche die Stelle mit mehr Marken
      # s1 hat mehr Marken und wird entfernt
      if parallel.markierung[i1] > parallel.markierung[i2]
        # Lösche die Stelle aus allen Nachbereichen in denen sie vorkommt
        parallel.entferne_knoten(s1)
        # Lösche den Übergang zum Nachbereich
        parallel.fluss.delete(s1)
        # Lösche die Markierung der Stelle
        parallel.markierung.delete_at(i1)
        # Lösche zum Schluss die Stelle selbst
        parallel.stellen.delete(s2)
      # s2 hat mehr Marken und wird entfernt
      elsif parallel.markierung[i2] > parallel.markierung[i1]
        # Lösche die Stelle aus allen Nachbereichen in denen sie vorkommt
        parallel.entferne_knoten(s2)
        # Lösche den Übergang zum Nachbereich
        parallel.fluss.delete(s2)
        # Lösche die Markierung der Stelle
        parallel.markierung.delete_at(i2)
        # Lösche zum Schluss die Stelle selbst
        parallel.stellen.delete(s2)
      end
    end
  end
end

parallel.testnetz
parallel.gv