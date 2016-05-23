

class Move
end
#class Position
#end


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




