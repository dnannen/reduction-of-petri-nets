# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

# Testobjekt für diesen Reduktionsschritt
lebendig = PetriNetz.new('s1:t2;s2:t2;s3:t3,t4;;t1:s1;t2:s3;t3:s1;t4:s2;;', '0,1,0')



# Gehe nacheinander die Transitionen durch und prüfe, ob von ihnen Kanten ausgehen,
# wenn ja, prüfe ob auch Kanten eingehen.
# Sobald eine Kante gefunden wurde, die der Voraussetzung entspricht,
# lösche sie, ihren Nachbereich und alle redundanten Bögen.
lebendig.transitionen.each do |t|
  lebendig.fluss.each do |von, nach|
    # Kommt t im Nachbereich vor, kann woanders weitergesucht werden.
    break if nach.include? t
    # Wird allerdings ein Reduktionsfall gefunden kann reduziert werden.
    next unless von.include? t

    # Prüfe für jede Stelle, ob sie im Nachbereich von t liegt.
    lebendig.stellen.each do |s|
      # Sicherheitsprüfung
      if lebendig.fluss[t].nil?
        break
        # Kommt s im Nachbereich von t vor, müssen s
        # und alle an s hängenden Übergänge aus dem Netz entfernt werden.
      elsif s.to_s == lebendig.fluss[t].join(', ')
        # Entferne die an t anhängenden Bögen
        lebendig.fluss.delete(t)
        # Entferne alle Übergänge mit der Stelle s, ...
        lebendig.fluss.delete_if { |_key, value| value == [s] }
        lebendig.fluss.delete(s)
        # ihre Markierung im Netz ...
        lebendig.markierung.delete_at(lebendig.stellen.find_index(s))
        # ... und zuletzt die Stelle s selbst.
        lebendig.stellen.delete(s)
      end
    end
    # Lösche zum Schluss die Transition t.
    lebendig.transitionen.delete(t)
  end
end
# Fertig!

lebendig.testnetz
lebendig.gv