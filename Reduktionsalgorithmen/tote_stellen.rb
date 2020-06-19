# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
tot = PetriNetz.new('s1:t1,t3;s2:t1;s3:t2;;t1:s3;t2:s2;t3:;;', '0,1,1')

# Regel 2:
# Es existiert eine Stelle ohne Vorbereich, die nicht ausreichend Marken hat,
# um Transitionen in ihrem Nachbereich schalten zu lassen.
def reduziere_tote_stellen(tot)

  # Prüfe alle Stellen
  tot.stellen.each do |s|
    # Prüfe ob s keinen Vorbereich hat
    next if tot.fluss.value?([s])

    tot.transitionen.each do |t|
      # Die Stelle s hat nicht genug Marken um die Transitionen
      # in ihrem Nachbereich schalten zu lassen
      next unless tot.fluss[s].include?(t) && tot.fluss[s].count(t) > tot.markierung[tot.stellen.index(s)].to_i

      # Für jede Transition im Nachbereich von s
      tot.fluss[s].each do |f|
        tot.stellen.each do |st|
          unless tot.fluss[st].nil?
            # Lösche alle Stellen, die auf Nachbereichstransitionen von s zeigen
            tot.fluss.delete(st) if tot.fluss[st].include? f
          end
        end
        # Entferne die Stelle s
        tot.entferne_stelle(s)
        # Entferne die Nachbereichstransition f
        tot.entferne_transition(f)
      end
    end
  end
end