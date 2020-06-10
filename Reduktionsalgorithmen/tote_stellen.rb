# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new('s1:t1,t3;s2:t1;s3:t2;;t1:s3;t2:s2;;', '0,1,1')

# Array für Nachfolgertransitionen
t = []
# Es werden alle Stellen überprüft.
tot.stellen.each do |s|
  # Kommet die Stelle nicht im Nachbereich vor,
  # ist ihr Vorbereich dementsprechend leer.
  unless tot.fluss.value?([s])
    # Nun wird getestet, ob die Stelle denn auch wirklich tot ist.
    if tot.stellen.index(s) < 1
      # Definiere die Nachfolgertransition(en) als Array
      t.push(tot.fluss[s])
      # Für alle Nachbereichstransitionen gilt die selbe Vorgehensweise
      tot.fluss[s].each do |n|
        # Lösche ein- und ausgehende Übergänge
        tot.fluss.delete_if { |_key, value| value == [n] }
        tot.fluss.delete(n)
        # Lösche die Transition
        tot.transitionen.delete(n)
      end
      # Lösche nun alle Elemente, die mit der Stelle s zu tun haben
      tot.fluss.delete(s)
      tot.markierung.delete_at(tot.stellen.index(s))
      tot.stellen.delete(s)
    end
  end
end