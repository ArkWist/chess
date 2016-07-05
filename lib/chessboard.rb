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
  
  ###########################################################################
  # Units are moving to spots they can attack when there's nothing to attack.
  # This is also overriding en passant kills.
  # The problem lies with #verify_move_legality.
  ###########################################################################
  # This only verifies moves for the current board.
  # This means it can't verify (future) moves with (projection) models.
  # Rewriting #get_piece to interpret pieces from models would be step forward,
  #  but future en passants could not be accounted for.
  # Note: Only works with moves with legal positions.
  def verify_move(move, player, board = make_model)#(move))
    origin, destination = move.positions
    piece = get_piece(origin, board)
    outcome = verify_piece(piece, player)
    outcome = verify_move_legality(move, player, board) if outcome == :verified
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
    @new_en_passant = false
    if piece.type == :pawn
      clean_up_en_passant(move) if verify_en_passant(move) == :verified
      record_double_step(move) if unmoved_piece?(origin)
    elsif piece.type == :king
      clean_up_castle(move) if verify_castle(mode) == :verified
    end
    
    # This kill the attacker
    @pieces[origin_index].move_to(destination)
    kill_piece(destination) if capture_index != :none
    
    # This duplicates the attacker
    kill_piece(destination) if capture_index != :none
    @pieces[origin_index].move_to(destination)
    
    clean_up_tracking_variables(move)
  end
  
  def promote?(move)
    origin, destination = move.positions
    file, rank = destination.index
    promote = get_piece(origin).type == :pawn && (rank == 0 || rank == HEIGHT - 1)
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
  
  def checkmate?(player)
    board, checkmate = make_model, true
    return checkmate if in_check?(player, board)
    board.each_with_index do |file, i|
      file.each_with_index do |square, j|
        if checkmate && square.player == player
          piece = make_dummy_piece(player, Position.new([i, j]), square.type)
          moves = piece.get_all_moves(board).map { |c| c = c.notation }
          moves.each do |pos|
            origin = Position.new([i, j])
            destination = Position.new(pos)
            model = make_projection_model(Move.new("#{origin.notation}#{destination.notation}"))
            checkmate = false if !in_check?(player, board)
          end
        end
      end
    end
    checkmate
  end
  
  private
  
  def make_tracking_variables
    @en_passant_destination = Position.new
    @en_passant_capture = Position.new
    @new_en_passant = false
    @unmoved_piece_positions = []
    @pieces.each { |piece| @unmoved_piece_positions << piece.pos }
  end
  
  def make_white_pieces
    pieces = []
    pieces << make_pieces_at(:white, :pawn, "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2")
    pieces << make_pieces_at(:white, :rook, "a1", "h1")
    pieces << make_pieces_at(:white, :knight, "b1", "g1")
    pieces << make_pieces_at(:white, :bishop, "c1", "f1")
    pieces << make_pieces_at(:white, :queen, "d1")
    pieces << make_pieces_at(:white, :king, "e1")
    pieces
  end
    
  def make_black_pieces
    pieces = []
    pieces << make_pieces_at(:black, :pawn, "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7")
    pieces << make_pieces_at(:black, :rook, "a8", "h8")
    pieces << make_pieces_at(:black, :knight, "b8", "g8")
    pieces << make_pieces_at(:black, :bishop, "c8", "f8")
    pieces << make_pieces_at(:black, :queen, "d8")
    pieces << make_pieces_at(:black, :king, "e8")
    pieces
  end
  
  def make_pieces_at(player, type, *pos)
    pieces = []
    case type
    when :pawn
      pos.each { |p| pieces << Pawn.new(player, p) }
    when :rook
      pos.each { |p| pieces << Rook.new(player, p) }
    when :knight
      pos.each { |p| pieces << Knight.new(player, p) }
    when :bishop
      pos.each { |p| pieces << Bishop.new(player, p) }
    when :queen
      pos.each { |p| pieces << Queen.new(player, p) }
    when :king
      pos.each { |p| pieces << King.new(player, p) }
    else
      pos.each { pieces << Piece.new(player, p) }
    end
    pieces
  end
  
  # Models allow for move legality checks to e done without manipulating pieces.
  def make_model # This prints the board the wrong way around?
    board = Array.new(WIDTH){ Array.new(HEIGHT, Square.new) }
    @pieces.each do |piece|
      file, rank = piece.pos.index
      board[file][rank] = Square.new(piece.player, piece.type)
    end
    board
  end
  
  # Allows for move simulation to determine if moves put one in check.
  # Because it can't track possible future en passants,
  #  it cannot perfectly verify future move legality.
  def make_projection_model(move)
    model = make_model
    origin, destination = move.positions
    piece = get_piece(origin, model)
    model = project_en_passant(move, model) if piece.type == :pawn
    model = project_castle(move, model) if piece.type == :king
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    model[d_file][d_rank] = model[o_file][o_rank]
    model[o_file][o_rank] = Square.new
    model
  end
  
  #######################################################
  # Does this still return verified for illegal captures?
  def verify_move_legality(move, player, board = make_model)
    origin, destination = move.positions
    o_piece = get_piece(origin, board)
    d_piece = get_piece(destination, board)
    moves = o_piece.get_all_moves(board)
    moves = moves.map { |move| move = move.notation }
    outcome = :blocked if d_piece.player == player
    outcome ||= :illegal if !moves.include?(destination.notation)
    outcome ||= :verified
    outcome
  end
  
  def verify_piece(piece, player)
    outcome = :empty if piece.type == :none
    outcome ||= :occupied if piece.player != player
    outcome ||= :verified
  end
  
  def verify_en_passant(move, board = make_model)
    origin, destination = move.positions
    outcome = :illegal
    if destination.notation == @en_passant_destination.notation && \
       get_piece(origin, board).can_en_passant?(board, @en_passant_destination) then outcome = :verified
    end
    outcome
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
          continue = unmoved_piece?(king_pos) && unmoved_piece?(rook_pos)
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
  
  def unmoved_piece?(pos)
    unmoved = false
    @unmoved_piece_positions.each { |p| unmoved = true if p.notation == pos.notation }
    unmoved
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
  
  def project_en_passant(move, model)
    if verify_en_passant(move, model) == :verified
      file, rank = @en_passant_capture.index
      model[file][rank] = Square.new
    end
    model
  end
  
  def project_castle(move, model)
    if verify_castle(move, model) == :verified
      origin, destination = move.positions
      o_file, o_rank = origin.index
      d_file, d_rank = destination.index
      if d_file < o_file
        player = model[0, d_rank].player
        model[0, d_rank] = Square.new
        model[d_file + 1, d_rank] = Square.new(player, :rook)
      else
        player = model[WIDTH - 1, d_rank].player
        model[WIDTH - 1, d_rank] = Square.new
        model[d_file - 1, d_rank] = Square.new(player, :rook)
      end
    end
    model    
  end

  def record_double_step(move)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    if (d_rank - o_rank).abs == 2
      piece = get_piece(origin)
      @en_passant_capture = Position.new([d_file, d_rank])
      @en_passant_destination = Position.new([d_file, d_rank - 1]) if piece.player == :white
      @en_passant_destination = Position.new([d_file, d_rank + 1]) if piece.player == :black
      @new_en_passant = true
    end
    puts "Double step -- en_passant -- destination, capture: #{@en_passant_destination.notation}, #{@en_passant_capture.notation}"
  end
  
  def clean_up_en_passant(move)
    kill_piece(@en_passant_capture)
    @en_passant_destination, @en_passant_capture = Position.new, Position.new
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
  
  def clean_up_tracking_variables(move)
    origin, destination = move.positions
    @unmoved_piece_positions.delete(origin.notation)
    @unmoved_piece_positions.delete(destination.notation)
    @en_passant_destination, @en_passant_capture = Position.new, Position.new unless @new_en_passant
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
  
  # This only returns real pieces.
  # If it could read pieces from models,
  #  #verify_move could be made to work with future move projections.
  def get_piece(pos, board = nil)
    piece = Piece.new
    @pieces.each { |p| piece = p if p.pos.notation == pos.notation }
    piece
  end
  
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

  def remove_piece(pos)
    piece = get_piece(pos)
    @pieces.delete_at(get_piece_index(pos))
  end
  
  # Aliases #remove_pos (for in case a distinction is ever needed).
  def kill_piece(pos)
    remove_piece(pos)
  end
  
end

