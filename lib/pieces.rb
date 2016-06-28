# Pieces

class Piece
  attr_accessor :player, :icon, :pos

  def initialize(player, icons)
    @player = player
    @icon = icons[0] if player == Chess::WHITE
    @icon = icons[1] if player == Chess::BLACK
    @icon ||= Chess::NO_POS
  end
  
  def set_pos(pos)
    @pos = pos
  end
  
  def get_pos
    @pos
  end
  
  def read_pos
    @pos.pos
  end
  
  def get_owner
    @player
  end
  
  def get_distant_captures(board, direction)
    captures = []
    empty = board.empty_up_to(@pos, direction)
    if empty.length > 0
      last_empty = Position.new(empty[-1])
      captures << board.capturable(last_empty, direction, @player)
    else
      captures << board.capturable(@pos, direction, @player)
    end
    captures
  end
  
end


class Pawn < Piece
  ICONS = ["P", "p"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    steps = 1
    moves = board.empty_up_to(@pos, :n, steps) if @player == Chess::WHITE
    moves = board.empty_up_to(@pos, :s, steps) if @player == Chess::BLACK
    moves.flatten!
    moves
  end
  
  def get_double_step(board)
    steps = 2
    moves = []
    empty = board.empty_up_to(@pos, :n, steps) if @player == Chess::WHITE
    empty = board.empty_up_to(@pos, :s, steps) if @player == Chess::BLACK
    if empty.length == steps
      moves << empty[-1]
    end
    moves
  end
  
  def get_captures(board)
    captures = []
    captures << board.capturable(@pos, :ne, @player) if @player == Chess::WHITE
    captures << board.capturable(@pos, :nw, @player) if @player == Chess::WHITE
    captures << board.capturable(@pos, :se, @player) if @player == Chess::BLACK
    captures << board.capturable(@pos, :sw, @player) if @player == Chess::BLACK
    captures.delete(Chess::NO_POS)
    captures
  end
  
  def get_en_passant_capture(board)
    col, row = @pos.to_index
    captures = []
    left, right = Position.new([col - 1, row]), Position.new([col + 1, row])
    if board.valid_position?(left) && left.to_notation == board.en_passant
      capture = Position.new([col - 1, row + 1]) if @player == Chess::WHITE
      capture = Position.new([col - 1, row - 1]) if @player == Chess::BLACK
      captures << capture.to_notation
    elsif board.valid_position?(right) && right.to_notation == board.en_passant
      capture = Position.new([col + 1, row + 1]) if @player == Chess::WHITE
      capture = Position.new([col + 1, row - 1]) if @player == Chess::BLACK
      captures << capture.to_notation
    end
    captures
  end
  
end

class Rook < Piece
  ICONS = ["R", "r"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    moves = []
    moves << board.empty_up_to(@pos, :n)
    moves << board.empty_up_to(@pos, :e)
    moves << board.empty_up_to(@pos, :s)
    moves << board.empty_up_to(@pos, :w)
    moves.flatten!
    moves
  end
  
  def get_rook_castle(board)
    col, row = @pos.to_index
    moves = []
    ######
    moves
  end
  
  def get_captures(board)
    captures = []
    captures << get_distant_captures(board, :n)
    captures << get_distant_captures(board, :e)
    captures << get_distant_captures(board, :s)
    captures << get_distant_captures(board, :w)
    captures.flatten!
    captures
  end
  
end

class Knight < Piece
  ICONS = ["N", "n"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    moves = []
    positions = get_positions
    positions.each { |pos| moves << pos.pos if board.valid_position?(pos) && board.is_empty?(pos) }
    moves
  end
  
  def get_captures(board)
    captures = []
    positions = get_positions
    positions.each { |pos| captures << pos.pos if board.valid_position?(pos) && board.is_enemy?(pos, @player) }
    captures
  end
  
  def get_positions
    col, row = @pos.to_index
    positions = []
    positions << Position.new([col - 2, row - 1])
    positions << Position.new([col - 2, row + 1])
    positions << Position.new([col - 1, row - 2])
    positions << Position.new([col - 1, row + 2])
    positions << Position.new([col + 1, row - 2])
    positions << Position.new([col + 1, row + 2])
    positions << Position.new([col + 2, row - 1])
    positions << Position.new([col + 2, row + 1])
    positions.map! { |pos| pos = Position.new(pos.to_notation) }
    positions
  end
  
end

class Bishop < Piece
  ICONS = ["B", "b"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    moves = []
    moves << board.empty_up_to(@pos, :ne)
    moves << board.empty_up_to(@pos, :se)
    moves << board.empty_up_to(@pos, :sw)
    moves << board.empty_up_to(@pos, :nw)
    moves.flatten!
    moves
  end
  
  def get_captures(board)
    captures = []
    captures << get_distant_captures(board, :ne)
    captures << get_distant_captures(board, :se)
    captures << get_distant_captures(board, :sw)
    captures << get_distant_captures(board, :nw)
    captures.flatten!
    captures
  end
  
end

class Queen < Piece
  ICONS = ["Q", "q"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    moves = []
    moves << board.empty_up_to(@pos, :n)
    moves << board.empty_up_to(@pos, :ne)
    moves << board.empty_up_to(@pos, :e)
    moves << board.empty_up_to(@pos, :se)
    moves << board.empty_up_to(@pos, :s)
    moves << board.empty_up_to(@pos, :sw)
    moves << board.empty_up_to(@pos, :w)
    moves << board.empty_up_to(@pos, :nw)
    moves.flatten!
    moves
  end
  
  def get_captures(board)
    captures = []
    captures << get_distant_captures(board, :n)
    captures << get_distant_captures(board, :ne)
    captures << get_distant_captures(board, :e)
    captures << get_distant_captures(board, :se)
    captures << get_distant_captures(board, :s)
    captures << get_distant_captures(board, :sw)
    captures << get_distant_captures(board, :w)
    captures << get_distant_captures(board, :nw)
    captures.flatten!
    captures
  end
  
end

class King < Piece
  ICONS = ["K", "k"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  # Must check not going into check before allowing a move
  
  def get_moves(board)
    steps = 1
    moves = []
    moves << board.empty_up_to(@pos, :n, steps)
    moves << board.empty_up_to(@pos, :ne, steps)
    moves << board.empty_up_to(@pos, :e, steps)
    moves << board.empty_up_to(@pos, :se, steps)
    moves << board.empty_up_to(@pos, :s, steps)
    moves << board.empty_up_to(@pos, :sw, steps)
    moves << board.empty_up_to(@pos, :w, steps)
    moves << board.empty_up_to(@pos, :nw, steps)
    moves.flatten!
    #safe_moves = []
    #moves.each do |move|
    #  safe_moves << move if board.king_would_be_safe?(@player, @pos, move)
    #end
    # Generates a list of possible moves
    # Should make a temporary board where it makes the move
    # Then checks if king under attack in each
    moves
  end
  
  def get_king_castle(board)
    castles = []
    castles
  end
  
  def get_captures(board)
    captures = []
    captures << board.capturable(@pos, :n, @player)
    captures << board.capturable(@pos, :ne, @player)
    captures << board.capturable(@pos, :e, @player)
    captures << board.capturable(@pos, :se, @player)
    captures << board.capturable(@pos, :s, @player)
    captures << board.capturable(@pos, :sw, @player)
    captures << board.capturable(@pos, :w, @player)
    captures << board.capturable(@pos, :nw, @player)
    captures.delete(Chess::NO_POS)
    captures
  end
  
end
