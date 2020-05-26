# frozen_string_literal: true
require 'pp'

# Eingabe des Netzes
puts 'Bitte Stellen, Transitionen und Übergänge angeben!'
placestring = gets.chomp
transitionstring = gets.chomp
flowstring = gets.chomp





# Placing the net compartments in arrays
places = placestring.split(',')
transitions = transitionstring.split(',')
flow = flowstring.split(';')

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
flow.to_s.split(',').each do |bow|
  graph.print '"'
  graph.print bow.chomp('[')
  graph.print '"->"'
  graph.print bow.chomp(']')
  graph.puts '"'
end

graph.print('}')
graph.close




