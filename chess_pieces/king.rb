require_relative 'stepping_piece'

class King < SteppingPiece

  def deltas
    ORTHAGONAL_DELTAS + DIAGONAL_DELTAS
  end
end
