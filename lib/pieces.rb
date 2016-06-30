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
  
  def move_to(destination)
    @pos = destination
  end
  
  private
  
  def path_moves(board, direction, steps = -1)
    moves = []
    file, rank = @pos.index
    until steps == 0
      file, rank = poll_direction(direction, file, rank).index
      if !board[file][rank].nil? && board[file][rank].type == :none
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
    moves.empty? ? file, rank = @pos.index : file, rank = moves[-1].pos.index
    steps -= moves.length
    captures = []
    unless steps == 0
      file, rank = poll_direction(direction, file, rank).index
      if !board[file][rank].nil? && board[file][rank].player != @player
        captures << Position.new([file, rank])
      end
    end
    captures
  end
  
  def poll_direction(direction, file, rank)
    case direction.to_s
    when include?("n")
      rank += 1 if @player == :white
      rank -= 1 if @player == :black
    when include?("e")
      file += 1 if @player == :white
      file -= 1 if @player == :black
    when include?("s")
      rank -= 1 if @player == :white
      rank += 1 if @player == :black
    when include?("w")
      file -= 1 if @player == :white
      file += 1 if @player == :black
    end
    pos = Position.new([file][rank])
  end
end


class Pawn < Piece

  def initialize(player, position)
    super(player, position)
    @type = :pawn
  end
  
  def try_move_to(destination)
    if get_moves.include?(destination)
      outcome = :moved
      move_to(destination)
    end
    outcome ||= :blocked
    outcome
  end
  
  def can_en_passant?(board, en_passant)
    can = false
    make_en_passant_list.each { |move| can = move.notation == en_passant.notation unless can }
    can
  end
  
  private
  
  def make_move_list(board)
    starting_rank? ? moves = path_moves(board, :n, 2) : moves = path_moves(board, :n, 1)
    moves.flatten
  end
  
  def make_capture_list(board)
    captures = path_captures(board, :ne, 1) << path_captures(board, :nw, 1)
    captures.flatten
  end
  
  def make_en_passant_list(board)
    moves = path_moves(board, :ne, 1) << path_moves(board, :nw, 1)
    moves.flatten
  end
  
  def starting_rank?(board)
    file, rank = @pos.index
    starting = @player == :white && rank == 1
    starting = @player == :black && rank == board[0].length - 2 unless starting
    starting
  end
end









