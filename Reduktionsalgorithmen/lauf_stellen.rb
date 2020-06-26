# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# lauf = PetriNetz.new('s1:t1,t2,t2,t3;;t1:s1;t2:s1,s1;t3:s1;t4:', '2')

# Regel 7:
# Es existiert eine Stelle, die alle Transitionen in ihrem Vorbereich in gleichem Maße auch im Nachbereich enthält.
# Die Vielfachheiten sind kleiner oder gleich der Markierung der Stelle

def reduziere_laufstellen(lauf)
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
        lauf.fluss.delete(s2) if lauf.fluss.values_at(s2).join(', ').split(', ').include?(f)
      end
      lauf.fluss.delete(f)
      lauf.transitionen.delete(f)
    end

    # Streiche die Stelle s aus dem Netz
    lauf.reduziere_knoten(s)
  end

  # Fürs Protokoll
  puts("Laufstellen reduziert!")
end
