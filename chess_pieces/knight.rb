require_relative 'stepping_piece'

class Knight < SteppingPiece

  def deltas
    KNIGHT_DELTAS
  end
end
