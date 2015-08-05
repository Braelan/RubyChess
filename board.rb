# require_relative 'piece'
# require_relative 'grid'
require_relative 'chess_pieces'
require_relative 'grid'
require 'colorize'


class ChessBoard
   include GRID

   attr_reader :history

  BOARD_SIZE = 8
  PIECES = [Rook,Knight, Bishop, King, Queen, Bishop, Knight, Rook]
  SYMBOLS = {Rook => 'R', Knight => 'H', Bishop => 'B',
    King => 'K', Queen => 'Q', Pawn => 'P', NilClass => ' '}
  BOARD_COLORS = [:light_white, :default]

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
  @history = []
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
  grid.each_with_index do |row, row_idx|
    row_strs = Array.new(3) {""}
    row.each_with_index do |cell, col_idx|
      symbol = render_piece(cell)
      odd = (row_idx + col_idx).odd?
      sym_str = "#{symbol}"
      row_strs[0] += format_str(" ", odd)
      row_strs[1] += format_str(sym_str, odd)
      row_strs[2] += format_str(" ", odd)
    end
    puts row_strs.join("\n")
  end
  nil
end

  def render_piece(cell)
      symbol = SYMBOLS[cell.class]
      return symbol.colorize(cell.color) unless cell.nil?
      symbol
  end

  def format_str(str, alt)
    color = alt ? 0 : 1
    "  #{str}  ".colorize(:background => BOARD_COLORS[color])
  end

  def inspect
    "ChessBoard"
  end

def move(start_pos, end_pos)
  piece = self[*start_pos]
  raise "No piece at #{start_pos}" if piece.nil?   #input is in [row, col] form
  raise "illegal move" unless piece.moves.include?(end_pos)
  take_history(start_pos,end_pos)
  self[*end_pos] = piece
  piece.pos = end_pos
  self[*start_pos] = nil
end

def in_check?(color)
  king_pos = get_kings_position(color)
  cells_any? { |piece| !piece.nil? && piece.moves.include?(king_pos)}
end

def get_kings_position(color)
  king  = cells_select{|cell| cell.is_a?(King) && cell.color == color}[0]
  raise "No #{color} King in the game"  if king.nil?
  king.pos
end

def take_history(start_pos, end_pos)  #positions come in [row,col]
  history << [[start_pos, self[*start_pos]], [end_pos, self[*end_pos]]]
end


  end
