# require_relative 'piece'
# require_relative 'grid'
require_relative 'chess_pieces'
require_relative 'grid'
require 'colorize'


class ChessBoard
   include GRID

  BOARD_SIZE = 8
  PIECES = [Rook,Knight, Bishop, King, Queen, Bishop, Knight, Rook]
  SYMBOLS = {Rook => 'R', Knight => 'H', Bishop => 'B',
    King => 'K', Queen => 'Q', Pawn => 'P', NilClass => ' '}

def initialize
  new_grid(BOARD_SIZE)
end

def on_board?(pos)
  pos.all? { |coord| coord.between?(0,BOARD_SIZE - 1)}
end

def set_board
  set_pawns(1, :blue)
  set_pawns(6, :red)
  set_pieces(0, :blue)
  set_pieces(7, :red)
end

def set_pawns(row, color)
  direction = row == 1 ? :down : :up
  grid[row].each_with_index do |cell, col|
    cell = Pawn.new([row,col], self, color, direction)
  end

end

def set_pieces(row, color)
  grid[row].each_with_index do |cell, col|
    cell = PIECES[col].new([row,col], self, color)
  end
end

def render
  puts "_"*33
  grid.each do |row|
    row.each do |cell|
      symbol = render_piece(cell)
      print "| #{symbol} "
    end
    print "|\n"
    puts "_"*33
  end
end

  def render_piece(cell)
      symbol = SYMBOLS[cell.class]
      return symbol.colorize(cell.color) unless cell.nil?
      symbol
  end


end
