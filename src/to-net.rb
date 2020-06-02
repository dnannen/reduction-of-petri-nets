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
# Change the flow into 'from' and 'to'
flow = flowstring.split(',')
index = 0
from = []
to = []
flow.each do |f|
  if (index.even?)
    from.append(f)
  else
    to.append(f)
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
from.each do

end
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