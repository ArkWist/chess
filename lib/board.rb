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
#    positions.each { |pos| place_piece(pos, Pawn.new(white)) }
#    place_piece("a2", Rook.new(white))
#    place_piece("b2", Knight.new(white))
#    place_piece("c2", Bishop.new(white))
#    place_piece("d2", Queen.new(white))
#    place_piece("e2", King.new(white))
#    place_piece("f2", Bishop.new(white))
#    place_piece("g2", Knight.new(white))
#    place_piece("h2", Rook.new(white))
#    positions = COLUMNS.map { |col| col + "8" }
#    positions.each { |pos| place_piece(pos, Pawn.new(black)) }
#    place_piece("a7", Rook.new(black))
#    place_piece("b7", Knight.new(black))
#    place_piece("c7", Bishop.new(black))
#    place_piece("d7", Queen.new(black))
#    place_piece("e7", King.new(black))
#    place_piece("f7", Bishop.new(black))
#    place_piece("g7", Knight.new(black))
#    place_piece("h7", Rook.new(black))
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
  end
  
  def place_piece(pos, piece)
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
  
  def remove_piece(pos)
    pos = Position.new(pos)
    col, row = pos.to_index
    @squares[col][row] = Chess::EMPTY
  end
  
  # Currently aliases remove_piece.
  # References in case there's a need to distinguish remove and capture.
  def kill_piece(pos)
    remove_piece(pos)
  end
  
  def move_piece(start, target)
    kill_piece(target) if get_piece(target) != Chess::EMPTY
    place_piece(target, get_piece(start))
    remove_piece(start)
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
  
  def to_notation
    @pos
  end
  

end