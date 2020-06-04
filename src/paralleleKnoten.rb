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

places.each do |s|
  from.each do |f|
    if s == f
      post.append(to[index])
    end
  end

  to.each do |o|
    if s == o
      pre.append(from[index])
    end
  end
  index += 1
end

puts pre
puts post