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
      case turn_outcome when :load, :quit, :draw, :checkmate, :stalemate then game_over = turn_outcome end
    end
    game_over
  end
  
  def try_turn
    print "\nPlayer #{@player.to_s.capitalize}'s command: "
    input = gets.chomp
    outcome = if is_raw_command?(input) then try_command(input) # :load, :no_load, :fail_load, :save, :no_save, :fail_save, :draw, :no_draw, :quit
              elsif is_raw_move?(input) then try_move(input) # :empty, :blocked, :occupied, :illegal, :besieged, :exposed, :check, :checkmate, :stalemate, :draw, :no_draw
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
    save = if ask_permission(next_player) { "saving" } then :save else :no_save end
  end

  def try_load
    # Check if can load
    load = if ask_permission(next_player) { "loading" } then :load else :no_load end
  end
  
  def try_draw(player = next_player)
    draw = if ask_permission(player) { "a draw" } then :draw else :no_draw end
  end
  
  def try_move(input)
    move_outcome = @board.verify_move(Move.new(input), @player)
    case move_outcome when :empty, :blocked, :occupied, :illegal then report_rejected_move { "is illegal" } #(:no_piece rather than :empty ->> fix in Chessboard)
                      when :beseiged then report_rejected_move { "puts your king through check" }
                      when :exposed then report_rejected_move { "puts you in check" }
                      when :move then move_outcome = complete_move(Move.new(input)) end # Should return :move instead of :verified
    move = case move_outcome when :empty, :blocked, :occupied, :illegal, :beseiged, :exposed then :no_move else move_outcome end
  end
  
  def complete_move(move)
    @board.do_move(move)
    handle_promote(move)
    @player = next_turn
    move_outcome = if checkmate? then :checkmate
                   elsif stalemate? then :stalemate
                   elsif fifty_moves? then try_fifty_move_draw
                   elsif insufficient_material? then try_insufficient_material_draw
                   elsif threefold? then try_threefold_draw
                   else :move end
  end
  
  def handle_promote(move)
    ask_promote if @board.promote?(move)
  end
  
  def ask_promote
    print "\nPlayer #{@player}, promote your Pawn to what piece? (q/b/r/n): "
    input = gets.chomp
    case inputs.downcase.to_sym when :queen, :q then @board.do_promotion(move, :queen)
                                 when :bishop, :b, then @board.do_promotion(move, :bishop)
                                 when :rook, :r then @board.do_promotion(move, :rook)
                                 when :knight, :n then @board.do_promotion(move, :knight)
                                 else ask_promote end
  end
  
  def checkmate?
    checkmate = @board.checkmate?(@player)
  end
  
  def stalemate?
    stalemate = @board.stalemate?(@player)
  end
  
  def fifty_moves?
    fifty_moves = @board.fifty_moves?
  end
  
  def insufficient_material?
    insufficient = @board.insufficient_material?
  end
  
  def threefold?
    threefold = @board.threefold?
  end
  
  def try_fifty_move_draw
    puts "\nFifty or more moves have passed without captures or pawn moves."
    draw = try_draw(@player)
  end
  def try_insufficient_material_draw
    puts "\nNeither player has sufficient material to checkmate their opponent."
    draw = try_draw(@player)
  end
  def try_threefold_draw
    puts "\nThe same position has occurred three times."
    draw = try_draw(@player)
  end
  
  def ask_permission(player, &block)
    print "\nPlayer #{player}, do you agree to #{yield}? (y/n): "
    input = gets.chomp
    consent = case input.downcase.to_sym
              when :y then true
              when :n then false
              else ask_permission(player, &block) end
  end
  
  def report_rejected_move
    puts "Rejected! That move #{yield}."
  end
  
  def handle_game_result(game_result)
    case game_result when :load then complete_load
                      when :quit then puts "\nPlayer #{@player} has surrendered."
                      when :draw then puts "\nGame is a draw."
                      when :checkmate, :stalemate then puts "\nPlayer #{next_player} is victorious." end
  end
  
  def complete_load
    puts "/nLoading saved game..."
    manage_match
  end
  
  def print_board
    puts
    @board.print_board
  end  

  def is_raw_command?(input)
    valid = COMMANDS.include?(input.downcase.to_sym)
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
    valid = files.include?(file) && ranks.include?(rank)
  end

end


# Program start
#chess_game = Chess.new
#chess_game.start_match



##################

  def try_save
    # Check if can save
    save = if ask_permission(next_player) { "saving" } then :save else :no_save end
  end

  def try_load
    # Check if can load
    load = if ask_permission(next_player) { "loading" } then :load else :no_load end
  end
  
#################





def save(right, wrong, mercy, answer)
  filename = get_filename
  File.open(filename, "w") do |file|
    file.puts "right=#{right}"
    file.puts "wrong=#{wrong}"
    file.puts "mercy=#{mercy}"
    file.puts "answer=#{answer}"
  end
  puts "#{filename} saved."
end

def get_filename
  print "Input filename: "
  filename = gets.chomp.downcase + ".sav"
end

def save_var(line)
  line.split("=").at(
end

def sav_value(line)
  line.split("=").at(1)
end


####################

print "Load save game? (y/n): "
if gets.chomp.downcase == "y"
  filename = get_filename
  if File.exist?(filename)
    File.readlines(filename) do |line|
      case save_var(line)
      when right
        right = save_value(line)
      when wrong
        wrong = save_value(line)
      when mercy
        mercy = save_value(line)
      when answer
        answer = save_value(line)
      end
    end
    puts "#{filename} loaded."
  else
  puts "#{filename} does not exist."
end

#######################

