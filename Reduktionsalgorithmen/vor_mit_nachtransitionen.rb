# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
vormitnach = PetriNetz.new('s1:t1,t2;s2:t0;s3:t2;s4:t4;s5:t5;;t0:s1;t1:s4;t2:s5;t4:s2;t5:s2,s3;;', '0,1,0,0,0')
index = 1

# Regel 6:
# Im Vorbereich von s befindet sich genau eine Transition t.
# Im Nachbereich von t liegt nur die Stelle s.
# Der Nachbereich der Stelle s ist nicht leer.
# An s hängt keine Schlinge.
# Alle Vorbereichsstellen

# Prüfe alle Stellen
vormitnach.stellen.each do |s|
  # Es gibt genau eine Transition im Vorbereich von s
  next unless vormitnach.vorbereich(s).length == 1

  # Der Vorbereich von s hat ausschließlich s im Nachbereich
  next unless vormitnach.fluss[vormitnach.vorbereich(s).join(', ')] == [s]

  # Im Nachbereich von s liegt mindestens eine Transition
  next if vormitnach.fluss[s].nil?

  # Es gibt keine Schlinge an s
  next if vormitnach.vorbereich(s).include?(vormitnach.fluss[s].join(', ')) ||
          vormitnach.fluss[s].include?(vormitnach.vorbereich(s).join(', '))

  # Alle Vorbereichsstellen von t haben nur t im Nachbereich
  fuenf = false
  vormitnach.vorbereich(vormitnach.vorbereich(s).join(', ')).each do |f|
    fuenf = vormitnach.fluss.values_at(f).join(', ') == vormitnach.vorbereich(s).join(', ')
  end
  next unless fuenf

  p s

  # Alle Kanten die s enthalten, haben die selbe Vielfachheit
  next unless vormitnach.fluss[s].all? do |n|
    vormitnach.fluss[s].count(n) ==
    vormitnach.fluss[s].count(vormitnach.fluss[s].last)
  end &&
              vormitnach.vorbereich(s).all? do |v|
                vormitnach.vorbereich(s).count(v) ==
                vormitnach.vorbereich(s).count(vormitnach.vorbereich(s).last)
              end

  # Reduziere die Stelle s
  # Für jede Transition aus dem Nachbereich von s
  # Definiere benötigte Bereiche für später
  vorbereich = []
  nachbereich = []
  vormitnach.fluss[s].each do |n|
    # Führe eine neue Transition t.i ein
    vormitnach.transitionen.append('t.' + index.to_s)

    # Der Vorbereich der neuen Transition besteht aus den Vorbereichen des Vorbereichs von s und dem Nachbereich von s
    # Vorbereich von s

    vorbereich.append vormitnach.vorbereich(vormitnach.vorbereich(s).join(', '))
    # Vorbereiche des Nachbereichs von s
    vorbereich.append(vormitnach.vorbereich(n))
    # Der Nachbereich besteht aus dem Nachbereich der Nachbereiche von s
    nachbereich.append(vormitnach.fluss[n])

    # Füge die neuen Transitionen mitsamt definiertem Vor- und Nachbereich ins Netz ein
    vorbereich.join(', ').split(', ').each do |nv|
      vormitnach.fluss[nv] = vormitnach.fluss[nv] + ['t.' + index.to_s]
      vormitnach.fluss[nv] = vormitnach.fluss[nv] - [s]
    end
    nachbereich.join(', ').split(', ').each do |nn|
      vormitnach.fluss.store(vormitnach.transitionen.last, [nn])
    end

    # Streiche die bereits bearbeitete Nachbereichstransition
    vormitnach.reduziere_knoten(n)

    # Aktualisiere die Variablen für den nächsten Durchlauf
    vorbereich.clear
    nachbereich.clear
    index += 1
  end
  # Streiche die Vorbereichstransition von s
  vormitnach.reduziere_knoten(vormitnach.vorbereich(s).join(', '))

  # Streiche den Knoten s
  vormitnach.reduziere_knoten(s)
end

vormitnach.testnetz
vormitnach.gv('test')
