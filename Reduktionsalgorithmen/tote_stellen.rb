# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new('s1:t1,t3;s2:t1;s3:t2;;t1:s3;t2:s2;t3:;;', '0,1,1')

# Regel 2:
# Es existiert eine Stelle ohne Vorbereich, die nicht ausreichend Marken hat,
# um Transitionen in ihrem Nachbereich schalten zu lassen.

# Das Vorgehen hier ist wiefolgt:
# Treffen alle Voraussetzungen auf eine Stelle zu, füge diese zu einem Array hinzu.
# Reduziere später alle Stellen in diesem Array.
def reduziere_tote_stellen(tot)
  # Erstelle ein Array aus Reduktionskandidaten
  kandidaten = []
  # Prüfe alle Stellen
  tot.stellen.each do |s|
    # Prüfe ob s keinen Vorbereich hat
    next if tot.vorbereich(s) != []

    # Füge eine Kontrollvariable ein
    gilt = false
    tot.her[tot.stellen.index(s)].each do |h|
      # Sofern s keinen Übergang zu h hat kann sie ignoriert werden.
      next if h.zero?

      # Hat s nicht genug Marken um mindestens eine Transition schalten zu können
      gilt = h > tot.markierung[tot.stellen.index(s)].to_i
    end
    kandidaten.append(s) if gilt && !kandidaten.include?(s)
  end

  # Reduziere alle gefundenen Kandidaten
  kandidaten.each do |k|
    tot.fluss[k].each do |t|
      tot.reduziere_knoten(t)
    end
    tot.reduziere_knoten(k)
  end
end
