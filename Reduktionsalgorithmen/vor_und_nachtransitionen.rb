# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vorundnach = PetriNetz.new('s1:t1,t2;s2:t4;s3:;s4:t3;;t1:s3;t2:s4;t3:s4,s4;t4:s1,s3;;', '0,1,0,0')

# Regel 5
# Prüfe alle Stellen
# Erstelle ein Array mit den Stellen, die alle Voraussetzungen erfüllen
# Zu Beginn sind alle Stellen Kandidaten
kandidaten = vorundnach.stellen
vorundnach.stellen.each do |s|

  # Prüfe zuerst, ob Vor- oder Nachbereich leer sind
  kandidaten.delete(s) if vorundnach.vorbereich(s) == [] || vorundnach.fluss[s].nil?

  # Es darf keine Schleife an s anliegen
  # Prüfe für jede Transition im Nachbereich
  vorundnach.fluss[s].each do |n|
    # Kommt der Vorbereich im Nachbereich vor?
    next if vorundnach.vorbereich(s).include? n

    # Der Nachbereich vom Nachbereich ist nicht leer
    next if vorundnach.fluss[n].nil?

    # Füge s den Kandidaten hinzu, sofern es noch kein Kandidat ist
    kandidaten.append(s) unless kandidaten.include?(s)
  end

  # Der Vorbereich vom Nachbereich beläuft sich nur auf s

end

p kandidaten

vorundnach.deisoliere

vorundnach.testnetz
vorundnach.gv