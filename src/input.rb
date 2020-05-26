require 'pp'

# Eingabe des Netzes
puts "Bitte Stellen, Transitionen und Übergänge angeben!"
placestring = gets.chomp
transitionstring = gets.chomp
flowstring = gets.chomp

# Placing the net compartments in arrays
places = placestring.split(',')
transitions = transitionstring.split(',')
flow = flowstring.split(';')

# Making the graphViz-File
graph = File.new("graph.gv","w")

# Hardcoded input for making the file work
graph.puts("digraph petrinet{")
graph.puts("node[shape=circle];")

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

# Adding the flow relation to graphViz-File
flownew = flow.to_s.split(',')
flownew.each do |bow|
  puts bow


  #graph.print '"'
  #graph.print bow
  #graph.print '"->"'
  #graph.print bow
  #graph.puts '"'
end
graph.print('}')
graph.close