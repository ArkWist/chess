# Chess
require "board"
require "pieces"

class Chess
  WHITE = :White
  BLACK = :Black
  EMPTY = :Empty
  NO_POS = :Blank
  COMMANDS = ["save", "load", "quit"]
  PROMOTES = ["r", "n", "b", "q"]
  attr_reader :player, :board

  def initialize
    @player = EMPTY
    @board = Board.new
    #play
  end
  
  def next_player
    @player == WHITE ? @player = BLACK : @player = WHITE
  end
  
  def play
    game_end = false
    @board.display
    until game_end
      next_player
      take_turn
      @board.display
      #game_end = "check" if check?
      ###########
      game_end = true
    end
    #game_set
  end
  
  def take_turn
    print "Player #{@player}'s move: "
    move = gets.chomp
    if @board.valid_move?(move)
      move = @board.normalize_move(move)
      start = @board.get_move_start(move)
      target = @board.get_move_target(move)
      piece = @board.get_piece(start)
      if piece != EMPTY && piece.player == @player
        success = do_move(piece, start, target)
        unless success
          puts "Invalid move. Try again."
          take_turn
        end
      else
        puts "Player #{@player}'s piece not found at #{start}."
        take_turn
      end
    elsif valid_command?(move)
      do_command(move)
    else
      puts "Invalid move. Try again."
      take_turn
    end
  end
  
  def valid_command?(command)
    valid = COMMANDS.include?(command.downcase)
  end
  
  def do_command(command)
    command.downcase!
  end
  
  def do_move(piece, start, target)
    success = move_pawn(piece, start, target) if piece.is_a?(Pawn)
    success = move_rook(piece, start, target) if piece.is_a?(Rook)
    success = move_knight(piece, start, target) if piece.is_a?(Knight)
    success = move_bishop(piece, start, target) if piece.is_a?(Bishop)
    success = move_queen(piece, start, target) if piece.is_a?(Queen)
    success = move_king(piece, start, target) if piece.is_a?(King)
    success
  end
  
  def move_pawn(piece, start, target)
    moves = piece.get_moves(@board)
    captures = piece.get_captures(@board)
    double_step = piece.get_double_step(@board)
    en_passant = piece.get_en_passant_capture(@board)
    success = true
    if en_passant.include?(target)
      @board.move_piece(start, target)
      @board.kill_piece(@board.en_passant)
    elsif captures.include?(target)
      @board.move_piece(start, target)
    elsif double_step.include?(target)
      @board.move_piece(start, target)
      @board.reset_en_passant(target)
    elsif moves.include?(target)
      @board.move_piece(start, target)
    else
      success = false
    end
    if success
      row = target[1].to_i
      if row == 0 || row == @board.height
        @board.promote(target)
      end
    end
    success
  end
  
  def game_set?
  end
  
  def game_set
  end
  
end




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