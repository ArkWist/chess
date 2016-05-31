# Board

class Board
  WIDTH = 8
  HEIGHT = 8
  attr_reader :width, :height, :squares

  def initialize
    @squares = Array.new(WIDTH){ Array.new(HEIGHT) }
    @last_player = Chess::EMPTY
    @last_move = 0
    reset_board(Chess::WHITE, Chess::BLACK)
  end
  
  def reset_board(white, black)
    wipe_board
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
    @squares[0][7] = Rook.new(black)
    @squares[1][7] = Knight.new(black)
    @squares[2][7] = Bishop.new(black)
    @squares[3][7] = Queen.new(black)
    @squares[4][7] = King.new(black)
    @squares[5][7] = Bishop.new(black)
    @squares[6][7] = Knight.new(black)
    @squares[7][7] = Rook.new(black)
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
    @raw = true
  end
  
  
end