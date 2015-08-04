class Piece
  attr_accessor :pos
  attr_reader :board

  ORTHAGONAL_DELTAS = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  DIAGONAL_DELTAS = [[1,1], [1,-1], [-1,-1], [-1, 1]]

  def initialize(position, board)
    @pos, @board= position, board
  end

  #
  # def move(piece.deltas)
  #   sigma_deltas()
  # end


  def moves

    #
    all_moves = sigma_deltas().map {|delta| [delta[0] + pos[0], delta[1] + pos[1]]}
    # all_moves.select { |move| board.on_board?(move)}
  end

  def sigma_deltas
     [[0,0]]
  end
end

class SlidingPiece < Piece


  def look(delta)
    delta
    # => Array of moves in delta's direction
  end

  def method_name

  end

  def sigma_deltas()
    total_moves = []
    (self.deltas).each do |delta|
        total_moves << look(delta)

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
