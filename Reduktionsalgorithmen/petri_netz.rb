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

    # Erstelle die Matrix her, mit den Einträgen V(t,s)
    @her.clear
    @stellen.each do |s|
      matrix = []
      @transitionen.each do |t|
        matrix.append(@fluss.values_at(s).join(', ').split(', ').count(t))
      end
      @her = @her.append(matrix)
    end

    # Erstelle die Matrix hin, mit den Einträgen V(s,t)
    @hin.clear
    @stellen.each do |s|
      matrix = []
      @transitionen.each_with_index do |t|
        matrix.append(@fluss.values_at(t).join(', ').split(', ').count(s))
      end
      @hin.push matrix
    end
  end

  # Erzeugt die GraphViz-Datei, die das Netz grafisch darstellt
  def gv
    # Erzeugen der Datei und die ersten Zeilen, die die Datei ausmachen
    graph = File.new('petri-netz.gv', 'w')
    graph.puts('digraph petrinet{')
    graph.puts('node[shape=circle];')
    graph.puts('rankdir=LR;')

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


  # --------------------------
  #           UTILS
  # --------------------------


  # Entfernt alle Übergänge die 'knoten' beinhalten
  def entferne_knoten(knoten)
    # Der Knoten k ist eine Stelle,
    # entferne also Stellen aus Übergängen von Transitionen
    if @stellen.include?(knoten)
      @transitionen.each do |t|
        # Entferne die Übergänge der Transition t
        if @fluss.values_at(t).join(', ').include?(knoten)
          # Kommt nur k vor, lösche den Übergang komplett
          if @fluss.values_at(t).join(', ') == knoten
            @fluss.delete(t)
          else
            # Ansonsten entferne nur k aus dem Übergang
            @fluss[t] = @fluss[t] - [knoten]
          end
        end
      end
      @fluss.delete(knoten)
      # Ansonsten: Ist der Knoten k eine Transition?
    elsif @transitionen.include?(knoten)
      @stellen.each do |s|
        # Entferne die Übergänge der Stelle s
        if @fluss.values_at(s).join(', ').include?(knoten)
          # Kommt nur k vor, lösche den Übergang komplett
          if @fluss.values_at(s).join(', ') == knoten
            @fluss.delete(s)
          else
            # Ansonsten entferne nur k aus dem Übergang
            @fluss[s] = @fluss[s] - [knoten]
          end
        end
      end
      @fluss.delete(knoten)
    end
  end

  # Findet den Vorbereich des Knotens k heraus
  def vorbereich(knoten)
    vor = []
    # Ist der Knoten eine Stelle kommen nur Transitionen im Vorbereich vor
    if @stellen.include?(knoten)
      @transitionen.each do |t|
        # Kommt im Nachbereich der Transition der Knoten vor
        if @fluss.values_at(t).join(', ').split(', ').include?(knoten)
          # Füge t zum Vorbereich hinzu
          vor.push(t)
        end
      end
      # Ist der Knoten eine Transition kommen nur Stellen im Vorbereich vor
    elsif @transitionen.include?(knoten)
      @stellen.each do |s|
        # Kommt im Nachbereich der Stelle der Knoten vor
        if @fluss.values_at(s).join(', ').split(', ').include?(knoten)
          # Füge s zum Vorbereich hinzu
          vor.push(s)
        end
      end
    end
    # return vor
    vor
  end

  # Prüfe das Netz auf isolierte Knoten und entferne sie
  def deisoliere
    # Prüfe auf isolierte Stellen
    @stellen.each do |s|
      if !@fluss.values.join(', ').split(', ').include?(s) && !@fluss.keys.include?(s)
        # Es muss nur die Stelle s gelöscht werden
        @stellen.delete(s)
      end
    end
    # Prüfe auf isolierte Transitionen
    @transitionen.each do |t|
      if !@fluss.values.join(', ').split(', ').include?(t) && !@fluss.keys.include?(t)
        # Es muss nur die Transition gelöscht werden.
        @transitionen.delete(t)
      end
    end
  end

  # Gibt den pn-String des Netzes aus
  def pn
    string = ''
    @stellen.each do |s|
      p hin[@stellen.index(s)]
      @transitionen.each_index do |i|
        if hin[@stellen.index(s)][i] > 1
          #TODO
        end
      end
    end
  end

  # Gibt alle Parameter des Netzes aus,
  # um es leichter testen zu können.
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
beispiel = PetriNetz.new('s1:t1,t2;;t1:s1;t2:s1;;', '1')

# Tests
beispiel.deisoliere
#beispiel.pn
#beispiel.testnetz
beispiel.gv