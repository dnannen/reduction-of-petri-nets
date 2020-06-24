# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# vormitnachstellen = PetriNetz.new('s1:t;s2:t1;s3:t3,t3,t3,t4;s4:t3,t3,t4,t4,t4;s5:t2;;t:s3,s4;t1:s1,s1,s3;t2:s1,s4,s4;t3:s2;t4:s5;;',
#                                  '2,0,1,0,1')

# Regel 9:
# Eine Transition t mit genau einer Vorbereichsstelle  und nichtleerem Nachbereich
# hat mindestens eine Vorbereichstransition t.

def verschmelze_vor_mit_nachstellen(vormitnachstellen)
  index = 1
  # Prüfe alle Transitionen
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
    vormitnachstellen.markierung[vormitnachstellen.stellen.index(vormitnachstellen.vorbereich(t).join(', '))].to_i.times do
      vormitnachstellen.schalte(t)
    end

    vorbereich = []
    nachbereich = []
    # Für jede Vorbereichstransition von s
    vormitnachstellen.vorbereich(vormitnachstellen.vorbereich(t).join(', ')).each do |vt|
      # Führe eine neue Transition t.i ein
      vormitnachstellen.transitionen.append('t-' + index.to_s)

      # Der Vorbereich der neuen Transition übernimmt den Nachbereich der Vorbereichstransition
      vorbereich.append(vormitnachstellen.vorbereich(vt).join(', '))

      # Der Nachbereich setzt sich zusammen aus folgenden Teilen:
      # V(t',s)-mal wird ein Übergang zum Nachbereich von t eingefügt ...
      vormitnachstellen.fluss.values_at(vt).join(', ').split(', ').count(vormitnachstellen.vorbereich(t).join(', ')).times do
        nachbereich.append(vormitnachstellen.fluss[t].join(', '))
      end
      # ... und aus den bereits bestehenden Vorbereichen der Transitionen ausgenommen der Stelle s
      vormitnachstellen.fluss.values_at(vt).join(', ').split(', ').each do |nb|
        next if vormitnachstellen.vorbereich(t).join(', ') == nb

        nachbereich.append(nb)
      end

      # Füge die Übergänge zu den Vor- und Nachbereich der neuen Transitionen ein
      vorbereich.join(', ').split(', ').each do |nv|
        vormitnachstellen.fluss[nv] = vormitnachstellen.fluss[nv] + ['t-' + index.to_s]
      end
      vormitnachstellen.fluss.store(vormitnachstellen.transitionen.last, nachbereich.join(', ').split(', '))

      # Streiche die bereits bearbeitete Vorbereichstransition
      vormitnachstellen.reduziere_knoten(vt)

      # Aktualisiere die Variablen für den nächsten Durchlauf
      vorbereich.clear
      nachbereich.clear
      index += 1
      reduziert = true
    end
    # Streiche die Vorbereichstransition von s
    vormitnachstellen.reduziere_knoten(vormitnachstellen.vorbereich(t).join(', '))

    # Streiche den Knoten s
    vormitnachstellen.reduziere_knoten(t)
  end
end
