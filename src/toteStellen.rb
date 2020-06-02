places = %w[s1 s2 s3]
transitions = %w[t1 t2 t3 t4]
flow = %w[t1 s1 s1 t2 t2 s3 s2 t2 t3 s1 s3 t3 s3 t4 t4 s2]

index = 0
from = []
to = []
flow.each do |f|
  if index.even?
    from.append(f)
  else
    to.append(f)
  end
  index += 1
end