require_relative 'sliding_piece'

class Bishop < SlidingPiece

  def deltas
    DIAGONAL_DELTAS
  end
end
