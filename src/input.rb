class Net
  attr_accessor :places, :transitions, :flow, :weight, :marks

  def initialize(one, two, three, four, five)
    self.places = one
    self.transitions = two
    self.flow = three
    self.weight = four
    self.marks = five
  end


end


net = Net.new("", "", "", "", "")

