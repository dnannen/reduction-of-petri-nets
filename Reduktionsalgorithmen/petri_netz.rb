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
      @transitionen.each do |t|
        matrix.append(@fluss.values_at(t).join(', ').split(', ').count(s))
      end
      @hin.push matrix
    end
  end

  # Erzeugt die GraphViz-Datei, die das Netz grafisch darstellt
  def gv(name)
    # Erzeugen der Datei und die ersten Zeilen, die die Datei ausmachen
    graph = File.new(name + '.gv', 'w')
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

  # Schaltet die Transition einmal
  # Die Prüfung, ob die Transition schalten kann erfolgt vorher
  def schalte(transition)
    vorbereich(transition).each do |v|
      # Füge eine Marke in jede Nachbereichstransition ein
      @fluss.values_at(transition).join(', ').split(', ').each do |n|
        @markierung[@stellen.index(n)] = @markierung[@stellen.index(n)].to_i + 1
      end
      # Entfernt eine Marke aus der Vorbereichsstelle
      @markierung[@stellen.index(v)] = @markierung[@stellen.index(v)].to_i - 1
    end
  end

  # Entfernt den angegebenen Knoten mitsamt Übergängen
  def reduziere_knoten(knoten)
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

      # Entfernt die Markierung der Stelle
      @markierung.delete_at(@stellen.index(knoten))

      # Entfernt die Übergänge zum Nachbereich der Stelle
      @fluss.delete(knoten)

      # Entfernt die Stelle selber
      @stellen.delete(knoten)

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

      # Entfernt die Übergänge zum Nachbereich der Stelle
      @fluss.delete(knoten)

      # Entfernt die Transition selber
      @transitionen.delete(knoten)
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

  def update_pn
    # Definiere den Ausgabestring
    string = ''
    # Starte mit den Stellen
    @stellen.each do |s|
      # Füge den Ausgangsknoten gemäß der Syntax ein
      string += s + ':'
      @fluss.values_at(s).join(', ').split(', ').each do |v|
        string += if @fluss.values_at(s).join(', ').split(', ').last == v
                    v
                  else
                    v + ','
                  end
      end
      string += ';'
      # Füge bei der letzten Stelle die Trennung ein
      string += ';' if s == @stellen.last
    end

    # Fahre mit den Transitionen fort
    @transitionen.each do |t|
      # Füge den Ausgangsknoten gemäß der Syntax ein
      string += t + ':'
      @fluss.values_at(t).join(', ').split(', ').each do |v|
        string += if @fluss.values_at(t).join(', ').split(', ').last == v
                    v
                  else
                    v + ','
                  end
      end
      string += ';'
    end
    # Beende den pn-String und gebe ihn aus
    string += ';'
    @pnstring = string
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

  # Gibt nur den pn-String aus, um ausgegeben oder weiterverarbeitet zu werden
  def ausgabe
    p @pnstring
    p @markierung
    gv('Ausgabe')
  end
end

# Testobjekt
beispiel = PetriNetz.new('s1:t1,t3;s2:;s3:t2;;t1:s3;t2:s2;t3:;;', '0,1,1')
