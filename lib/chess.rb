=begin


8  [r][n][b][k][q][b][n][r]
7  [p][p][p][p][p][p][p][p]
6  [ ][ ][ ][ ][ ][ ][ ][ ]
5  [ ][ ][ ][ ][ ][ ][ ][ ]
4  [ ][ ][ ][ ][ ][ ][ ][ ]
3  [ ][ ][ ][ ][ ][ ][ ][ ]
2  [P][P][P][P][P][P][P][P]
1  [R][N][B][K][Q][B][N][R]

    A  B  C  D  E  F  G  H

@en_passant
@moved[] << pos if rook or king
or have unmoved, and delete when start and target from it, probably better

=end


class Chess
  PLAYERS = [:white, :black]
  
  
  origin, destination = "g4", "g5"
  
  move_outcome = try_move(origin, destination)
  
  def try_move(origin, desintation)
    #Empty position
    
    # Wrong player
    @board.get_piece(origin).player == @player
  
  
end