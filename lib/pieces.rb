class Piece
  attr_reader :player, :pos, :type

  def initialize(player = :none, position = :none)
    @player = player
    @pos = Position.new(position)
    @type = :none
  end
  
  private
  
  #def try_move_to(destination)
  def move_to(destination)
    @pos = destination
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
end
