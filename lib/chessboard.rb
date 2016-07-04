#require_relative "pieces"
#require_relative "positions"


class Chessboard
  #attr_reader :height, :width
  
  HEIGHT, WIDTH = 8, 8
  # This is structured oddly because Ruby didn't want a 2D array.
  CHARACTERS = [[:pawn, :rook, :knight, :bishop, :queen, :king], \
               [ "P",   "R",   "N",     "B",     "Q",    "K"],   \
               [ "p",   "r",   "n",     "b",     "q",    "k"]]
               
  def initialize
    @pieces = (make_white_pieces << make_black_pieces).flatten
    make_tracking_variables
  end
  
  def print_board
    board = make_model
    (HEIGHT).downto(1) { |rank| print_rank(board, rank) }
    puts
    print_files
  end
  
  # This only verifies moves for the current board.
  # This means it can't verify (future) moves with (projection) models.
  # If #get_piece were rewritten to interpret pieces from models,
  #  this method could fully verify current or future moves.
  # Note: All other helper methods are already compatible with models.
  # Note: Only works with moves with legal positions.
  def verify_move(move, player, board = make_model)#(move))
    origin, destination = move.positions
    piece = get_piece(origin)
    outcome = verify_piece(piece, player)
    outcome = verify_move_legality(move, board) if outcome == :verified
    if outcome == :illegal
      outcome = verify_en_passant(move, board) if piece.type == :pawn
      outcome = verify_castle(move, board) if piece.type == :king
    end
    if outcome == :verified
      outcome = :exposed if in_check?(player, make_projection_model(move))
    end
    outcome
  end

  
  def do_move(move)
    origin, destination = move.positions
    origin_index, capture_index = get_piece_index(origin), get_piece_index(destination)
    piece = get_piece(origin)
    if piece.type == :pawn
      clean_up_en_passant(move) if verify_en_passant(move) == :verified
      record_double_step(move) if @unmoved_piece_positions.include?(origin.notation)
    elsif piece.type == :king
      clean_up_castle(move) if verify_castle(mode) == :verified
    end
    @pieces[origin_index].move_to(destination)
    kill_piece(destination) if capture_index != :none
    clean_up_tracking_variables(move)
  end
  
  
  def clean_up_en_passant(move)
    kill_piece(@en_passant_capture)
    @en_passant_destination, @en_passant_capture = Position.new, Position.new
  end
  
  def record_double_step(move)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    if d_rank - o_rank == 2
      piece = get_piece(origin)
      @en_passant_destination = Position.new([d_file, d_rank])
      @en_passant_capture = Position.new([d_file, d_rank - 1]) if piece.player == :white
      @en_passant_capture = Position.new([d_file, d_rank + 1]) if piece.player == :black
    end
  end
  
  def clean_up_castle(move)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    d_file < o_file ? direction = :left : direction = :right
    if direction == :left
      rook_index = get_piece_index(Position.new([0, o_rank]))
      rook_pos = Position.new([d_file + 1, d_rank])
    elsif direction == :right
      rook_index = get_piece_index(Position.new([WIDTH - 1, o_rank]))
      rook_pos = Position.new([d_file - 1, d_rank])
    end
    @pieces[rook_index].move_to(rook_pos)
    @unmoved_piece_positions.delete_at(rook_pos)
  end
  
  def do_promotion(move, type)
    origin, destination = move.positions
    player = get_piece(destination).player
    case type
    when :rook
      piece = Rook.new(player, destination)
    when :knight
      piece = Knight.new(player, destination)
    when :bishop
      piece = Bishop.new(player, destination)
    when :queen
      piece = Queen.new(player, destination)
    end
    remove_piece(destination)
    @pieces << piece
  end
  
  def clean_up_tracking_variables(move)
    origin, destination = move.positions
    @unmoved_piece_positions.delete(origin.notation)
    @unmoved_piece_positions.delete(destination.notation)
  end
  
  def promote?(move)
    origin, destination = move.positions
    file, rank = destination.index
    promote = get_piece(origin).type == :pawn && (rank == 0 || rank == HEIGHT - 1)
  end
  
  def checkmate?(player)
    board = make_model
    checkmate = true
    return checkmate if in_check?(player, board)
    board.each_with_index do |file, i|
      file.each_with_index do |square, j|
        if checkmate && square.player == player
          piece = make_dummy_piece(player, Position.new([i, j]), square.type)
          moves = piece.get_moves(board).map { |c| c = c.notation }
          moves.each do |pos|
            model = make_project_model(Move.new([i, j, pos.index].flatten))
            checkmate = false if !in_check?(player, board)
          end
        end
      end
    end
    checkmate
  end
  
  
  private
  
  # TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! UNORGANIZED
  ##########################################################
  # All private methods ought be reorganized for legibility.
  ##########################################################
  
  def verify_move_legality(move, board = make_model)
    origin, destination = move.positions
    outcome = :blocked if get_piece(destination).player == @player
    outcome ||= :illegal if !get_piece(origin).get_moves(board)
    outcome ||= :verified
  end
  
  def verify_piece(piece, player)
    outcome = :empty if piece.type == :none
    outcome ||= :occupied if piece.player != player
    outcome ||= :verified
  end
  
  def verify_en_passant(move, board = make_model)
    origin, destination = move.positions
    outcome = :verified if destination.notation == @en_passant_destination && \
                           get_piece(origin).can_en_passant?(board, @en_passant_destination)
    outcome ||= :illegal
  end
  
  ##################################################
  # This method ought be broken into helper methods.
  # Note: King has no #can_castle? method to refer to.
  #       This is because only Pieces can't do #in_check? tests.
  # Note: If refactoring, consider moving #in_check? to Piece.
  #       Doing so would make move verification testing easier.
  def verify_castle(move, board = make_model)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    king = board[o_file, o_rank]
    # Check if the moving piece is a King.
    continue = king.type == :king
    if continue
      d_file, d_rank = destination.index
      # Check if the destination is +/- 2 from the King.
      continue = o_rank == d_rank && (o_file == d_file - 2 || o_file == d_file + 2)
      if continue
        d_file < o_file ? direction = :left : direction = :right
        r_file, r_rank = direction == :left ? [0, o_rank] : [WIDTH - 1, o_rank]
        rook = board[r_file, r_rank]
        player = king.player
         # Check the Rook to move exists and is owned by the player.
        continue = rook.type == :rook && rook.player == player
        if continue
          king_pos = origin
          rook_pos = Position.new([r_file, r_rank])
          # Check the King and Rook haven't ever moved.
          continue = @unmoved_piece_positions.include?(king_pos.notation) && @unmoved_piece_positions.include?(rook_pos.notation)
          if continue
            t_file, t_rank = direction == :left ? [o_file - 1, o_rank] : [o_file + 1, o_rank]
            rookward_pos = Position.new([t_file, t_rank])
            mock_rook = Rook.new(player, rook_pos)
            rook_moves = mock_rook.get_moves(board)
            # Check the squares between the King and Rook and empty.
            continue == rook_moves.include?(rookward_pos.notation)
            if continue
              # Check the King isn't currently in check.
              continue == !under_attack?(player, board, king_pos)
              if continue
                exposed = under_attack?(player, board, rookward_pos)
                exposed = under_attack?(player, board, destination) if !exposed
                # Verify if the King will pass through any squares that would put it in check.
                outcome = :verified if !exposed
              end
            end
          end
        end
      end
    end
    outcome ||= :besieged
  end
  
  def make_tracking_variables
    @en_passant_destination = Position.new
    @en_passant_capture = Position.new
    @unmoved_piece_positions = []
    @pieces.each { |piece| @unmoved_piece_positions << piece.pos }
  end
  
  def make_white_pieces
    pieces = []
    pieces << make_pawns_at(:white, 1)
    pieces << make_capitals_at(:white, 0)
    pieces
  end
    
  def make_black_pieces
    pieces = []
    pieces << make_pawns_at(:black, HEIGHT - 2)
    pieces << make_capitals_at(:black, HEIGHT - 1)
    pieces
  end
  
  #############################################
  # These two methods ought be written with a #make_pieces helper method.
  # Such a method could use the splat operator to place multiple pieces.
  def make_pawns_at(player, rank)
    pawns = []
    WIDTH.times { |i| pawns << Pawn.new(player, [i, rank]) }
    pawns
  end
  
  def make_capitals_at(player, rank)
    pieces = []
    pieces << Rook.new(player, [0, rank])
    pieces << Rook.new(player, [7, rank])
    pieces << Knight.new(player, [1, rank])
    pieces << Knight.new(player, [6, rank])
    pieces << Bishop.new(player, [2, rank])
    pieces << Bishop.new(player, [5, rank])
    pieces << Queen.new(player, [3, rank])
    pieces << King.new(player, [4, rank])
    pieces
  end
  
  # All movement checks must use a model or a projection model.
  # This lets detailed checks be performed without manipulating pieces.
  def make_model # This prints the board the wrong way around?
    board = Array.new(WIDTH){ Array.new(HEIGHT, Square.new) }
    @pieces.each do |piece|
      file, rank = piece.pos.index
      board[file][rank] = Square.new(piece.player, piece.type)
    end
    board
  end
  
  # Allows for move simulation to determine if moves put one in check.
  # Currently can't be used to verify future move legality.
  def make_projection_model(move)
    model = make_model
    o_file, o_rank = move.origin.index
    d_file, d_rank = move.destination.index
    model[d_file][d_rank] = model[o_file][o_rank]
    model[o_file][o_rank] = Square.new
    model
  end
  
  def print_rank(board, rank)
    string = "#{rank}"
    rank >= 10 ? string += " " : string += "  "
    1.upto(WIDTH) { |file| string += "[#{get_character_for(board[file - 1][rank - 1])}]" }
    puts string
  end
  
  def print_files
    files = ("A".."Z").to_a.take(WIDTH)
    string = "   "
    files.each { |file| string += " #{file} " }
    puts string
  end
  
  def get_character_for(square)
    index = CHARACTERS[0[0]].index(square.type)
    character = index ? playerize_character(square.player, index) : " "
  end
  
  def playerize_character(player, index)
    list = CHARACTERS[1] if player == :white
    list = CHARACTERS[2] if player == :black
    character = list[index]
  end
  
  def in_check?(player, board)
    king_pos = Position.new
    board.each_with_index do |file, i|
      file.each_with_index do |square, j|
        king_pos = Position.new([i, j]) if square.player == player && square.type == :king
      end
    end
    check = under_attack?(player, board, king_pos)
  end
  
  def under_attack?(player, board, pos)
    return true if under_en_passant_attack?(player, board, pos)
    captures = []
    board.each_with_index do |file, i|
      file.each_with_index do |square, j|
        if square.player != :none && square.player != player
          piece = make_dummy_piece(square.player, Position.new([i, j]), square.type)
          captures << piece.get_captures(board).map { |c| c = c.notation }
        end
      end
    end
    captures.flatten
    captures.include?(pos.notation)
  end
  
  def under_en_passant_attack?(player, board, pos)
    if pos.notation == @en_passant_destination.notation
      file, rank = pos.index
      right, left = board[file + 1, rank + 1], board[file - 1, rank + 1] if player == :white
      right, left = board[file + 1, rank - 1], board[file - 1, rank - 1] if player == :black
      attack = true if right.type == :pawn && right.player != player
      attack = true if left.type == :pawn && left.player != player
    end
    attack ||= false
  end
  
  # This only returns real pieces.
  # If it could interpret pieces from models, #verify_move would be compatible with models.
  # #verify_move could then do multiple future move projections with full move legality checks.
  def get_piece(pos)#, board = :none)
    piece = Piece.new
    @pieces.each { |p| piece = p if p.pos.notation == pos.notation }
    piece
  end
  
  #def get_piece_index(piece)
  #  search = piece.pos.notation
  #  @pieces.each_with_index { |p, i| index = i if p.pos.notation == search }
  #  index
  #end
  
  def make_dummy_piece(player, pos, type)
    pos = pos.notation
    piece = Pawn.new(player, pos) if type == :pawn
    piece ||= Rook.new(player, pos) if type == :rook
    piece ||= Knight.new(player, pos) if type == :knight
    piece ||= Bishop.new(player, pos) if type == :bishop
    piece ||= Queen.new(player, pos) if type == :queen
    piece ||= King.new(player, pos) if type == :king
    piece ||= Piece.new(player, pos)
  end
  
  def get_piece_index(pos)
    index = :none
    @pieces.each_with_index { |piece, i| index = i if piece.pos.notation == pos.notation }
    index
  end
  
  ############################
  # What was this meant to do?
  #def compile_pieces(board)  
  #end

  def remove_piece(pos)
    piece = get_piece(pos)
    @pieces.delete_at(get_piece_index(pos))
  end
  
  # Aliases #remove_pos (for in case a distinction is ever needed).
  def kill_piece(pos)
    remove_piece(pos)
  end
  
end

