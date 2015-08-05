class Piece
  attr_accessor :pos
  attr_reader :board, :color

  ORTHAGONAL_DELTAS = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  DIAGONAL_DELTAS = [[1,1], [1,-1], [-1,-1], [-1, 1]]
  KNIGHT_DELTAS = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
  PAWN_DELTAS = [[1, -1], [1, 0], [2,0], [1,1]]

  def initialize(position, board, color)
    raise 'Position must be within board' unless board.on_board?(position)
    @pos, @board, @color = position, board, color
    board[*position] = self
  end

  def moves
    sigma_deltas().map {|delta| transform(delta)}.select(&move_criteria)
  end

  def inspect
    "Type => #{self.class}, Color => #{color}"
  end

  def sigma_deltas
     [[0,0]]
  end

  def transform(delta)
    [delta[0] + pos[0], delta[1] + pos[1]]
  end

  def derive_delta(other_pos)
    [other_pos[0] - pos[0], other_pos[1] - pos[1]]
  end

  def enemy?(pos)
    return false if empty?(pos)
    board[*pos].color != self.color
  end

  def empty?(pos)
    board[*pos].nil?
  end

  def can_move_to?(pos)
    empty?(pos) || enemy?(pos)
  end

  def move_criteria
    Proc.new do |move|
      board.on_board?(move) && can_move_to?(move)
    end
  end
end

class SlidingPiece < Piece

  def look(delta_new, delta1 = nil)
    new_pos = transform(delta_new)
    delta1 ||= delta_new
    return [] if stop_at?(delta_new)
    next_delta = [delta1[0] + delta_new[0], delta1[1] + delta_new[1]]
    next_space = look(next_delta,delta1)
    output = next_space
    output << delta_new
    # => Array of moves in delta's direction
  end

  def stop_at?(delta)
    new_pos = transform(delta)
    return true unless board.on_board?(new_pos)
    return false if can_move_to?(new_pos)
    true
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
    @orientation = orientation
  end



  def deltas
    PAWN_DELTAS.map { |delta| [delta[0] * (direction), delta[1]] }
  end

  def pawn_move?(position)
    dx,dy = derive_delta(position)
    return false if dx**2 == 4 && !(pos[0] == 1|| pos[0] == 6) # evaluate [2,0] pos must equal [1,*] or [6,*]
    return false if (dx*dy)**2 == 1 && !enemy?(position) # evaluate [1,1] & [1,-1] there must be an enemy at position
    return false if (dx + dy)**2 == 1 && enemy?(position) # => evaluate [1,0] there must not be an enemy at position
    true
  end

  def can_move_to?(pos)
    super(pos) && pawn_move?(pos)
  end

  attr_writer :direction

  def direction
    @orientation == :up ? -1 : 1
  end
end
