class Player

  attr_reader :name, :color

  def initialize(name, color)
    @name, @color = name, color
  end

  def take_turn
    puts "Which piece would you like to move, #{name}?".colorize(color)
    s_row, s_col = gets.chomp.downcase.split("")
    s_col = s_col.to_i - 1

    puts "Move to?".colorize(color)
    e_row, e_col = gets.chomp.downcase.split("")
    e_col = e_col.to_i - 1

    [[s_row, s_col], [e_row, e_col]]
  end
end
