class PetriNetz
  attr_accessor :pnstring, :stellen, :transitionen, :fluss, :markierung, :anzahl_stellen, :anzahl_transitionen

  # Initialisiert das Petri-Netz-Objekt
  def initialize(pnstring, marken)
    @pnstring = pnstring
    @stellen = []
    @transitionen = []
    @fluss = Hash.new
    @markierung = marken.split(',')

    # Aufteilen des pn-Strings in die entsprechenden Nachbarlisten.
    # Diese werden weiter unten verarbeitet und in die Arrays der entsprechenden Knoten geschrieben.
    nachbarliste_stellen = pnstring.split(';;')[0].split(';')
    nachbarliste_transitionen = pnstring.split(';;')[1].split(';')

    # Füllt das Array für die Stellen.
    # Fügt die von den Stellen ausgehenden Übergänge dem Fluss hinzu.
    nachbarliste_stellen.each do |nachbar|
      teile = nachbar.split(":")
      @stellen.push(teile[0])
      if (teile.length > 1)
        @fluss[teile[0]] = teile[1].split(",")
      end
    end

    # Füllt das Array für die Transitionen.
    # Fügt die von den Transitionen ausgehenden Übergänge dem Fluss hinzu.
    nachbarliste_transitionen.each do |nachbar|
      teile = nachbar.split(":")
      @transitionen.push(teile[0])
      if (teile.length > 1)
        @fluss[teile[0]] = teile[1].split(",")
      end
    end
    @anzahl_stellen = @stellen.length
    @anzahl_transitionen = @transitionen.length
  end
end

# Testobjekt
beispiel = PetriNetz.new("s1:a,b;s2:c;s3:;;a:s2;b:s3;c:s3;;", "1,0,0")

# Tests
p beispiel.fluss
p beispiel.stellen
p beispiel.transitionen
p beispiel.markierung
p beispiel.anzahl_stellen
p beispiel.anzahl_transitionen