# frozen_string_literal: true

require 'C:\Users\Domin\RubymineProjects\reduction-of-petri-nets\petri_netz.rb'
# TODO: Pfad später ändern auf lib, ...

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new("s1:t1;s2:t3,t4;s3:t1;s4:t4;;t1:s2;t2:s3;t3:s4;t4:s3;;", "0,1,1,0")

# Es folgt die gleiche Vorgehensweise wie in lebendige_transitionen.rb,
# nur umgedreht und für die Stellen anstatt der Transitionen.
tot.stellen.each do |s|
  tot.fluss.each do |von, nach|
    break if von.include? s
    #
    next unless (nach.include? s) && !(von.include? s)
    #
  end
end