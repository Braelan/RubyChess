# require_relative 'piece'
# require_relative 'grid'
load './piece.rb'
load './grid.rb'

class ChessBoard
   include GRID

  BOARD_SIZE = 8

def initialize
  # @grid = Grid.new(BOARD_SIZE,BOARD_SIZE)
  #  @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) { nil} }
  new_grid(BOARD_SIZE)
end

def on_board?(pos)
  pos.all? { |coord| coord.between?(0,BOARD_SIZE - 1)}
end


end
