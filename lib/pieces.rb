# Pieces

class Piece
  attr_accessor :player, :icon, :pos

  def initialize(player, icons)
    @player = player
    @icon = icons[0] if player == Chess::WHITE
    @icon = icons[1] if player == Chess::BLACK
    @icon ||= "*"
  end
  
  def set_pos(pos)
    @pos = pos
  end
  
  def get_pos
    @pos
  end
  
  def get_owner
    @player
  end
  
end


class Pawn < Piece
  ICONS = ["P", "p"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
  def get_moves(board)
    col, row = @pos.to_index
    moves = []
    move = Position.new([row + 1, col]) if @player == Chess::WHITE
    move = Position.new([row - 1, col]) if @player == Chess::BLACK
    if board.valid_indices?(move.pos) && board.get_piece(move.to_notation) == Chess::EMPTY
      moves << move.to_notation
    end
    moves
  end
  
  def get_double_step(board)
    col, row = @pos.to_index
    moves = []
    move = Position.new([row + 2, col]) if @player == Chess::WHITE
    move = Position.new([row - 2, col]) if @player == Chess::BLACK
    if board.valid_indices?(move.pos) #&& board.get_piece()
    
    ## NEED a way to check empty until a certain square
    #if board.empty_up_to?(@pos, :n, 2) == true
    
    #if @player == Chess::WHITE && row == 1
    
    end
  end
  
  def get_captures(board)
    col, row = @pos.to_index
  end
  
  def get_en_passant_captures(board)
    col, row = @pos.to_index
  end
  
end

class Rook < Piece
  ICONS = ["R", "r"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
end

class Knight < Piece
  ICONS = ["N", "n"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
end

class Bishop < Piece
  ICONS = ["B", "b"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
end

class Queen < Piece
  ICONS = ["Q", "q"]
  
  def initialize(player)
    super(player, ICONS)
  end
  
end

class King < Piece
  ICONS = ["K", "k"]
  
  def initialize(player)
    super(player, ICONS)
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


