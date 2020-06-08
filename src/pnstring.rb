puts "pn-String eingeben!"
pnstring = gets.chomp.split("-m")
# -p"s1:a,b;s2:c;s3:;;a:s2;b:s3;c:s3;;" -m"1,0,0"

# Aufteilen des pn-Strings
pn = pnstring[0]
p = pn.split(";;")[0]
st = p.split('"')[1].split(';')
stellen = []

puts stellen
puts transitionen
puts marken