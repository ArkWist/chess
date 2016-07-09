require_relative "chessboard"
require_relative "pieces"
require_relative "positions"


class Chess
  COMMANDS = [:save, :load, :draw, :quit, :resign]
  
  def initialize
    @board = Chessboard.new
    @last_player = :black
    @player = :white
    #start_match
  end
  
  def start_match
    play
  end
  
  private

  def next_player
    player = if @player == :white then :black else :white end
  end
  
  def play
    print_board
    game_result = manage_match
    handle_game_result(game_result)
  end
  
  def manage_match
    game_over = false
    until game_over
      turn_outcome = try_turn
      case turn_outcome when :loaded, :quit, :draw, :checkmate, :stalemate then game_over = turn_outcome end
    end
    game_over
  end
  
  def try_turn
    print "\nPlayer #{@player.to_s.capitalize}'s command: "
    input = gets.chomp
    outcome = if is_raw_command?(input) then try_command(input) # :load, :no_load, :fail_load, :save, :no_save, :fail_save, :draw, :no_draw, :quit
              elsif is_raw_move? (input) then try_move(input) # :empty, :blocked, :occupied, :illegal, :beseiged, :exposed, :check, :checkmate, :stalemate, :fifty_moves, :insufficient, :threefold
              else :unknown_input end
  end
  
  def try_command(input)
    command_outcome = case input.downcase.to_sym
                      when :save then try_save # :save, :no_save
                      when :load then try_load # :load, :no_load
                      when :draw then try_draw # :draw, :no_draw
                      when :quit, :resign then :quit end # :quit
  end
  
  def try_save
    # Check if can save
    save = if receive_permission(next_player) { "saving" } then :save else :no_save end
  end

  def try_load
    # Check if can load
    load = if receive_permission(next_player) { "loading" } then :load else :no_load end
  end
  
  def try_draw
    draw = if receive_permission(next_player) { "a draw" } then :draw else :no_draw end
  end
  
  def try_move(input)
    move_outcome = @board.verify_move(Move.new(input), @player)
    case move_outcome when :empty, :blocked, :occupied, :illegal then report_rejected { "is illegal" } #(:no_piece rather than :empty ->> fix in Chessboard)
                      when :beseiged then report_rejected { "puts your king through check" }
                      when :exposed then report_rejected { "puts you in check" }
                      when :move then move_outcome = complete_move(Move.new(input)) end # Should return :move instead of :verified
    move = case move_outcome when :empty, :blocked, :occupied, :illegal, :beseiged, :exposed then :no_move else move_outcome end
  end
  
  def complete_move(move)
  
  end
  

  
  def receive_permission(player, &block)
    print "\nPlayer #{player}, do you agree to #{yield}? (y/n): "
    input = gets.chomp
    consent = case input.downcase.to_sym
              when :y then true
              when :n then false
              else receive_permission(player, &block) end
  end
  
  def report_rejected
    puts "Rejected! That move #{yield.capitalize}."
  end
    
    
    
    
    
    if outcome == :failed || outcome == :unknown
      report(outcome)
      outcome = :rejected
    end
    outcome
  end

  
    
        handle_turn()
      
      when :moved
        post_move_outcome = handle_post_move
      when :beseiged
        report(:unknown_input)
      when :saved, :unknown_input_type
        report(turn_outcome)
      end
    end
    game_over
  end
  
  def handle_game_result
  end
  
  
=begin
  def play
    print_board
    game_set = false
    until game_set
      outcome = try_turn
      case outcome
      when :do_load, :do_quit, :do_draw
        game_set = outcome
      when :do_save
        do_save
      when :moved
        next_player
        print_board
        game_set = :checkmate if checkmate? unless game_set
        game_set = :stalemate if stalemate? unless game_set
        game_set = claim_draw(:fifty) if fifty_moves?
        game_set = :do_draw if insufficient_material?
        game_set = claim_draw(:threefold) if threefold?
      when :unknown_input_type
        report(:unknown)
      when :rejected
      else
        puts "Error! An unknown error has occured."
        print_board
      end
      if !game_set && fiftymove? && verify_draw(:fiftymove) == :verified then game_set = :do_draw end
      #if !game_set && threefold? && verify_draw(:threefold) == :verified then game_set = :do_draw end
    end
    handle_game_set(game_set)
  end
