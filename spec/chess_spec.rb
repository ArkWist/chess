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
  
  describe "Board.new" do
    it "creates an 8 x 8 square array" do
      expect(b.squares.length).to eq(8)
      expect(b.squares[0].length).to eq(8)
    end
  end
  
  describe "Board.set_board" do
    it "puts #{Chess::WHITE} pawns in their starting positions" do
      c.set_board(white, black)
      expect(b.squares[0][1]).to be_instance_of(Pawn)
      expect(b.squares[0][1].owner).to eq(white)
      expect(b.squares[1][1]).to be_instance_of(Pawn)
      expect(b.squares[1][1].owner).to eq(white)
      expect(b.squares[2][1]).to be_instance_of(Pawn)
      expect(b.squares[2][1].owner).to eq(white)
      expect(b.squares[3][1]).to be_instance_of(Pawn)
      expect(b.squares[3][1].owner).to eq(white)
      expect(b.squares[4][1]).to be_instance_of(Pawn)
      expect(b.squares[4][1].owner).to eq(white)
      expect(b.squares[5][1]).to be_instance_of(Pawn)
      expect(b.squares[5][1].owner).to eq(white)
      expect(b.squares[6][1]).to be_instance_of(Pawn)
      expect(b.squares[6][1].owner).to eq(white)
      expect(b.squares[7][1]).to be_instance_of(Pawn)
      expect(b.squares[7][1].owner).to eq(white)
    end
    it "puts #{Chess::WHITE} major pieces in their starting positions" do
      c.set_board(white, black)
      expect(b.squares[1][0]).to be_instance_of(Knight)
      expect(b.squares[1][0].owner).to eq(white)
      expect(b.squares[6][0]).to be_instance_of(Knight)
      expect(b.squares[6][0].owner).to eq(white)
    end
  end
  describe "Board.set_board" do
    it "puts #{Chess::BLACK} pawns in their starting positions" do
      c.set_board(white, black)
      expect(b.squares[0][6]).to be_instance_of(Pawn)
      expect(b.squares[0][6].owner).to eq(black)
      expect(b.squares[7][6]).to be_instance_of(Pawn)
      expect(b.squares[7][6].owner).to eq(black)
    end
    it "puts #{Chess::BLACK} major pieces in their starting positions" do
      c.set_board(white, black)
      expect(b.squares[0][7]).to be_instance_of(Rook)
      expect(b.squares[0][7].owner).to eq(black)
      expect(b.squares[1][7]).to be_instance_of(Knight)
      expect(b.squares[1][7].owner).to eq(black)
      expect(b.squares[2][7]).to be_instance_of(Bishop)
      expect(b.squares[2][7].owner).to eq(black)
      expect(b.squares[3][7]).to be_instance_of(Queen)
      expect(b.squares[3][7].owner).to eq(black)
      expect(b.squares[4][7]).to be_instance_of(King)
      expect(b.squares[4][7].owner).to eq(black)
      expect(b.squares[5][7]).to be_instance_of(Bishop)
      expect(b.squares[5][7].owner).to eq(black)
      expect(b.squares[6][7]).to be_instance_of(Knight)
      expect(b.squares[6][7].owner).to eq(black)
      expect(b.squares[7][7]).to be_instance_of(Rook)
      expect(b.squares[7][7].owner).to eq(black)
    end
  end
  
  describe "Board.ascii_separator" do
    it "writes a horizontal row separating line" do
      expect(b.ascii_separator).to eq("   --- --- --- --- --- --- --- ---   ")
    end
  end
  
  describe "Board.ascii_row" do
    it "writes a horizontal row without pieces" do
      b.set_board(white, black)
      expect(b.ascii_row[5]).to eq("6 |   |   |   |   |   |   |   |   | 6")
    end
  end
  
  describe "Board.ascii_row" do
    it "writes a horizontal row with pieces" do
      b.set_board(white, black)
      expect(b.ascii_row[7]).to eq("8 | ♜ | ♞ | ♝ | ♛ | ♚ | ♝ | ♞ | ♜ | 8")
    end
  end
  
  describe "Board.ascii_col_label" do
    it "writes a horizontal listing of alphabetical column labels" do
      b.set_board(white, black)
      expect(b.ascii_col_label).to eq("    a   b   c   d   e   f   g   h    ")
    end
  end
  
  describe "Board.display" do
    it "draws the board" do
    end
  end
  
  # Converts chess notation back and forth
  
  # How determine check mate
  # Just check every single possible next move?
  
  # Generate list of possible moves (ignore if puts that side in check)
  # For each move, check it doesn't leave the side in check
  # If every move leaves King in check, then mated or stalemated
  # Mate if side to move is in check. Otherwise, stalemate
  
  # Symbols can be handled by Board when printing, ONLY
  
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



