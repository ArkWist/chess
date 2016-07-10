# lib/chessboard.rb


class Chessboard
  HEIGHT, WIDTH = 8, 8
  CHARACTERS = [[:pawn, :rook, :knight, :bishop, :queen, :king], \
               [ "P",   "R",   "N",     "B",     "Q",    "K"],   \
               [ "p",   "r",   "n",     "b",     "q",    "k"]]
               
  def initialize
    @pieces = (make_white_pieces + make_black_pieces).flatten
    @en_passant_destination = Position.new
    @en_passant_capture = Position.new
    @new_en_passant = false
    @fifty_move_counter = 0
    @unmoved_piece_positions = []
    @pieces.each { |piece| @unmoved_piece_positions << piece.pos }
  end
  
  def print_board
    print_files
    puts
    (HEIGHT).downto(1) { |rank| print_rank(make_model, rank) }
    puts
    print_files
  end
  
  # This only verifies moves for the current board.
  # It can't verify (future) moves with (projection) models.
  # Returns -- :move, :empty, :blocked, :occupied, :illegal, :besieged, :exposed
  def verify_move(player, move)
    origin, destination = move.positions
    board = make_model
    square = get_square(origin, board)
    move_outcome = case square.player when player then verify_move_legality(player, move)
                                      when :none then :empty
                                      else :occupied end
  end
  
  def do_move(move)
    origin, destination = move.positions
    piece, capture = get_piece(origin), get_piece_index(destination)
    @new_en_passant = false
    @fifty_move_counter += 1
    clean_up_after_special_moves(move)
    kill_piece(destination) if capture_index
    @pieces[get_piece_index(origin)].move_to(destination)
    update_tracking(move)
  end
  
  def promote?(move)
    origin, destination = move.positions
    file, rank = destination.index
    promote = get_piece(destination).type == :pawn && (rank == 0 || rank == HEIGHT - 1)
  end
  
  def do_promotion(move, type)
    origin, destination = move.positions
    player = get_piece(destination).player
    case type when :queen then piece = Queen.new(player, destination.notation)
               when :bishop then piece = Bishop.new(player, destination.notation)
               when :rook then piece = Rook.new(player, destination.notation)
               when :knight then piece = Knight.new(player, destination.notation) end
    remove_piece(destination)
    @pieces << piece
  end
  
  def checkmate?(player, board = make_model)
    return true if in_check?(player, board)
    checkmate = true
    board.each_with_index do |file, f|
      file.each_with_index do |square, r|
        if checkmate && square.player == player
          piece = make_pieces_at(square.player, square.type, Position.new([file, rank]).notation)
          moves = list_to_notation(piece.get_all_moves(board))
          test_origin = Position.new([f, r])
          checkmate = false if are_safe_moves?(player, moves, test_origin, board)
        end
      end
    end
    checkmate
  end
  
  def stalemate?(player, board = make_model)
    stalemate = true
    board.each_with_index do |file, f|
      file.each_with_index do |square, r|
        if square.player == player
          piece = make_pieces_at(square.player, square.type, Position.new([file, rank]).notation)
          moves = list_to_notation(piece.get_all_moves(board))
          stalemate = false if stalemate && moves.flatten.length > 0
        end
      end
    end
    stalemate
  end
  
  def fifty_moves?
    @fifty_move_counter >= 100
  end
  
