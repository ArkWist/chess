# Chess

class Chess
  WHITE = :White
  BLACK = :Black
  attr_reader :player, :board

  def initialize
    @player = WHITE
    @board = Board.new
    #play
  end

  def next_player
    @player == WHITE ? @player = BLACK : @player = WHITE
  end

  def play
    @board.display
    until check_mate?
      next_player unless @board.empty?
      move
      @board.display
    end
    check_mate
  end

  def move
  end

  def valid_move?()
  end

  def make_move
  end

  def check_mate?
  end

  def check_mate
  end

  #def 
  #end

end


class Board

  def initialize
    @width, @height = 8, 8
    @squares = Array.new(WIDTH){ Array.new(HEIGHT) }
    @last_player = nil
    @last_move = nil
    set_board
  end

  def set_board
  end

  def display
  end

end


class Piece
end

class Pawn
end
class Rook
end
class Knight
end
class Bishop
end
class Queen
end
class King
end

# Replay should be outside of Chess class
# So no need for reset?


def replay?
end

def replay
end
