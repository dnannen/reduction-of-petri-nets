places = %w[s1 s2]
marks = [0, 1]
transitions = %w[t1 t2 t3]
flow = %w[t1 s1 f t1 s2 f t2 s1 f t2 s2 f s1 t3 f s2 t3 f]

# Arrays für den Vor- und Nachbereich zweier Transitionen
pre = []
post = []
index = 0
places.each do |s|
  flow.each do |f|
    # Element in der Flussrelation ist eine Stelle
    if s == f
      # Der Bogen geht von s aus
      if (flow[index - 1] = nil || flow[index - 1] = 'f')
        # Sofern das Element eine Transition ist, füge sie zum Nachbereich hinzu
        # Durchlauf
        if run == 0
          posts1.append(flow[index + 1]) if transitions.include? flow[index + 1]
        elsif run == 1
          posts2.append(flow[index + 1]) if transitions.include? flow[index + 1]
        end
        # Führt der Bogen allerdings zu s, ...
      elsif (flow[index + 1] = nil || flow[index + 1] = 'f')
        # Füge die vorherige Transition in den Vorbereich ein,
        # sofern es eine Transition ist
        if run == 0
          pres1.append(flow[index - 1]) if transitions.include? flow[index - 1]
        elsif run == 1
          pres2.append(flow[index - 1]) if transitions.include? flow[index - 1]
        end
      end
    end
  end
  # Erhöhen der Laufnummer
  if run == 0
    run += 1
  elsif run == 1
    run -= 1
  end
end

  puts pres1
  puts pres2
  puts posts1
  puts posts2