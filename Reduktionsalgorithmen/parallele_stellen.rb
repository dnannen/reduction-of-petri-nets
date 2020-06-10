# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
parallel = PetriNetz.new('s1:t3;s2:t3;;t1:s1,s2;t2:s1,s2;t3:;;', '0, 1')

# Um diese Reduktionsregel anzuwenden müssen zunächst alle Stellen miteinander
# geprüft werden, ob sie parallel sind.
# Werden zwei parallele Stellen gefunden wird eine spezielle
# Vorgehensweise implementiert, die weiter unten erklärt ist.

# Doppelschleife um alle Stellen zu testen
parallel.stellen.each do |s1|
  parallel.stellen.each do |s2|
    # Beide Stellen sind gleich, das wollen wir nicht:
    unless s1 == s2
      p s1,s2
    end
  end
end

# parallel.testnetz
# parallel.gv