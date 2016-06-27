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
  end
  
  def get_captures(board)
  end
  
end

class Queen < Piece
  ICONS = ["Q", "q"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
  end
  
  def get_captures(board)
  end
  
end

class King < Piece
  ICONS = ["K", "k"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
  end
  
  def get_king_castle(board)
  end
  
  def get_captures(board)
  end
  
end


=begin
class Piece
  attr_accessor :owner, :moved, :position
  
  def initialize(owner)
    @owner = owner
    @moved = false
    @position = position
  end
  
  def valid_move?()
  end
end


class Position
  attr_accessor :col, :row
  
  def initialize(col, row)
    @col = col
    @row = row
  end

  def to_notation(index)
    col = col_to_notation(index[0])
    row = row_to_notation(index[1])
    notation = "#{col}#{row}"
  end
  def to_index(notation)
    col = col_to_index(notation[0].to_i)
    row = row_to_index(notation[1].to_i)
    index = [col, row]
  end
  
  def col_to_notation(index)
    alphabet = ("a".."h").to_a
    alphabet[index]
  end
  def col_to_index(notation)
    alpha = Board.col_range
    alpha.index(notation)
  end
  def row_to_notation(index)
    index += 1
  end
  def row_to_index(notation)
    notation -= 1
  end
end


class Move
  attr_accessor :from, :to
  
  def initialize(from, to)
    @from = from
    @to = to
  end
end


class Pawn < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♙" if owner == Chess::WHITE
    @icon = "♟" if owner == Chess::BLACK
    @icon ||= "P"
  end
  
=begin
  def possible_valid_moves(@position)
    valid_moves = nil
    valid_moves << #one ahead
             [@position.first, @position.last + 1]
    valid_moves << [@position.first, @position.last + 2] if !@moved
    
    #But how does it know attack valid_moves?
    #How to relay this information between Pawn and Board?
    #Pawn must be able to see Board
    #And Pawn must be able to decide what is valid
    
    #Piece needs to be told what the board looks like
    #Piece needs to be told about en passant pawns
    
    # position would only be indeces
    # so no need for conversion
    # just math
    #valid_moves << position.to_index.
    
    # Where should to index and to notation rules be stored?
    # Maybe in positions themselves? With col and row data?
    
  end
=end
  
  
  
=begin
end


class Rook < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♖" if owner == Chess::WHITE
    @icon = "♜" if owner == Chess::BLACK
    @icon ||= "R"
  end
  
  def valid_moves(position, board)
  end
end


class Knight < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♘" if owner == Chess::WHITE
    @icon = "♞" if owner == Chess::BLACK
    @icon ||= "N"
  end
  
  def valid_moves
  end
end


class Bishop < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♗" if owner == Chess::WHITE
    @icon = "♝" if owner == Chess::BLACK
    @icon ||= "B"
  end
  
  def valid_moves
  end
end


class Queen < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♕" if owner == Chess::WHITE
    @icon = "♛" if owner == Chess::BLACK
    @icon ||= "Q"
  end
  
  def valid_moves
  end
end


class King < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♔" if owner == Chess::WHITE
    @icon = "♚" if owner == Chess::BLACK
    @icon ||= "K"
  end
  
  def valid_moves
  end
end

=end


