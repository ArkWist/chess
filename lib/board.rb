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
    set_board(Chess::WHITE, Chess::BLACK)
  end
  
  def set_board(white, black)
    wipe_board
    positions = COLUMNS.map { |col| col + "2" }
    positions.each { |pos| place_piece(pos, Pawn.new(white)) }
    place_piece("a1", Rook.new(white))
    place_piece("b1", Knight.new(white))
    place_piece("c1", Bishop.new(white))
    place_piece("d1", Queen.new(white))
    place_piece("e1", King.new(white))
    place_piece("f1", Bishop.new(white))
    place_piece("g1", Knight.new(white))
    place_piece("h1", Rook.new(white))
    positions = COLUMNS.map { |col| col + "7" }
    positions.each { |pos| place_piece(pos, Pawn.new(black)) }
    place_piece("a8", Rook.new(black))
    place_piece("b8", Knight.new(black))
    place_piece("c8", Bishop.new(black))
    place_piece("d8", Queen.new(black))
    place_piece("e8", King.new(black))
    place_piece("f8", Bishop.new(black))
    place_piece("g8", Knight.new(black))
    place_piece("h8", Rook.new(black))
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
  end
  
  def place_piece(pos, piece)
    pos = Position.new(pos)
    piece.set_pos(pos)
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
  
  def valid_position?(pos)
    valid = pos.length == 2
    valid = COLUMNS.include?(pos[0].to_s) if valid
    valid = false if pos[1].to_i == 0 && row != "0"
    valid = pos[1].to_i.between?(0, HEIGHT) if valid
    valid
  end
  
  # This validates move formatting.
  # It does NOT check if a move is legal.
  def valid_move?(move)
    move = normalize_move(move)
    valid = move.length == 4
    if valid
      start, target = move[0..1], move[2..3]
      valid = false unless valid_position?(start)
      valid = false unless valid_position?(target)
    end
    valid
  end
  
  def normalize_move(move)
    move = move.downcase.gsub(/[, ]+/, "")
  end
  
  def get_move_start(move)
    start = move[0..1]
  end
  
  def get_move_target(move)
    target = move[2..3]
  end

#  def col_list
#    columns = []
#    0.upto(WIDTH) { |i| columns.push(("a".ord + i).chr) }
#    columns
#  end

  def display
    puts ascii_col_labels
    puts ascii_separator
    (WIDTH - 1).downto(0) do |row|
      puts ascii_row(row)
      puts ascii_separator
    end
    puts ascii_col_labels
  end

  def ascii_separator
    line = "   --- --- --- --- --- --- --- ---   "
  end
  
  def ascii_row(row)
    line = "#{row_to_notation(row)} |"
    @squares.each do |col|
      col[row] == Chess::EMPTY ? line << "   |" : line << " #{col[row].icon} |"
    end
    line << " #{row_to_notation(row)}"
  end
  
  def ascii_col_labels
    line = "    " << col_range.join("   ") << "    "
  end
  
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

#class Move
#
#  def initialize(move)
#    @move = move
#  end
#  
#end






