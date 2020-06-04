# ist s im vorbereich, so ist s auch im nachbereich
# jede Transition kann schalten, die im nachbereich liegt

places = %w[s1]
marks = [2]
transitions = %w[t1 t2 t3 t4]
flow = %w[t1 s1 s1 t1 t2 s1 t2 s1 s1 t2 s1 t2 t3 s1 s1 t3]

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