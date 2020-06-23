# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

vormitnachstellen = PetriNetz.new('s1:t;s2:t1;s3:t3,t3,t3,t4;s4:t3,t3,t4,t4,t4;s5:t2;;t:s3,s4;t1:s1,s1,s3;t2:s1;t3:s2;t4:s5;;',
                            '2,0,1,0,1')
index = 1

# Regel 9:
#

vormitnachstellen.transitionen.each do |t|
  # t hat genau eine Vorbereichsstelle s
  next if vormitnachstellen.vorbereich(t).length != 1

  # Von s zu t verläuft genau eine Kante und von t verläuft keine Kante zu s
  next unless vormitnachstellen.fluss[vormitnachstellen.vorbereich(t).join(', ')] == [t]
  next if vormitnachstellen.fluss[t].include?(vormitnachstellen.fluss[vormitnachstellen.vorbereich(t).join(', ')])

  # Der Nachbereich der Transition ist nicht leer
  next if vormitnachstellen.fluss[t].nil?

  # Der Vorbereich von s ist nicht leer
  next if vormitnachstellen.vorbereich(vormitnachstellen.vorbereich(t).join(', ')) == []

  # Reduziere die Transition t
  # Schalte t so oft, bis keine Marken mehr auf s liegen
  vormitnachstellen.markierung[vormitnachstellen.stellen.index(vormitnachstellen.vorbereich('t').join(', '))].to_i.times do
    vormitnachstellen.schalte('t')
  end

  vorbereich = []
  nachbereich = []
  # Für jede Vorbereichstransition von t
  vormitnachstellen.vorbereich('t').each do |nt|
    # Führe eine neue Transition t.i ein
    vormitnachstellen.transitionen.append('t-' + index.to_s)

    # Der Vorbereich der neuen Transition übernimmt den Nachbereich der Vorbereichstransition
    vorbereich.append(vormitnachstellen.vorbereich(vormitnachstellen.vorbereich('t').join(', ')).join(', '))

  end


end

vormitnachstellen.testnetz
vormitnachstellen.gv('test')
