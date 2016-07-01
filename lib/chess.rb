

class Chess
  PLAYERS = [:white, :black]
  COMMANDS = [:save, :load, :quit, :draw]
  
  def initialize
    @board = Chessboard.new
    @player = :white
    #start_match
  end
  
  private
  
  def start_match
    play
  end
  
  def play
    puts
    print_board
    until game_set
      case try_turn
      when :do_load
        game_set = :loaded
      when :do_quit
        game_set = :quit
      when :do_draw
        game_set = :draw
      when :do_save
        do_save
      when :moved
        @player = next_player
        print_board
        game_set = :checkmate if checkmated?
      when :unknown
        report(:unknown)
      end
    end
    handle_game_set(game_set)
  end
  
  def next_player
    i = PLAYERS.find_index(@player)
    @player = PLAYERS[0] if i.nil?
    @player ||= PLAYERS[0] if i == PLAYERS.length - 1
    @player ||= PLAYERS[i + 1]
  end
  
  def try_turn
    puts
    print "Player #{@player.to_s.capitalize}'s command: "
    input = gets.chomp
    outcome = classify_input(input)
    outcome = handle_command(input) if outcome == :command
    outcome = handle_move(input) if outcome == :move
    outcome
  end

  def classify_input(input)
    outcome = :command if is_raw_command?(input)
    outcome ||= :move if is_raw_move?(input)
    outcome ||= :unknown
  end
  
  def handle_command(input)
    outcome = try_command(input)
    outcome
  end
  
  def handle_move(input)
    outcome = try_move(input)
    outcome = :moved if outcome == :success
    outcome
  end
  
  def try_command(input)
    case input.downcase.to_sym
    when :save
      outcome = verify_save
      outcome = :do_save if outcome == :verified
    when :load
      outcome = verify_load
      outcome = :do_load if outcome == :verified
    when :quit
      outcome = :do_quit
    when :draw
      outcome = verify_draw
      outcome = :do_draw if outcome == :verified
    end
    if outcome == :failed || outcome == :unknown
      report(outcome)
      outcome = :rejected
    end
    outcome
  end
  
  def try_move(input)
    case @board.verify_move(Move.new(input))
    when :verified
      do_move(Move.new(input))
      outcome = :success
    when :blocked, :occupied, :illegal
      report(:illegal)
    when :besieged
      report(:besieged)
    when :exposed
      report(:exposed)
    else
      report(:unknown)
    end
    outcome = :rejected unless :outcome == :success
    outcome
  end
  
  def do_move(move)
    @board.do_move(move)
  end
  
  def verify_save
    #don't report anything
    #outcome = :verified, failed
  end
  
  def verify_load
    #don't report anything
    #outcome = :verified, failed
  end
  
  def verify_draw
    #don't report anything
    #outcome = :verified, :failed
  end
  
  def do_save
    report(:saved)
    #no return value
  end
  
  def do_load
    report(:loaded)
    #no return value
  end
  
  # Unable to check if a castle could escape check... because illegal anyways
  def checkmated?
    @board.checkmate?(@player)
  end

  def handle_game_set(exit)
    case exit
    when :loaded
    when :quit
    when :draw
    when :checkmate
    end
  end

  def print_board
    puts
    @board.print_board
  end  
  
  def report(type)
    case type
    when :illegal
      puts "Rejected! Move is illegal."
    when :beseiged
      puts "Rejected! King cannot move through squares in check."
    when :exposed
      puts "Rejected! Move puts you in check."
    when :unknown
      puts "Error! Command not recognized."
    when :success
      puts "Success!"
    when :failed
      puts "Error! Command failed."
    end
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

end










