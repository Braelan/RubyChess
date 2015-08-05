require_relative 'piece'
require 'byebug'
class SlidingPiece < Piece

  def look(delta_new, delta1 = nil)
    new_pos = transform(delta_new)
    delta1 ||= delta_new
    return [] if stop_at?(delta_new, delta1)
    next_delta = [delta1[0] + delta_new[0], delta1[1] + delta_new[1]]
    next_space = look(next_delta,delta1)
    output = next_space
    output << delta_new
    # => Array of moves in delta's direction
  end

  def stop_at?(delta, delta1)
    new_pos = transform(delta)
    old_pos = [new_pos[0] - delta1[0], new_pos[1] - delta1[1]]
    return true unless board.on_board?(new_pos)
    return true if enemy?(old_pos)
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
