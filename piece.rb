require 'byebug'

class Piece
  attr_accessor :pos
  attr_reader :board, :color

  ORTHAGONAL_DELTAS = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  DIAGONAL_DELTAS = [[1,1], [1,-1], [-1,-1], [-1, 1]]
  KNIGHT_DELTAS = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
  PAWN_DELTAS = [[1, -1], [1, 0], [2,0], [1,1]]

  def initialize(position, board, color)
    @pos, @board, @color = position, board, color
  end

  def moves
    sigma_deltas().map {|delta| transform(delta)}
  end

  def sigma_deltas
     [[0,0]]
  end

  def transform(delta)
    [delta[0] + pos[0], delta[1] + pos[1]]
  end

  def enemy?(pos)
    return false if board[*pos].nil?
    board[*pos].color != self.color
  end
end

class SlidingPiece < Piece

  def look(delta_new, delta1 = nil)
    new_pos = transform(delta_new)
    delta1 ||= delta_new
    return [] unless board.on_board?(new_pos)
    if !board[*new_pos].nil?
      return enemy?(new_pos) ? [delta_new] : []
    end
    next_delta = [delta1[0] + delta_new[0], delta1[1] + delta_new[1]]
    next_space = look(next_delta,delta1)
    output = next_space
    output << delta_new

    # => Array of moves in delta's direction
  end

  def sigma_deltas()
    total_moves = []
    (self.deltas).each do |delta|
        total_moves += look(delta)
      end
      total_moves
  end
end

class Queen < SlidingPiece

  def deltas
   ORTHAGONAL_DELTAS + DIAGONAL_DELTAS
  end
end


class Rook < SlidingPiece

  def deltas
    ORTHAGONAL_DELTAS
  end
end

class Bishop < SlidingPiece

  def deltas
    DIAGONAL_DELTAS
  end
end

class SteppingPiece < Piece

  def moves
    super.select {|move| board.on_board?(move) && (board[*move].nil? || enemy?(move))}
  end

  def sigma_deltas
    self.deltas
  end

end


class Knight < SteppingPiece

  def deltas
    KNIGHT_DELTAS
  end

end

class King < SteppingPiece
  def deltas
    ORTHAGONAL_DELTAS + DIAGONAL_DELTAS
  end
end

class Pawn < SteppingPiece

  def initialize(pos, board, color, orientation)
    super(pos, board, color)
    @deltas = PAWN_DELTAS
    @orientation = orientation
  end

  def deltas
    PAWN_DELTAS
  end

  def switch
    @deltas.map! { |delta| [delta[0] * (-1), delta[1]]  } if @orientation == :up
  end


  def moves
    debugger
    all_moves = super
    moves = all_moves.select{|position| pawn_move?(position)}
  end

  def pawn_move?(position)
    dx,dy = position[0] - pos[0], position[1] - pos[1]
    return false if dx**2 == 4 && !(pos[0] == 1|| pos[0] == 6)
    return false if dx*dy**2 == 1 && !enemy?(position)
    return false if (dx + dy) == 1 && enemy?(position)
    true
  end
end