################################################################
  # Insufficient material checking has not yet been implemented.
  # Players must (currently) request and agree to a draw or wait for a fifty-move rule invocation.
  def insufficient_material?(player)
    return false
  end
  
  # Threefold repetition tracking and checking have not been implemented.
  # Players must request and agree to a draw or wait for a fifty-move rule invocation.
  def threefold_repetition?
    return false
  end
  
  ########
  #private
  ########
  
  # Returns -- :move, :blocked, :illegal, :besieged, :exposed
  def verify_move_legality(player, move)
    origin, destination = move.positions
    move_outcome = if blocked_move?(player, destination) then :blocked
                    elsif illegal_move?(origin, destination) then if can_en_passant?(origin, destination) then :move
                                                                    elsif is_castle_move?(origin, destination) then if can_castle?(origin, destination) then :move
                                                                                                                      else :besieged end
                                                                    else :illegal end
                    else :move end
    move_outcome = case move_outcome when :move then if in_check?(player, make_projection_model(move)) then :exposed
                                                       else :move end
                                      else move_outcome end
  end
  
  def blocked_move?(player, destination)
    square = get_square(destination, make_model)
    blocked = player == square.player
  end
  
  def illegal_move?(origin, destination) # destination in move list?
    piece = get_piece(origin, board)
    moves = piece.get_all_moves(board).map { |move| move = move.notation }
    illegal = !moves.include?(destination.notation)
  end
  
  def can_en_passant?(origin, destination, board = make_model)
    can = destination.notation == @en_passant_destination.notation && \
          get_piece(origin, board).can_en_passant?(make_model, @en_passant_destination)
  end
  
  def is_castle_move?(origin, destination)
    board = make_model
    king, rook = get_square(origin, board), get_square(get_castle_rook_position(origin, destination), board)
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    castle = king.type == :king && rook.type == :rook && king.player == rook.player && \
             (o_file - d_file).abs == 2 && is_unmoved_at?(origin) && is_unmoved_at?(destination)
  end
  
  def can_castle?(origin, destination, board = make_model)
    player = get_square(origin).player
    rook_origin = get_castle_rook_position(origin, destination)
    o_file, o_rank = origin.index
    r_file, r_rank = rook_origin.index
    rd_file = if is_kingside?(origin, destination) then d_file - 1 else d_file + 1 end
    rook_destination = Position.new([rd_file, r_rank])
    can = list_to_notation(get_piece(rook_origin, board).get_moves(board)).include?(rook_destination.notation) && \
          !under_attack?(player, origin, board) && !under_attack?(player, destination, board) && !under_attack?(player, rook_destination, board)
  end
  
  def is_kingside?(origin, destination)
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    kingside = o_file > d_file
  end
  
  def get_castle_rook_position(origin, destination)
    o_file, o_rank = origin.index
    r_file = if is_kingside?(origin, destination) then WIDTH - 1 else 0 end
    position = Position.new(r_file, o_rank)
  end
  
  # Compatible with projection models one move ahead.
  def in_check?(player, board = make_model)
    king = Position.new
    board.each_with_index do |file, f|
      file.each_with_index do |square, r|
        king = Position.new([f, r]) if square.player == player && square.type == :king
      end
    end
    check = under_attack?(player, king, board)
  end
  
  def under_attack?(player, pos, board)
    attack = under_en_passant_attack?(player, pos, board) || list_to_notation(get_enemy_captures(player, board)).include?(pos.notation)
  end
  
  def under_en_passant_attack?(player, pos, board)
    file, rank = pos.index
    right, left = if player == :white then Position.new([file + 1, rank + 1]), Position.new([file - 1, rank + 1])
                                       else Position.new([file + 1, rank - 1]), Position.new([file - 1, rank - 1])
    attackable = can_en_passant?(right, pos, board) || can_en_passant?(left, pos, board)
  end
  
  def are_safe_moves?(player, moves, origin, board)
    safe = false
    moves.each do |pos|
      destination = Position.new(pos)
      board = make_projection_model(Move.new("#{origin.notation}#{destination.notation}"))
      safe = true if !in_check?(player, board)
    end
    safe
  end
  
  def get_enemy_captures(player, board)
    captures = []
    board.each_with_index do |file, f|
      file.each_with_index do |square, r|
        if square.type != :none && square.player != :none && square.player != player
          piece = make_pieces_at(square.player, square.type, Position.new([f, r]))
          captures << piece.get_captures(board)
        end
      end
    end
    captures.flatten
  end
  
  def project_en_passant(move, board)
    origin, destination = move.positions
    if can_en_passant?(origin, destination, board)
      file, rank = @en_passant_capture.index
      board[file][rank] = Square.new
    end
    board
  end
  
  def project_castle(move, board)
    origin, destination = move.positions
    if can_castle?(origin, destination, board) then board = model_castle(origin, destination, board) end
    board
  end
  
  def model_castle(origin, destination, board)
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    r_file, r_rank = get_castle_rook_position(origin, destination).index
    rd_file = if is_kingside?(origin, destination) then d_file - 1 else d_file + 1 end
    board[o_file][o_rank], board[d_file][d_rank] = board[d_file][d_rank], board[o_file][o_rank]
    board[r_file][r_rank], board[rd_file, r_rank] = board[rd_file, r_rank], board[r_file][r_rank]
    board
  end
  
  def clean_up_after_special_moves(move)
    origin, destination = move.positions
    case get_piece(origin).type
    when :pawn
      @fifty_move_counter = 0
      complete_en_passant(move) if destination = @en_passant_destination
      record_double_step(move) if is_unmoved_at?(origin)
    when :king
      complete_castle(move) if can_castle?(move)
    end
  end
  
  def record_double_step(move)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    if (d_rank - o_rank).abs == 2
      player = get_piece(origin).player
      @en_passant_capture = Position.new(destination.notation)
      @en_passant_destination = if player == :white then Position.new([d_file, d_rank - 1])
                                                     else Position.new([d_file, d_rank + 1]) end
      @new_en_passant = true
    end
  end
  
  def complete_en_passant(move)
    kill_piece(@en_passant_capture)
    @en_passant_destination, @en_passant_capture = Position.new, Position.new
  end
  
  def complete_castle(move)
    origin, destination = move.positions
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    r_file, r_rank = get_castle_rook_position(origin, destination).index
    rd_file = if is_kingside?(origin, destination) then d_file - 1 else d_file + 1 end
    rook_index = get_piece_index(Position.new([r_file, o_rank]))
    rook_destination = Position.new([rd_file, d_rank])
    @pieces[rook_index].move_to(rook_destination)
    @unmoved_piece_positions.delete(Position.new([r_file][r_rank]).notation)
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
    when :pawn then pos.each { |p| pieces << Pawn.new(player, p) }
    when :rook then pos.each { |p| pieces << Rook.new(player, p) }
    when :knight then pos.each { |p| pieces << Knight.new(player, p) }
    when :bishop then pos.each { |p| pieces << Bishop.new(player, p) }
    when :queen then pos.each { |p| pieces << Queen.new(player, p) }
    when :king then pos.each { |p| pieces << King.new(player, p) }
    else pos.each { pieces << Piece.new(player, p) } end
    pieces.flatten
  end
  
  # Models let you do move legality checks without manipulating the board.
  def make_model # This prints the board the wrong way around?
    board = Array.new(WIDTH){ Array.new(HEIGHT, Square.new) }
    @pieces.each do |piece|
      file, rank = piece.pos.index
      board[file][rank] = Square.new(piece.player, piece.type)
    end
    board
  end
  
  # Simulates future moves for "will this put me in check?" tests.
  # It can't track future en passants, so can't perfectly predict future move legality.
  def make_projection_model(move)
    model = make_model
    origin, destination = move.positions
    piece = get_piece(origin, model)
    model = if piece.type == :pawn then project_en_passant(move, model)
            elsif piece.type == :king then project_castle(move, model)
            else model end
    o_file, o_rank = origin.index
    d_file, d_rank = destination.index
    model[d_file][d_rank], model[o_file][o_rank] = model[o_file][o_rank], Square.new
    model
  end
  
  def is_unmoved_at?(pos)
    unmoved = list_to_notation(@unmoved_piece_positions).include?(pos.notation)
  end
  
  def list_to_notation(list)
    list.map { |pos| pos = pos.notation }
  end
  
  def get_piece(pos, board)
    square = get_square(pos, board)
    piece = make_pieces_at(square.player, square.type, pos)
  end
  
  def get_square(pos, board)
    file, rank = pos.index
    square = board[file][rank]
  end
  
  def get_piece_index(pos)
    index = nil
    @pieces.each_with_index { |piece, i| index = i if piece.pos.notation == pos.notation }
    index
  end
  
  def remove_piece(pos)
    @pieces.delete_at(get_piece_index(pos))
  end
  
  def kill_piece(pos)
    remove_piece(pos)
    @fifty_move_counter = 0
  end
  
  def update_tracking(move)
    origin, destination = move.positions
    @unmoved_piece_positions.delete(origin.notation)
    @unmoved_piece_positions.delete(destination.notation)
    unless @new_en_passant then @en_passant_destination, @en_passant_capture = Position.new, Position.new end
  end
  
  def print_rank(board, rank)
    string = "#{rank}"
    rank >= 10 ? string += " " : string += "  "
    1.upto(WIDTH) { |file| string += "[#{get_character_for(board[file - 1][rank - 1])}]" }
    rank >= 10 ? string += " " : string += "  "
    string += "#{rank}"
    puts string
  end
  
  def print_files
    files = ("a".."z").to_a.take(WIDTH)
    string = "   "
    files.each { |file| string += " #{file} " }
    puts string
  end
  
  def get_character_for(square)
    index = CHARACTERS[0[0]].index(square.type)
    character = if index then get_playerized_character(square.player, index) else " " end
  end
  
  def get_playerized_character(player, index)
    list = if player == :white then CHARACTERS[1]
                                else CHARACTERS[2] end
    character = list[index]
  end
  
end

# End
