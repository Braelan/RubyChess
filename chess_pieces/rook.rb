require_relative 'sliding_piece'

class Rook < SlidingPiece

  def deltas
    ORTHAGONAL_DELTAS
  end
end
