def class
  @name = "beispiel"
  @pnstring = '-p"s1:a,b;s2:c;s3:;;a:s2;b:s3;c:s3;;" -m"1,0,0"'
  @stellen = ["s1", "s2", "s3", "s4", "s5", "s6"]
  @transen = ["t1", "t2", "t3"]
  @fluss = {"s1"=>["t1"], "s2"=>["t1"], "s3"=>["t2"], "s4"=>["t2"], "s5"=>["t3"], "s6"=>["t3"], "t1"=>["s3", "s4"], "t2"=>["s5", "s6"], "t3"=>["s1", "s2"]}
  @anz_stellen = @stellen.length
  @anz_transen = @transen.length
  @hin = [[0, 0, 1], [0, 0, 1], [1, 0, 0], [1, 0, 0], [0, 1, 0], [0, 1, 0]]
  @her = [[1, 0, 0], [1, 0, 0], [0, 1, 0], [0, 1, 0], [0, 0, 1], [0, 0, 1]]
  @markierung =  [1, 1, 0, 0, 0, 0]
end