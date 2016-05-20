# Chess

class Chess
  WHITE = :White
  BLACK = :Black
  EMPTY = :Empty
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
    puts ascii_col_labels
    puts ascii_separator
    7.downto(0) do |row|
      puts ascii_row(row)
      puts ascii_separator
    end
    puts ascii_col_labels
  end

  def ascii_separator
    line = "   --- --- --- --- --- --- --- ---   "
  end
  def ascii_row(row)
    line = "#{row_to_notation(row)} "
    @squares.each do |col|
      col[row] != EMPTY ? line << " #{col[row].icon} |" : line << "   |"
    end
    line << " #{row_to_notation(row)}"
  end
  def ascii_col_labels
    labels = ("a".."h").to_a
    line = "    " + labels.join("   ") + "    "
  end
  
  
  def to_notation(i_col, i_row)
    n_col = col_to_notation(i_col).to_s
    n_row = row_to_notation(i_row).to_s
    notation = "#{n_col}#{n_row}"
  end
  def to_index(n_col, n_row)
    i_col = col_to_index(n_col).to_i
    i_row = row_to_index(n_row).to_i
    index = [i_col, i_row]
  end
  
  def col_to_notation(index)
    alphabet = ("a".."h").to_a
    alphabet[index]
  end
  def col_to_index(notation)
    alphabet = ("a".."h").to_a
    alphabet.index(notation)
  end
  def row_to_notation(index)
    index += 1
  end
  def row_to_index(notation)
    notation -= 1
  end


end


class Piece
  attr_accessor :moved
  def initialize(owner)
    @owner = owner
    @moved = false
  end
  def icon
    @owner == :White ? @@icon.first : @@icon.last
  end
  def valid_move?()
  end
  def valid_moves
  end
end

class Pawn < Piece
  @@icon = ["♙", "♟"]
  def valid_moves
  end
  def icon
    
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
