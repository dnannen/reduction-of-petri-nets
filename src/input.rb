puts("String eingeben!")
pm = gets.chomp


places = gets.chomp
allPlaces = []
transitions = gets.chomp
flow = gets.chomp

graph = File.new("graph.gv","w")
graph.puts(places)
graph.puts(transitions)
graph.puts(flow)
graph.close

puts places
puts transitions
puts flow

