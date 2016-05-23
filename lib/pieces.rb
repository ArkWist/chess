# Piece ought to be a module
# Undefined Pieces serve no use
# Store moves in Move to facilitate passing move data around
# Perhaps Pieces ought to know their location though
# So that they can report legal moves?
# Actually, that should be the board's responsibility
# -- to sort out legal and illegal moves
# En passant stored separately by Board

=begin
class Piece
  attr_accessor :owner, :moved
  
  def initialize(owner)
    @owner = owner
    @moved = false
  end
  
  def valid_move?()
  end
end
=end


class Move
end
#class Position
#end


module Piece
  attr_accessor :owner, :moved, :position
  
  def initialize(owner, position)
    @owner = owner
    @moved = false
    @position = position
  end
  
  def valid_move?()
  end
  
end


class Pawn# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner, position)
    super(owner, position)
    @icon = "♙" if owner == Chess::WHITE
    @icon = "♟" if owner == Chess::BLACK
    @icon ||= "P"
  end
  
  def possible_moves(@position)
    moves = nil
    moves << #one ahead
             [@position.first, @position.last + 1]
    moves << [@position.first, @position.last + 2] if !@moved
    
    #But how does it know attack moves?
    #How to relay this information between Pawn and Board?
    #Pawn must be able to see Board
    #And Pawn must be able to decide what is valid
    
    #Piece needs to be told what the board looks like
    #Piece needs to be told about en passant pawns
    
    # position would only be indeces
    # so no need for conversion
    # just math
    #moves << position.to_index.
    
    # Where should to index and to notation rules be stored?
    # Maybe in positions themselves? With col and row data?
    
  end
end


class Rook# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♖" if owner == Chess::WHITE
    @icon = "♜" if owner == Chess::BLACK
    @icon ||= "R"
  end
  
  def moves
  end
end


class Knight# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♘" if owner == Chess::WHITE
    @icon = "♞" if owner == Chess::BLACK
    @icon ||= "N"
  end
  
  def moves
  end
end


class Bishop# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♗" if owner == Chess::WHITE
    @icon = "♝" if owner == Chess::BLACK
    @icon ||= "B"
  end
  
  def moves
  end
end


class Queen# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♕" if owner == Chess::WHITE
    @icon = "♛" if owner == Chess::BLACK
    @icon ||= "Q"
  end
  
  def moves
  end
end


class King# < Piece
  include Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♔" if owner == Chess::WHITE
    @icon = "♚" if owner == Chess::BLACK
    @icon ||= "K"
  end
  
  def moves
  end
end




