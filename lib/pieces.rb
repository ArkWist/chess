#require_relative "positions"


# If refactoring, consider making Piece a module.
# This will clear up complicating supers.
# Note: This means Chessboard must be checked it doesn't use generic Pieces.
class Piece
  attr_reader :player, :pos, :type

  def initialize(player = :none, position = :none)
    @player = player
    @pos = Position.new(position)
    @type = :none
  end
  
  def get_moves(board)
    moves = make_move_list(board) << make_capture_list(board)
    moves.flatten
  end
  
  def get_captures(board)
    captures = make_capture_list(board)
    captures.flatten
  end
  
  def move_to(destination)
    @pos = destination
  end
  
  private
  
  def path_moves(board, direction, steps = -1)
    moves = []
    file, rank = @pos.index
    until steps == 0
      pos = poll_direction(direction, file, rank)
      file, rank = pos.index
      if legal_position?(pos) && board[file][rank].type == :none
        moves << Position.new([file, rank])
        steps -= 1
      else
        steps = 0
      end
    end
    moves
  end
  
  def path_captures(board, direction, steps = -1)
    moves = path_moves(board, direction, steps)
    file, rank = moves.empty? ? @pos.index : moves[-1].index
    steps -= moves.length
    captures = []
    unless steps == 0
      pos = poll_direction(direction, file, rank)
      file, rank = pos.index
      if legal_position?(pos) && board[file][rank].type != :none && board[file][rank].player != @player
        captures << Position.new([file, rank])
      end
    end
    captures
  end
  
  def poll_direction(direction, file, rank)
    direction = direction.to_s
    if direction.include?("n")
      rank += 1 if @player == :white
      rank -= 1 if @player == :black
    end
    if direction.include?("e")
      file += 1 if @player == :white
      file -= 1 if @player == :black
    end
    if direction.include?("s")
      rank -= 1 if @player == :white
      rank += 1 if @player == :black
    end
    if direction.include?("w")
      file -= 1 if @player == :white
      file += 1 if @player == :black
    end
    pos = Position.new([file, rank])
  end
  
  def legal_position?(pos)
    file, rank = pos.index
    legal = (file >= 0 && file < Chessboard::WIDTH) && (rank >= 0 && rank < Chessboard::HEIGHT)
  end
  
end


class Pawn < Piece

  def initialize(player, position)
    super(player, position)
    @type = :pawn
  end
  
  def can_en_passant?(board, en_passant)
    make_en_passant_list.each { |move| can = move.notation == en_passant.notation unless can }
    can ||= false
  end
  
  private
  
  def make_move_list(board)
    moves = starting_rank?(board) ? [path_moves(board, :n, 2)] : [path_moves(board, :n, 1)]
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :ne, 1) << path_captures(board, :nw, 1)
  end
  
  def make_en_passant_list(board)
    moves = path_moves(board, :ne, 1) << path_moves(board, :nw, 1)
  end
  
  def starting_rank?(board)
    file, rank = @pos.index
    starting = @player == :white && rank == 1
    starting = @player == :black && rank == board[0].length - 2 unless starting
    starting
  end
  
end


class Rook < Piece

  def initialize(player, position)
    super(player, position)
    @type = :rook
  end
  
  private
  
  def make_move_list(board)
    moves = path_moves(board, :n) << path_moves(board, :e) << path_moves(board, :s) << path_moves(board, :w)
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :n) << path_captures(board, :e) << path_captures(board, :s) << path_captures(board, :w)
  end
  
end


class Knight < Piece

  def initialize(player, position)
    super(player, position)
    @type = :knight
  end
  
  private
  
  def make_move_list(board)
    moves = []
    make_possible_moves_list.each do |move|
      file, rank = move.index
      moves << move if !board[file][rank].nil? && board[file][rank].type == :none
    end
    moves
  end
  
  def make_capture_list(board)
    captures = []
    make_possible_moves_list.each do |move|
      file, rank = move.index
      next if !legal_position?(move)
      captures << move if !board[file][rank].nil? && board[file][rank].type != :none && board[file][rank].player != @player
    end
    captures
  end
  
  def make_possible_moves_list
    file, rank = @pos.index
    options = []
    options << Position.new([file + 1, rank + 2])
    options << Position.new([file + 1, rank - 2])
    options << Position.new([file - 1, rank + 2])
    options << Position.new([file - 1, rank - 2])
    options << Position.new([file + 2, rank + 1])
    options << Position.new([file + 2, rank - 1])
    options << Position.new([file - 2, rank + 1])
    options << Position.new([file - 2, rank - 1])
    options
  end
  
end


class Bishop < Piece

  def initialize(player, position)
    super(player, position)
    @type = :bishop
  end
  
  private
  
  def make_move_list(board)
    moves = path_moves(board, :ne) << path_moves(board, :se) << path_moves(board, :sw) << path_moves(board, :nw)
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :ne) << path_captures(board, :se) << path_captures(board, :sw) << path_captures(board, :nw)
  end
  
end


class Queen < Piece

  def initialize(player, position)
    super(player, position)
    @type = :queen
  end
  
  private
  
  def make_move_list(board)
    moves = path_moves(board, :n) << path_moves(board, :e) << path_moves(board, :s) << path_moves(board, :w) \
         << path_moves(board, :ne) << path_moves(board, :se) << path_moves(board, :sw) << path_moves(board, :nw)
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :n) << path_captures(board, :e) << path_captures(board, :s) << path_captures(board, :w) \
            << path_captures(board, :ne) << path_captures(board, :se) << path_captures(board, :sw) << path_captures(board, :nw)
  end
  
end


class King < Piece

  def initialize(player, position)
    super(player, position)
    @type = :king
  end
  
  #######################################################
  # Exterior methods are needed to check castle legality.
  # This is because King isn*t equipped to do its own #in_check? tests.
  # Even if it were, King can't read if a Rook has moved.
  #def can_castle?(board)
  #  can = false
  #  make_castle_list.each do |move|
  #  end
  #  can
  #end
  
  private
  
  def make_move_list(board)
    moves = path_moves(board, :n, 1) << path_moves(board, :e, 1) << path_moves(board, :s, 1) << path_moves(board, :w, 1) \
         << path_moves(board, :ne, 1) << path_moves(board, :se, 1) << path_moves(board, :sw, 1) << path_moves(board, :nw, 1)
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :n, 1) << path_captures(board, :e, 1) << path_captures(board, :s, 1) << path_captures(board, :w, 1) \
            << path_captures(board, :ne, 1) << path_captures(board, :se, 1) << path_captures(board, :sw, 1) << path_captures(board, :nw, 1)
  end
  
  def make_castle_list(board)
    moves = []
    left = path_moves(board, :w, 2)
    right = path_moves(board, :e, 2)
    moves << left[-1] if left.length == 2
    moves << right[-1] if right.length == 2
    moves.flatten
  end
  
end












