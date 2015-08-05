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

  def put_in_check?(move)
    board.move!(self.pos, move)
    check = board.in_check?(self.color)
    board.undo
    check
  end

  def valid_moves?
    self.moves.any? { |move| !self.put_in_check?(move)}
  end
end
