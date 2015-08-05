class Player

  attr_reader :name, :color

  def initialize(name, color)
    @name, @color = name, color
  end

  def take_turn
    puts "Which piece would you like to move?"
    s_row = gets.chomp.to_i
    s_col = gets.chomp.to_i
    puts "Move to?"
    e_row = gets.chomp.to_i
    e_col = gets.chomp.to_i
    [[s_row, s_col], [e_row, e_col]]
  end
end
