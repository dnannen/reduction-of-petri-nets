# frozen_string_literal: true

class PetriNetz
  attr_accessor :pnstring, :stellen, :transitionen, :fluss, :markierung,
                :anzahl_stellen, :anzahl_transitionen,
                :hin, :her

  # Initialisiert das Petri-Netz-Objekt
  def initialize(pnstring, marken)
    @pnstring = pnstring
    @stellen = []
    @transitionen = []
    @fluss = {}
    @markierung = marken.split(',')
    @hin = []
    @her = []

    # Aufteilen des pn-Strings in die entsprechenden Nachbarlisten.
    # Diese werden weiter unten verarbeitet und in die Arrays der entsprechenden Knoten geschrieben.
    nachbarliste_stellen = pnstring.split(';;')[0].split(';')
    nachbarliste_transitionen = pnstring.split(';;')[1].split(';')

    # Füllt das Array für die Stellen.
    # Fügt die von den Stellen ausgehenden Übergänge dem Fluss hinzu.
    nachbarliste_stellen.each do |nachbar|
      teile = nachbar.split(':')
      @stellen.push(teile[0])
      @fluss[teile[0]] = teile[1].split(',') if teile.length > 1
    end

    # Füllt das Array für die Transitionen.
    # Fügt die von den Transitionen ausgehenden Übergänge dem Fluss hinzu.
    nachbarliste_transitionen.each do |nachbar|
      teile = nachbar.split(':')
      @transitionen.push(teile[0])
      @fluss[teile[0]] = teile[1].split(',') if teile.length > 1
    end
    @anzahl_stellen = @stellen.length
    @anzahl_transitionen = @transitionen.length

    # Erstelle die Matrix hin, mit den Einträgen f(t,s)
    @stellen.each do |s|
      matrix = []
      @fluss.values_at(s).each_with_index do |f, i|
        if f.nil?
          stellen.each do
            matrix.append(0)
          end
        else
          @transitionen.each do |t|
            if f[i] == t
              matrix.append(1)
            else
              matrix.append(0)
            end
          end
        end
      end
      her.append(matrix)
    end

    # Erstelle die Matrix hin, mit den Einträgen f(t,s)
    @transitionen.each do |t|
      matrix = []
      @fluss.values_at(t).each do |f|
        if f.nil?
          stellen.each do
            matrix.append(0)
          end
        else
          @stellen.each_with_index do |s, i|
            if f[i] == s
              matrix.append(1)
            else
              matrix.append(0)
            end
          end
        end
      end
      hin.append(matrix)
    end
  end

  # Erzeugt die GraphViz-Datei, die das Netz grafisch darstellt
  def gv
    # Erzeugen der Datei und die ersten Zeilen, die die Datei ausmachen
    graph = File.new('petri-netz.gv', 'w')
    graph.puts('digraph petrinet{')
    graph.puts('node[shape=circle];')

    # Fügt der Datei die Stellen gemäß der Syntax hinzu
    @stellen.each do |s|
      graph.puts '"' + s + '";'
    end

    # Fügt der Datei die Transitionen gemäß der Syntax hinzu
    @transitionen.each do |t|
      graph.puts '"' + t + '" [shape=box];'
    end

    # Fügt die Übergänge aus der Flussrelation gemäß der Syntax hinzu
    @fluss.each do |key, value|
      # Fallunterscheidung:
      # Hat ein Knoten mehrere Nachfolger, müssen alle einzeln eingetragen werden
      if value.length > 1
        value.each do |v|
          graph.puts '"' + key.to_s + '"->"' + v + '"'
        end
      # Ansonsten ist keine Sonderbehandlung nötig
      else
        graph.puts '"' + key.to_s + '"->"' + value.join(', ') + '"'
      end
    end

    # Syntaktisches Ende der Datei und Ausgabe
    graph.print('}')
    graph.close
  end

  def testnetz
    p @fluss
    p @stellen
    p @transitionen
    p @markierung
    p @hin
    p @her
  end
end

# Testobjekt
beispiel = PetriNetz.new('s1:t1;s2:t1;s3:t2;s4:t2;s5:t3;s6:t3;;t1:s3,s4;t2:s5,s6;t3:s1,s2;;', '1,1,0,0,0,0')

# Tests
beispiel.testnetz
# beispiel.gv