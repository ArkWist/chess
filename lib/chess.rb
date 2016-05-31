

=begin
# Chess

require "pieces"


class Chess
  WHITE = :White
  BLACK = :Black
  EMPTY = :Empty
  attr_reader :player, :board

  def initialize
    @player = WHITE
    @board = Board.new
    @board.set_board(WHITE, BLACK)
    #play
  end

  def next_player
    @player == WHITE ? @player = BLACK : @player = WHITE
  end

  def play
    @board.display
    until check?
      next_player unless @board.raw?
      take_turn
      @board.display
    end
    game_set
  end

  def take_turn
    print "Player #{@player}'s move: "
    move = standardize_move(gets.chomp)
    if valid_move?(move)
      @board.make_move(@player, move)
    else
      puts "Invalid move. Try again."
      take_turn
    end
  end

  def standardize_move(move)
    move.downcase!.gsub!(/[, ]+/, "")
  end
  
  def break_move(move)
    current = move[0..1]
    target = move[2..-1]
    move = [position, target]
  end
  
  def valid_move?(move)
    current, target = break_move(move)
    
    @board.real_position?(current)
    @board.real_position?(target)
    
    @board.player_position?(@player, current)
    
    @board.valid_move?(current, target)

  end

  def make_move
  end
  def game_set?
  end
  def check?
  end
  def draw?
  end
  def stalemate?
  end
  def game_set
  end
end


class Board
  WIDTH = 8
  HEIGHT = 8
  attr_reader :width, :height, :squares, :raw

  def initialize
    @squares = Array.new(WIDTH){ Array.new(HEIGHT) }
    @last_player = nil
    @last_move = nil
    @raw = true
  end

  def set_board(white, black)
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

  
  def col_range
    range = ["a"]
    (WIDTH - 1).times { range << range[-1].next }
    range
  end
  
  
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
  
  
  def real_position?(position)
    position
  end
  
#  @board.real_position?(current)
#  @board.real_position?(target)
#  @board.player_position?(@player, current)
#  @board.valid_move?(current, target)
  
  
  
  def extant_position?(position)
    exists = true
    exists = false if !col_exists(position[0])
    exists = false if !is_integer?(position[1]) || !row_exists?(position[1])
    exists
  end
  def col_exists?(col)
    col_range.include?(char.to_s)
  end
  def is_integer?(char)
    char.to_i == 0 && char != "0" ? false : true
  end
  def row_exists?(row)
    row.between?(0, WIDTH)
  end


end

# Really ought to check if Position is index or Notation too
# Create a Position for each square and use the method there?
# Position.col_to_index(col, row)?
# Yeah, could call Position::row_to_index(row)
# And method could be def row_to_index(row = @row)
# Or maybe there's a module!
# Module is used for position calculations
# That makes much more sense.


# Replay should be outside of Chess class
# So no need for reset?


def replay?
end

def replay
end
=end