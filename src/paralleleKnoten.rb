places = %w[s1 s2]
marks = [0, 1]
transitions = %w[t1 t2 t3]
flow = %w[t1 s1 t1 s2 t2 s1 t2 s2 s1 t3 s2 t3]

index = 0
from = []
to = []
flow.each do |f|
  if(index.even?)
    from.append(f)
  else
    to.append(f)
  end
  index += 1
end

# Vor- und Nachbereiche der Stellen füllen
pre = post = []
index = 0

# Fülle Nachbereich
from.each do |f|
  if places.include?(f)
    post.append(to[index])
  end
end
post.append('f')

# Fülle Vorbereich
to.each do |o|
  if places.include?(o)
    pre.append(from[index])
  end
end
pre.append('f')

puts pre
puts 'uwu'
puts post