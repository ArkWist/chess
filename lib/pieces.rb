class Piece
  attr_accessor :owner, :moved
  
  def initialize(owner)
    @owner = owner
    @moved = false
  end
  
  def valid_move?()
  end
  def valid_moves
  end
end



class Pawn < Piece
  attr_accessor :icon
  
  def initialize(owner)
    super(owner)
    @icon = "♙" if owner == Chess::WHITE
    @icon = "♟" if owner == Chess::BLACK#:Black
    @icon ||= "P"
  end
  
  def valid_moves
  end
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
