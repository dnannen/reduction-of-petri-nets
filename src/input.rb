require 'pp'

# Eingabe des Netzes
puts "Bitte Stellen, Transitionen und Übergänge angeben!"
placestring = gets.chomp
transitionstring = gets.chomp
flowstring = gets.chomp

# Placing the net compartments in arrays
places = placestring.split(',')
transitions = transitionstring.split(',')
flow = flowstring.split(';',',')


# Making the graphViz-File
graph = File.new("graph.gv","w")

# Hardcoded input for making the file work
graph.puts("digraph petrinet{")
graph.puts("node[shape=circle];")

places.each do |place|
  graph.print '"'
  graph.print place
  graph.puts '";'
end
transitions.each do |transition|
  graph.print '"'
  graph.print transition
  graph.puts '" [shape=box];'
end


graph.puts flow
graph.close