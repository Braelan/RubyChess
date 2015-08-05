require_relative 'stepping_piece'

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

  private

    attr_writer :direction

    def direction
      @orientation == :up ? -1 : 1
    end
end
