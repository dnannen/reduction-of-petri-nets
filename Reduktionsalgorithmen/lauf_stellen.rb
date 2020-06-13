# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

lauf = PetriNetz.new('s1:t1,t2,t2,t3;;t1:s1;t2:s1,s1;t3:s1;t4:', '2')

# Prüfe jede Stelle
lauf.stellen.each do |s|
  # Vorbereich identisch mit Nachbereich
  next unless lauf.hin[lauf.stellen.index(s)] == lauf.her[lauf.stellen.index(s)]

  lauf.hin.join(', ').split(', ').each do |h|
    # s hat genua Marken um theoretisch beliebige Transitionen zu schalten
    break if lauf.markierung[lauf.stellen.index(s)] < h
  end
  # Lösche alle Übergänge, die den Nachbereich von s beinhalten
  lauf.fluss.values_at(s).join(', ').split(', ').each do |f|
    lauf.stellen.each do |s2|
      if lauf.fluss.values_at(s2).join(', ').split(', ').include?(f)
        lauf.fluss.delete(s2)
      end
    end
    lauf.fluss.delete(f)
    lauf.transitionen.delete(f)
  end

  # Lösche auch alle isolierten Transitionen
  lauf.transitionen.each do |t|
    if lauf.fluss.values_at(t).join(', ').empty? && lauf.fluss.key(t).nil?
      lauf.transitionen.delete(t)
    end
  end

  # Lösche die Stelle s, ihre Markierung und ihre Übergänge
  lauf.markierung.delete_at(lauf.stellen.index(s))
  lauf.fluss.delete(s)
  lauf.stellen.delete(s)
end

lauf.testnetz
# lauf.gv
