# require_relative 'piece'
# require_relative 'grid'
require_relative 'chess_pieces'
require_relative 'grid'

class ChessBoard
   include GRID

  BOARD_SIZE = 8
  PIECES = [Rook,Knight, Bishop, King, Queen, Bishop, Knight, Rook]

def initialize
  new_grid(BOARD_SIZE)
end

def on_board?(pos)
  pos.all? { |coord| coord.between?(0,BOARD_SIZE - 1)}
end

def set_board
  set_pawns(6, :black)
  set_pawns(1, :white)
  set_pieces(0, :white)
  set_pieces(7, :black)
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

end


end
