places = %w[s1 s2]
marks = [0, 1]
transitions = %w[t1 t2 t3]
flow = %w[t1 s1 f t1 s2 f t2 s1 f t2 s2 f s1 t3 f s2 t3 f]

# Die Regel sieht vor, nach parallelen Knoten Ausschau zu halten.
# Alerdings sind hier Stellen und Transitionen getrennt gespeichert.
# Daher werden die Überprüfungen für die beiden unterschiedlichen Arten getrennt.

# Arrays für den Vor- und Nachbereich zweier Transitionen
pres1 = pres2 = []
posts1 = posts2 = []
index = 0
run = 0
flow.each do |f|
  run += 1
  if places.include? f
    # Geht der Bogen von s aus, so ist die Transition dahinter im Nachbereich von s
    if (flow[index - 1] = nil || flow[index - 1] = 'f')
      # Prüfe, ob das Element auch eine Transition ist und welcher Durchlauf
      #
    end
  end




  # Ein Bogen beinhaltet eine Stelle s
  if places.include? f
    # Sofern der Bogen von s ausgeht, ist die Transition dahinter im Nachbereich
    if flow[index - 1] = nil || flow[index - 1] = 'f'
      # Sicherheitsabfrage, ob das Element auch eine Transition ist
      if transitions.include? flow[index + 1]
      pre.append(flow[index + 1])
    end

    # Führt der Bogen zu s, so ist die Transition davor im Nachbereich
      if flow[index + 1] = nil || flow[index + 1] = 'f'
        # Sicherheitsabfrage wie oben
        if transitions.include? flow[index - 1]
          post.append(flow[index - 1])
        end
      end
    end
  end
  index += 1
end

puts pre
#puts post