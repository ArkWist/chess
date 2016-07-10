# lib/chess.rb

require_relative "chessboard"
require_relative "pieces"
require_relative "positions"


module SaveDataReader

  def read_variable(line)
    line.split("=").at(0)
  end
  
  def read_value(line)
    line.split("=").at(1)
  end
  
  def read_sub_variable
    line.split(":").at(0)
  end
  
  def read_sub_value
    line.split(":").at(1)
  end

end


class Chess
  include SaveDataReader
  COMMANDS = [:save, :load, :draw, :quit, :resign]
  
  def initialize
    @board = Chessboard.new
    @player = :white
    #start_match
  end
  
  def start_match
    play
  end
  
  ########
  #private
  ########

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
  
  # This return a number of symbols representing the outcome of attempting the turn.
  # Outcomes -- commands -- :load, :no_load
  #                         :save, :no_save
  #                         :draw, :no_draw, :quit
  #             moves ----- :move, :no_move
  #                         :check, :checkmate, :stalemate
  #                         :draw
  # Note: Other move outcomes are handled by #try_move and converted to the above. 
  def try_turn
    print "\nPlayer #{@player.to_s.capitalize}'s command: "
    input = gets.chomp
    outcome = if is_raw_command?(input) then try_command(input)
              elsif is_raw_move?(input) then try_move(input)
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
    slot = ask_file_slot { "save" }
    save = if slot_exists?(slot) then ask_permission(@player) { "overwrite slot #{slot}" } end
    save = if save then ask_permission(next_player) { "saving slot #{slot}" } else save end
    if save then complete_save(slot) end
    save = if save then :save else :no_save end
  end

  def try_load
    slot = ask_file_slot { "load" }
    load = if slot_exists?(slot) then ask_permission(next_player) { "loading slot #{slot}" } else report_rejected_slot { "#{slot}" } end
    load = if load then prepare_load(slot) end
    load = if load then :load else :no_load end
  end
  
  def try_draw(player = next_player)
    draw = if ask_permission(player) { "a draw" } then :draw else :no_draw end
  end
  
  def try_move(input)
    move_outcome = @board.verify_move(@player, Move.new(input))
    case move_outcome when :empty, :blocked, :occupied, :illegal then report_rejected_move { "is illegal" }
                      when :besieged then report_rejected_move { "puts your king through check" }
                      when :exposed then report_rejected_move { "puts you in check" }
                      when :move then move_outcome = complete_move(Move.new(input)) end # Should return :move instead of :verified
    move = case move_outcome when :empty, :blocked, :occupied, :illegal, :besieged, :exposed then :no_move else move_outcome end
  end
  
  def complete_move(move)
    @board.do_move(move)
    handle_promote(move)
    @player = next_turn
    move_outcome = if checkmate? then :checkmate
                   elsif stalemate? then :stalemate
                   elsif fifty_moves? then try_fifty_move_draw
                   elsif insufficient_material? then try_insufficient_material_draw
                   elsif threefold_repetition? then try_threefold_draw
                   else :move end
    move_outcome = case move_outcome when :no_draw then :move else move_outcome end
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
  
  def threefold_repetition?
    threefold = @board.threefold_repetition?
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
  
  def report_rejected_slot
    puts "Rejected! No such slot #{yield}."
  end
  
  def handle_game_result(game_result)
    case game_result when :load then complete_load
                      when :quit then puts "\nPlayer #{@player} has surrendered."
                      when :draw then puts "\nGame is a draw."
                      when :checkmate, :stalemate then puts "\nPlayer #{next_player} is victorious." end
  end
  
  def ask_file_slot(&block)
    print "\nChoose a slot to #{yield}. (0-9): "
    input = gets.chomp
    slot = Integer(input) rescue false
    slot = if slot && slot.between?(0, 9) then slot else ask_file_slot(&block) end
  end
  
  def get_filename(slot)
    filename = "chess_save_slot_#{slot}.sav"
  end
  
  def slot_exists?(slot)
    File.exist?(get_filename(slot))
  end
  
  def complete_save(slot)
    File.open(get_filename(slot), "w") { |file| file.put "player=#{@player};\n" + @board.make_save_data }
    puts "Saved to #{get_filename(slot)}."
  end
  
  def prepare_load(slot)
    @board.reset_for_load
    File.readlines(get_filename(slot)) do |line|
      case SaveDataReader.read_variable(line)
      when "player" then @player = SaveDataReader.read_value(line)
      when "ep_destination", "ep_capture", "new_ep", "fifty", "piece", "unmoved" then @board.load_line(line) end
    end
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

# End
