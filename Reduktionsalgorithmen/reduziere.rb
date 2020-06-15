# frozen_string_literal: true

require File.join(Dir.pwd, 'petri_netz.rb')

petrinetz = PetriNetz.new(gets.chomp, gets.chomp)

petrinetz.testnetz
petrinetz.gv