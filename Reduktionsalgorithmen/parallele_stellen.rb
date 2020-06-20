# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
parallel = PetriNetz.new('s1:t3;s2:t3;;t1:s1,s2;t2:s1,s2;t3:;;', '0,1')

# Regel 3:
# Sind Vor- und Nachbereich zweier Stellen identisch,
# reduziere die stärker markierte Stelle.
def reduziere_parallele_stellen(parallel)
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
          parallel.reduziere_knoten(s1)

        # s2 hat mehr Marken und wird entfernt
        elsif parallel.markierung[i2] > parallel.markierung[i1]
          # Lösche die Stelle aus allen Nachbereichen in denen sie vorkommt
          parallel.reduziere_knoten(s2)

        end
      end
    end
  end
end