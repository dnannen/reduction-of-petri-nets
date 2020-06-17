# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0')

# Regel 5
# Prüfe alle Stellen
vorundnach.stellen.each do |s|
  # Sind vor oder Nachbereich leer kann weitergesucht werden
  unless vorundnach.fluss[s].nil?
    next if vorundnach.vorbereich(s) == [] || vorundnach.fluss[s].join(', ').split(', ') == []

    # Es gibt keine Schleife an s
    next if vorundnach.vorbereich(s) == vorundnach.fluss[s].join(', ').split(', ')
  end

end

vorundnach.deisoliere

vorundnach.testnetz
vorundnach.gv