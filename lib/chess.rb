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
      check = true
      begin
        take_turn
        check = @board.king_in_check?(player)
        if check
          puts "Move would put King in check"
          @board.reverse_move
        end
        puts "Here"
        puts "Check: #{check}"
      end until !check
      @board.display
      #game_end = "check" if check?
      ###########
      game_end = true
      game_end = false
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
  
  def normal_move(piece, start, target)
    moves = piece.get_moves(@board)
    captures = piece.get_captures(@board)
    if captures.include?(target)
      @board.move_piece(start, target)
    elsif moves.include?(target)
      @board.move_piece(start, target)
    else
      success = false
    end
    success
  end
  
  def move_rook(piece, start, target)
    success = normal_move(piece, start, target)
  end
  
  def move_knight(piece, start, target)
    success = normal_move(piece, start, target)
  end
  
  def move_bishop(piece, start, target)
    success = normal_move(piece, start, target)
  end
  
  def move_queen(piece, start, target)
    success = normal_move(piece, start, target)
  end
  
  def move_king(piece, start, target)
    moves = piece.get_moves(@board)
    captures = piece.get_captures(@board)
    castles = piece.get_castles(@board)
    if castles.include?(target)
      @board.do_castle(start, target)
    elsif captures.include?(target)
      @board.move_piece(start, target)
    elsif moves.include?(target)
      @board.move_piece(start, target)
    else
      success = false
    end
    success
  end
  
  def game_set?
    set = false
  end
  
  def game_set
  end
  
end
