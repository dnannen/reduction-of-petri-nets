# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new('s1:t1;s1:t4;s2:t1;s3:t2;;t1:s3;t2:s2;;', '0,1,1,0')

# Array für Nachfolgertransitionen
t = []
# Es werden alle Stellen überprüft.
tot.stellen.each do |s|
  # Kommen die Stellen nicht im Nachbereich vor,
  # ist ihr Vorbereich dementsprechend leer.
  unless tot.fluss.value?([s])
    # Definiere die Nachfolgertransition(en) als Array
    t.push(tot.fluss[s].join(', '))
    p t


  end
end