=end
  


  
  def try_move(input)
    case @board.verify_move(Move.new(input), @player)
    when :verified
      do_move(Move.new(input))
      outcome = :success
    when :empty, :blocked, :occupied, :illegal
      report(:illegal)
    when :besieged
      report(:besieged)
    when :exposed
      report(:exposed)
    else
      report(:unknown)
    end
    outcome = :rejected unless outcome == :success
    outcome
  end
  
  def do_move(move)
    @board.do_move(move)
    do_promotion(move) if @board.promote?(move)
  end
  
  def do_promotion(move)
    print "Promote to what piece?: "
    input = gets.chomp.downcase.to_sym
    case input
    when :rook, :r
      @board.do_promotion(move, :rook)
    when :knight, :n
      @board.do_promotion(move, :knight)
    when :bishop, :b
      @board.do_promotion(move, :bishop)
    when :queen, :q
      @board.do_promotion(move, :queen)
    when :pawn, :p, :king, :k
      report(:illegal_promotion)
      do_promotion(move)
    else
      report(:unknown_promotion)
      do_promotion(move)
    end
  end
  
  def verify_save
    #don't report anything
    #outcome = :verified, :failed
  end
  
  def verify_load
    #don't report anything
    #outcome = :verified, :failed
  end
  
  def verify_draw(type = :none)
    #don't report anything
    #outcome = :verified, :failed
    outcome = :failed
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
  def checkmate?
    checkmate = @board.checkmate?(@player)
  end
  
  def stalemate?
    @board.stalemate?(@player)
  end
  
################
  def claim_draw(reason)
    puts
    puts case reason
    when :fifty
      "Fifty or more moves taken with neither a capture nor a pawn movement."
    when :threefold
      "Threefold repetition."
    end
    consent = verify_draw_ask(@player)
    verify = if consent then :do_draw else nil end
  end
  
  def verify_draw_ask(player)
    print "Player #{@player}, do you accept a draw? (y/n): "
    input = gets.chomp
    if input.downcase == "y"
      consent = true
    elsif input.downcase == "n"
      consent = false
    else
      report(:unknoqn)
      consent = verify_draw_ask(player)
    end
    consent
  end
  
################
  def fifty_moves?
    @board.fifty_move?
  end
  
################
  def threefold?
    return false
  end
  
  def insufficient_material?(player)
    insufficient = @board.insufficient_material?(player)
    puts "Insufficient material to checkmate."
    insufficient
  end
  
  def handle_game_set(exit)
    case exit
    when :loaded
    when :quit
    when :draw
    when :checkmate
      puts "\nCheckmate! Player #{@last_player.to_s.capitalize} is victorious!"
    when :stalemate
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
    when :illegal_promotion
      puts "Rejected! Cannot promote to that piece."
    when :unknown_promotion
      puts "Error! Piece not recognized."
    end
  end

  def is_raw_command?(input)
    input.downcase!
    valid = COMMANDS.include?(input.to_sym)
  end
  
  # Mirrored (as a process) by #normalization in Move.
  def is_raw_move?(input)
    move = input.downcase.gsub(/[, ]+/, "")
    valid = move.length == 4
    if valid
      origin, destination = move[0..1], move[2..3]
      valid = false if !is_raw_position?(origin)
      valid = false if !is_raw_position?(destination)
    end
    valid
  end

  def is_raw_position?(pos)
    file, rank = pos[0], pos[1]
    files = ("a".."z").to_a.take(Chessboard::WIDTH)
    ranks = ("1"..Chessboard::HEIGHT.to_s).to_a
    valid = files.include?(file)
    valid ||= ranks.include?(rank) if valid
    valid
  end

end


# Program start
#chess_game = Chess.new
#chess_game.start_match

