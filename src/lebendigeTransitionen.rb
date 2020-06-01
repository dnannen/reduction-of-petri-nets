places = %w[s1 s2 s3]
transitions = %w[t1 t2 t3 t4]
flow = %w[t1 s1 f s1 t2 f t2 s3 f s2 t2 f t3 s1 f s3 t3 f s3 t4 f t4 s2 f]

index = 0
reduce = false
transitions.each do |t|
  if flow[index] == t and (flow[index - 1] = nil || flow[index - 1] = 'f')
    # t ist Sartpunkt eines Übergangs
    transitions.delete(t)
    flow.delete_at(index)
    flow.delete_at(index + 1)
    flow.delete_at(index + 2)
    places.each do |s|
      if flow[index + 1] == s
        places.delete(s)
      end
    end
  end
  index += 1
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
first = true
flow.each do
  if flow[index].to_s == 'f'
    first = true
    index += 1
  end
  if first == true
    graph.print '"'
    graph.print flow[index]
    graph.print '"->"'
    first = false
  else
    graph.print flow[index]
    graph.puts '"'
  end
  index += 1
end

graph.print('}')
graph.close