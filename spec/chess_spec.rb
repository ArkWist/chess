# spec/chess_spec.rb

require "chess"



describe Chess do
  let(:c) { Chess.new }
  let(:b) { c.board }
  let(:white) { Chess::WHITE }
  let(:black) { Chess::BLACK }

  describe "Chess.new" do
    it "sets player to #{Chess::WHITE}" do
      expect(c.player).to eq(white)
    end
    it "creates a new game board" do
      expect(c.board).to be_instance_of(Board)
    end
  end
  
  describe "Chess.next_player" do
    it "changes from #{Chess::WHITE} player to #{Chess::BLACK} player" do
      c.next_player
      expect(c.player).to eq(black)
    end
    it "changes from #{Chess::BLACK} player to #{Chess::WHITE} player" do
      2.times { c.next_player }
      expect(c.player).to eq(white)
    end
  end
  
  
  
  # Board has cells with pieces in them.
  # Easily see if piece in a spot, and who owns it, when moving.
  # And see if it's a King
  
  # Ought to convert chess notation to array indexes
  
  describe "Pawn.valid_move?" do
    # first move
    # non-first move
    # piece in way
    # attackable enemy
    # ally in that spot
    # top of board?
  end
  
end

# class Chess
# class Board
# class Piece
# -- Pawn
#      Owner
#      Rules
#      > Has moved? (Pawn, Rook, King)
# -- Rook
# -- Knight
# -- Bishop
# -- Queen
# -- King





# Match
# Board --positions
# ~Players
# Pieces
  # Owner
  # Type --rules
  # Special Data (pawn first move?)
# Make board

## check_mate check would check beginning of the turn, if there are any legal moves which allow escape from check? So if check, then checks?




