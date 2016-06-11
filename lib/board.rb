# Board

class Board
  WIDTH = 8
  HEIGHT = 8
  COLUMNS = ["a", "b", "c", "d", "e", "f", "g", "h"]
  attr_reader :width, :height, :columns, :squares

  def initialize
    @squares = Array.new(WIDTH){ Array.new(HEIGHT) }
    @last_player = Chess::EMPTY
    @last_move = 0
    reset_board(Chess::WHITE, Chess::BLACK)
  end
  
  def reset_board(white, black)
    wipe_board
#    positions = COLUMNS.map { |col| col + "1" }
#    positions.each { |pos| make_piece(pos, Pawn.new(white)) }
#    make_piece("a2", Rook.new(white))
#    make_piece("b2", Knight.new(white))
#    make_piece("c2", Bishop.new(white))
#    make_piece("d2", Queen.new(white))
#    make_piece("e2", King.new(white))
#    make_piece("f2", Bishop.new(white))
#    make_piece("g2", Knight.new(white))
#    make_piece("h2", Rook.new(white))
#    positions = COLUMNS.map { |col| col + "8" }
#    positions.each { |pos| make_piece(pos, Pawn.new(black)) }
#    make_piece("a7", Rook.new(black))
#    make_piece("b7", Knight.new(black))
#    make_piece("c7", Bishop.new(black))
#    make_piece("d7", Queen.new(black))
#    make_piece("e7", King.new(black))
#    make_piece("f7", Bishop.new(black))
#    make_piece("g7", Knight.new(black))
#    make_piece("h7", Rook.new(black))
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
  end
  
  def make_piece(pos, piece)
    pos = Position.new(pos)
    piece.set_position(pos)
    col, row = pos.to_index
    @squares[col][row] = piece
  end
  
  def get_piece(pos)
    pos = Position.new(pos)
    col, row = pos.to_index
    piece = @squares[col][row]
  end
  
#  def col_list
#    columns = []
#    0.upto(WIDTH) { |i| columns.push(("a".ord + i).chr) }
#    columns
#  end
  
end


class Position

  def initialize(pos)
    @pos = pos
  end
  
  def to_index
    col, row = @pos[0], @pos[1]
    columns = Board::COLUMNS
    col = columns.index(col)
    row = row.to_i - 1
    index = [col, row]
  end
  

end