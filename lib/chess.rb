=begin


8  [r][n][b][k][q][b][n][r]
7  [p][p][p][p][p][p][p][p]
6  [ ][ ][ ][ ][ ][ ][ ][ ]
5  [ ][ ][ ][ ][ ][ ][ ][ ]
4  [ ][ ][ ][ ][ ][ ][ ][ ]
3  [ ][ ][ ][ ][ ][ ][ ][ ]
2  [P][P][P][P][P][P][P][P]
1  [R][N][B][K][Q][B][N][R]

    A  B  C  D  E  F  G  H

@en_passant
@moved[] << pos if rook or king
or have unmoved, and delete when start and target from it, probably better

=end


class Chess
  PLAYERS = [:white, :black]
  COMMANDS = [:save, :load, :quit, :draw]
  
  def initialize
    @board = Chessboard.new
    @player = :none
  end

  origin, destination = "g4", "g5"
  
  #move_outcome = try_move(origin, destination)
  
  def try_move(origin, desintation)
    #Empty position
    
    # Wrong player
    @board.get_piece(origin).player == @player
  end
  
  def next_player
    i = PLAYERS.find_index(@player)
    player = PLAYERS[0] if i.nil?
    player ||= PLAYERS[0] if i == PLAYERS.length - 1
    player ||= PLAYERS[i + 1]
    #player
  end
  
  def do_turn
    print "Player #{@player.to_s.capitalize}'s command: "
    outcome = verify_input(gets.chomp)
    outcome = try_move if outcome == :move
    outcome = try_command if outcome == :command
    
    
    
    case verify_input(input)
    when :move
      case try_move(Move.new(input))
      when
      end
    when :command
      case try_command(input)
      when
      end
    else
      puts "Unsupported command. Try again."
    end
  end
  
  def verify_input(input)
    outcome = :command if is_raw_command?(input)
    outcome ||= :move if is_raw_move?(input)
    outcome ||= :unknown
  end
  
  def is_raw_command?(input)
    input.downcase!
    valid = COMMANDS.include?(input.to_sym)
  end
  
  def is_raw_move?(input)
    input.downcase.delete!(/ ,/)
    input.length == 4 ? valid = true : valid = false
    if valid
      origin, destination = move[0..1], move[2..3]
      valid = false if !is_position?(origin)
      valid = false if !is_position?(destination)
    end
    valid
  end

  def is_raw_position?(pos)
    file, rank = pos[0], pos[1]
    files = ("a".."z").to_a.take(@board.WIDTH)
    ranks = ("1"..@board.HEIGHT.to_s).to_a
    valid = files.include?(file)
    valid ||= ranks.include?(rank) if valid
  end
  
  def try_move(input)
    move = Move.new(input)

  end
  #def take_turn
  #  print "Player #{@player}'s move: "
  #  move = gets.chomp
  #  if @board.valid_move?(move)
  #    move = @board.normalize_move(move)
  #    start = @board.get_move_start(move)
  #    target = @board.get_move_target(move)
  #    piece = @board.get_piece(start)
  #    if piece != EMPTY && piece.player == @player
  #      success = do_move(piece, start, target)
  #      unless success
  #        puts "Unable to move. Try again."
  #        take_turn
  #      end
  #    else
  #      puts "Player #{@player}'s piece not found at #{start}."
  #      take_turn
  #    end
  #  elsif valid_command?(move)
  #    do_command(move)
  #  else
  #    puts "Invalid move. Try again."
  #    take_turn
  #  end
  #end


  def test_move(move)
    player = @board.get_piece(move.origin).player
    board = @board.make_projection_model(move)
    @board.in_check?(player, board) ? outcome = :check : outcome = :moved
    outcome
  end
  

  
end










