# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vormitnach = PetriNetz.new('s1:t1,t2;s2:t0;s3:t2;s4:t4;s5:t5;;t0:s1;t1:s4;t2:s5;t4:s2;t5:s2;;', '0,1,0,0,0')

# Regel 6
# # Erstelle ein Array mit den Stellen, die alle Voraussetzungen erfüllen.
kandidaten = []
# Prüfe alle Stellen
vormitnach.stellen.each do |s|

  # Es gibt genau eine Transition im Vorbereich von s
  next if vormitnach.vorbereich(s).length > 1 || vormitnach.vorbereich(s) == []

  # Der Vorbereich von s hat ausschließlich s im Nachbereich
  next if vormitnach.fluss[vormitnach.vorbereich(s).join(', ')] == s

  # Im Nachbereich von s liegt mindestens eine Transition
  next if vormitnach.fluss[s].join(', ').length.nil?

  # Es gibt keine Schlinge an s
  next if vormitnach.vorbereich(s).include? vormitnach.fluss[s].join(', ')

  # Sofern die Stelle alle vier oberen Voraussetzungen erfüllt,
  # füge sie der vorläufigen Kandidatenliste hinzu
  kandidaten.append(s)
end

# Gehe nun alle Kandidaten durch
kandidaten.each do |k|
  # Alle Vorbereichsstellen haben
end

vormitnach.testnetz
vormitnach.gv('test')