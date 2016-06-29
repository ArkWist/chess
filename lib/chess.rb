class Chess
  PLAYERS = [:white, :black]
  
  
  origin, destination = "g4", "g5"
  
  move_outcome = try_move(origin, destination)
  
  def try_move(origin, desintation)
    #Empty position
    
    # Wrong player
    @board.get_piece(origin).player == @player
  
  
end