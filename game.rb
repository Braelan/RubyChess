require_relative 'board'
require_relative 'players'

class ChessGame


    def initialize(player1, player2, board = nil)
      board ||= ChessBoard.new.set_board
      @board = board
      @players = [player1, player2]
    end

    def play
        until @board.checkmate?(@players.first.color)
        begin
          system("clear")
          @board.render
          begin
          input = @players.first.take_turn
          raise "Not your piece" unless @board[*input[0]].color == @players.first.color
        rescue
          retry
        end
          @board.move(*input)
        rescue RuntimeError => e
          puts e.message          
          sleep(2)
          retry
        end
          @players.rotate!
        end
    end
end



if __FILE__ == $PROGRAM_NAME
  chess = ChessGame.new(Player.new("p1", :blue),Player.new("p2", :red))
  chess.play
end
