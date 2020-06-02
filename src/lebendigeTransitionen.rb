places = %w[s1 s2 s3]
transitions = %w[t1 t2 t3 t4]
flow = %w[t1 s1 s1 t2 t2 s3 s2 t2 t3 s1 s3 t3 s3 t4 t4 s2]

index = 0
from = []
to = []
flow.each do |f|
  if index.even?
    from.append(f)
  else
    to.append(f)
  end
  index += 1
end



run = 0
transitions.each do |t|
  # Finde eine Transition ohne Vorbereich
  if from.include?(t) and !(to.include?(t))
    # Lösche die gefundene Transition ...
    transitions.delete(t)
    # ... und ihren Nachbereich
    places.delete_at(run)
  end
  run += 1
end

# Entferne anschließend alle überflüssig gewordenen Bögen
run = 0
from.each do |f|
  unless places.include?(f) || transitions.include?(f)
    from.delete(f)
    to.delete_at(run)
  end
  run += 1
end

run = 0
to.each do |o|
  unless places.include?(o) || transitions.include?(o)
    to.delete(o)
    from.delete_at(run)
  end
  run += 1
end

# Making the graphViz-File
graph = File.new('graph.gv', 'w')

# Hardcoded input for making the file work
graph.puts('digraph petrinet{')
graph.puts('node[shape=circle];')

# Adding places to graphViz-File
places.each do |place|
  graph.print '"'
  graph.print place
  graph.puts '";'
end

# Adding transitions to graphViz-File
transitions.each do |transition|
  graph.print '"'
  graph.print transition
  graph.puts '" [shape=box];'
end

# Adding the flow relation to graphViz-Files
index = 0
from.each do |f|
  graph.print '"'
  graph.print f
  graph.print '"->"'
  graph.print(to[index])
  graph.puts '"'
  index += 1
end

graph.print('}')
graph.close


