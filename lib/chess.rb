# Chess

class Chess
  WHITE = :White
  BLACK = :Black
  attr_reader :player, :board

  def initialize
    @player = WHITE
    @board = Board.new(WHITE, BLACK)
    #play
  end

  def next_player
    @player == WHITE ? @player = BLACK : @player = WHITE
  end

  def play
    @board.display
    until check?
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

  def check?
  end

  def check_mate
  end

  #def 
  #end

end


class Board
  attr_reader :squares

  def initialize(white, black)
    @width, @height = 8, 8
    @squares = Array.new(@width){ Array.new(@height) }
    @last_player = nil
    @last_move = nil
    set_board(white, black)
  end

  def set_board(white, black)
    @squares.each { |col| col[1] = Pawn.new(white) }
    @squares[0][0] = Rook.new(white)
    @squares[1][0] = Knight.new(white)
    @squares[2][0] = Bishop.new(white)
    @squares[3][0] = Queen.new(white)
    @squares[4][0] = King.new(white)
    @squares[5][0] = Bishop.new(white)
    @squares[6][0] = Knight.new(white)
    @squares[7][0] = Rook.new(white)
    @squares.each { |col| col[6] = Pawn.new(black) }
    @squares[1][6] = Knight.new(black)
    @squares[2][6] = Bishop.new(black)
    @squares[3][6] = Queen.new(black)
    @squares[4][6] = King.new(black)
    @squares[5][6] = Bishop.new(black)
    @squares[6][6] = Knight.new(black)
    @squares[7][6] = Rook.new(black)
  end

  def display
  end

end


class Piece
  attr_accessor :moved
  def initialize(owner)
    @owner = owner
    @moved = false
  end
  def valid_move?
  end
  def valid_moves
  end
end

class Pawn < Piece
  def valid_moves
  end
end
class Rook < Piece
end
class Knight < Piece
end
class Bishop < Piece
end
class Queen < Piece
end
class King < Piece
end

# Replay should be outside of Chess class
# So no need for reset?


def replay?
end

def replay
end
