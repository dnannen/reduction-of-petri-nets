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

