class Net
  attr_accessor :places, :transitions, :flow, :weight, :marks

  def initialize
    puts 'Stellen'
    @places = gets.chomp
    puts 'Transitionen'
    @transitions = gets.chomp
    puts "Flow"
    @flow = gets.chomp
    puts "weight"
    @weight = gets.chomp
    puts "marks"
    @marks = gets.chomp
  end

  puts @marls.inspect
end

Net.new
initialize
