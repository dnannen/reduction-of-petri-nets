# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new('s1:t1,t3;s2:t1;s3:t2;;t1:s3;t2:s2;t3:;;', '0,1,1')

# Überprüfe alle Stellen
tot.stellen.each do |s|
  # Prüfe ob s keinen Vorbereich hat
  unless tot.fluss.value?([s])
    tot.transitionen.each do |t|
      # Die Stelle s hat nicht genug Marken um die Transitionen
      # in ihrem Nachbereich schalten zu lassen
      if tot.fluss[s].include?(t) && tot.fluss[s].count(t) > tot.markierung[tot.stellen.index(s)].to_i
        tot.fluss[s].each do |f|
          tot.stellen.each do |st|
            unless tot.fluss[st].nil?
            tot.fluss.delete(st) if tot.fluss[st].include? f
            end
          end
          tot.stellen.delete(s)
          tot.fluss.delete(s)
          tot.transitionen.delete(f)
          tot.fluss.delete(f)

        end


        #p t
        #p tot.fluss[s].count(t)
        #p tot.markierung[tot.stellen.index(s)]
      end
    end
    # Prüfe ob s nicht genug Marken hat um die Transitionen
    # in ihrem Nachbereich schalten zu lassen.
    # p tot.fluss[s]
  end
end

tot.testnetz
tot.gv