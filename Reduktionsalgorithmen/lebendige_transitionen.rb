# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
lebendig = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')

# Prüfe für alle Transitionen, ob sie einen leeren Vorbereich hat
lebendig.transitionen.each do |t|
  # t kommt im Nachbereich vor, ...
  next if lebendig.fluss.values.join(', ').include?(t)
  # ... aber nicht im Vorbereich
  next unless lebendig.fluss.key?(t)

  #Für jede Stelle im Nachbereich von t
  lebendig.fluss[t].each do |s|
    lebendig.transitionen.each do |tr|
      # Entferne die Übergänge der Stellen s
      if lebendig.fluss.values_at(tr).join(', ').include?(s)
        # Kommt nur s vor, lösche den Übergang komplett
        if lebendig.fluss.values_at(tr).join(', ') == s
          lebendig.fluss.delete(tr)
        else
          # Ansonsten entferne nur s aus dem Übergang
          lebendig.fluss[tr] = lebendig.fluss[tr] - [s]
        end
      end
    end
    # Lösche den Übergang, die Markierung der entfernten Stellen und die Stelle selbst
    lebendig.fluss.delete(s)
    lebendig.markierung.delete_at(lebendig.stellen.index(s))
    lebendig.stellen.delete(s)
  end
  # Lösche die Transition und die ausgehenden Übergänge
  lebendig.fluss.delete(t)
  lebendig.transitionen.delete(t)
end

lebendig.testnetz
lebendig.gv
