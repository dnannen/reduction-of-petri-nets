# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vormitnach = PetriNetz.new('s1:t1,t2;s2:t0;s3:t2;s4:t4;s5:t5;;t0:s1;t1:s4;t2:s5;t4:s2;t5:s2,s3;;', '0,1,0,0,0')

# Regel 6:
# Im Vorbereich von s befindet sich genau eine Transition t.
# Im Nachbereich von t liegt nur die Stelle s.
# Der Nachbereich der Stelle s ist nicht leer.
# An s hängt keine Schlinge.
# Alle Vorbereichsstellen
# Prüfe alle Stellen
vormitnach.stellen.each do |s|

  # Es gibt genau eine Transition im Vorbereich von s
  next if vormitnach.vorbereich(s).length > 1

  # Der Vorbereich von s hat ausschließlich s im Nachbereich
  next unless vormitnach.fluss[vormitnach.vorbereich(s).join(', ')] == [s]

  # Im Nachbereich von s liegt mindestens eine Transition
  next if vormitnach.fluss[s].nil?

  # Es gibt keine Schlinge an s
  next if vormitnach.vorbereich(s).include?(vormitnach.fluss[s].join(', ')) ||
          vormitnach.fluss[s].include?(vormitnach.vorbereich(s).join(', '))

  # Alle Vorbereichsstellen von t haben nur t im Nachbereich
  fuenf = true
  vormitnach.vorbereich(s).join(', ').split(', ').each do |v|
    fuenf if s == vormitnach.fluss[v].join(', ')
  end
  next unless fuenf

  # Alle Kanten die s enthalten, haben die selbe Vielfachheit
  vielfachheit = 0


  # Reduziere die Stelle s
  # Für jede Transition aus dem Nachbereich von s
  # Definiere benötigte Bereiche für später
  vorbereich = []
  nachbereich = []
  vormitnach.fluss[s].each_with_index do |n, i|
    # Führe eine neue Transition t. ein
    vormitnach.transitionen.append('t.' + i.to_s)

    # Der Vorbereich der neuen besteht aus den Vorbereichen des Vorbereichs von s und dem Nachbereich von s
    # Vorbereich von s
    vorbereich.append vormitnach.vorbereich(s)
    # Vorbereiche des Nachbereichs von s
    vorbereich.append(vormitnach.vorbereich(n))
    p s
    p vorbereich
  end
end

vormitnach.testnetz
vormitnach.gv('test')