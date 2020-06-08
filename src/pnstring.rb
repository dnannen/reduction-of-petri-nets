pnstring = gets.chomp.split("-m")

# Aufteilen des pn-Strings
pn = pnstring[0]
p = pn.split(";;")[0]
st = p.split('"')[1].split(';')
ts = pn.split(";;")[1].split(';')

# Markierung der Stellen
marken = pnstring[1].delete('"').split(',')


# Ausgabe der GraphViz-Datei
graph = File.new('graph.gv', 'w')

# Die ersten zwei Zeilen für die .dot-Syntax
graph.puts('digraph petrinet{')
graph.puts('node[shape=circle];')

uebergaenge = st.concat ts

puts uebergaenge



graph.print('}')
graph.close