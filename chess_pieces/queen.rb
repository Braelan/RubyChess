require_relative 'sliding_piece'

class Queen < SlidingPiece

  def deltas
   ORTHAGONAL_DELTAS + DIAGONAL_DELTAS
  end
end
