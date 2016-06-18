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
    place_piece("d1", King.new(white))
    place_piece("e1", Queen.new(white))
    place_piece("f1", Bishop.new(white))
    place_piece("g1", Knight.new(white))
    place_piece("h1", Rook.new(white))
    positions = COLUMNS.map { |col| col + "7" }
    positions.each { |pos| place_piece(pos, Pawn.new(black)) }
    place_piece("a8", Rook.new(black))
    place_piece("b8", Knight.new(black))
    place_piece("c8", Bishop.new(black))
    place_piece("d8", King.new(black))
    place_piece("e8", Queen.new(black))
    place_piece("f8", Bishop.new(black))
    place_piece("g8", Knight.new(black))
    place_piece("h8", Rook.new(black))
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
  end
  
  def place_piece(pos, piece)
    pos = Position.new(pos) unless pos.is_a?(Position)
    piece.set_pos(pos)
    col, row = pos.to_index
    @squares[col][row] = piece
  end
  
  def get_piece(pos)
    pos = Position.new(pos) unless pos.is_a?(Position)
    col, row = pos.to_index
    piece = @squares[col][row]
  end
  
  #########################
  ## JUST INTRODUCED, USE WHERE APPROPRIATE
  def is_empty?(pos)
    pos = Position.new(pos) unless pos.is_a?(Position)
    col, row = pos.to_index
    @squares[col][row] == Chess::EMPTY
  end
  
  def remove_piece(pos)
    pos = Position.new(pos) unless pos.is_a?(Position)
    col, row = pos.to_index
    @squares[col][row] = Chess::EMPTY
  end
  
  # Aliases remove_piece.
  # Referenced in case remove and capture need be distinguished.
  def kill_piece(pos)
    remove_piece(pos)
  end
  
  def move_piece(start, target)
    kill_piece(target) if get_piece(target) != Chess::EMPTY
    place_piece(target, get_piece(start))
    remove_piece(start)
  end
  
  def valid_position?(pos)
    pos = pos.to_notation if pos.is_a?(Position)
    valid = pos.length == 2
    valid = COLUMNS.include?(pos[0].to_s) if valid
    valid = false if pos[1].to_i == 0 && row != "0"
    valid = pos[1].to_i.between?(0, HEIGHT) if valid
    valid
  end
  
  def valid_indices?(pos)
    pos = pos.to_notation if pos.is_a?(Position)
    valid = pos.length == 2
    valid = false unless pos[0].to_i.between?(0, WIDTH)
    valid = false unless pos[1].to_i.between?(0, HEIGHT)
    valid
  end

  ###############################
  def empty_up_to?(start, direction, max)
    count = 0
    col, row = start.to_index
    
    if direction == :n
      max.times do |i|
        #move = Position.new([col, row + 1])
      end
    end
    
  end

  def empty_up_to(pos, direction, max = -1)
    count = 0
    col, row = pos.to_index
    
    until !valid_position?(pos)
      if direction == :n
        row += 1
        move = Position.new([col, row])
        valid_position?(move.to_notation) && is_empty?(move)
        count += 1 if is_empty(col, row)
    
      max.times do |i|
        #move = Position.new([col, row + 1])
      end
    end
    
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
    (HEIGHT).downto(1) do |row_no|
      puts ascii_row(line)
      puts ascii_separator
    end
    puts ascii_col_labels
  end

  def ascii_separator
    line = "   "
    WIDTH.times { line << "--- " }
    line << "  "
  end
  
  def ascii_row(row_no)
    row = row_no - 1
    line = "#{row_no} |"
    @squares.each do |col|
      col[row] == Chess::EMPTY ? line << "   |" : line << " #{col[row].icon} |"
    end
    line << " #{row_no}"
  end
  
  def ascii_col_labels
    line = "    "
    COLUMNS.each { |col| line << "#{col}   " }
    line << " "
  end
  
end


class Position
  attr_reader :pos

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
    col = Board::COLUMNS[@pos[0]]
    row = @pos[1] + 1
    notation = "#{col}#{row}"
  end
  
end

#class Move
#
#  def initialize(move)
#    @move = move
#  end
#  
#end






