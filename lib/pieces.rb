# Pieces

class Piece
  attr_accessor :player, :pos

  def initialize(player)
    @player = player
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
end

class Rook < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Queen < Piece
end

class King < Piece
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


