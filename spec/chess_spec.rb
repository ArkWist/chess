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
      expect(b.squares[7][1]).to be_instance_of(Pawn)
      expect(b.squares[7][1].owner).to eq(white)
    end
    it "puts #{Chess::WHITE} major pieces in their starting positions" do
      c.set_board(white, black)
      expect(b.squares[0][0]).to be_instance_of(Rook)
      expect(b.squares[0][0].owner).to eq(white)
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
      expect(b.squares[1][7]).to be_instance_of(Knight)
      expect(b.squares[1][7].owner).to eq(black)
      expect(b.squares[5][7]).to be_instance_of(Bishop)
      expect(b.squares[5][7].owner).to eq(black)
    end
  end
  
  
  describe "Pawn.icon" do
    it "gets the owner-colored symbol for a Pawns" do
      c.set_board(white, black)
      expect(b.squares[0][1].icon).to eq("♙")
      expect(b.squares[0][6].icon).to eq("♟")
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
  describe "Board.ascii_col_labels" do
    it "writes a horizontal listing of alphabetical column labels" do
      b.set_board(white, black)
      expect(b.ascii_col_label).to eq("    a   b   c   d   e   f   g   h    ")
    end
  end


  describe "Board.row_to_notation" do
    it "converts a row array index to notation" do
      expect(b.row_to_notation(3)).to eq(4)
    end
  end
  describe "Board.row_to_index" do
    it "converts row notation to an array index" do
      expect(b.row_to_notation(3)).to eq(2)
    end
  end
  describe "Board.col_to_notation" do
    it "converts a column array index to notation" do
      expect(b.col_to_notation(6)).to eq("g")
    end
  end
  describe "Board.col_to_index" do
    it "converts column notation to an array index" do
      expect(b.col_to_index("e")).to eq(4)
    end
  end
  describe "Board.to_notation" do
    it "converts a square array index to notation" do
      expect(b.to_notation([2, 3])).to eq("c4")
    end
  end
  describe "Board.to_index" do
    it "converts Chess notation to array indices" do
      expect(b.to_index("h7")).to eq([7, 6])
    end
  end
  
  
  describe "Pawn.valid_moves(position)" do
    it "says one position forward is a valid move" do
    end
    it "says one taken position forward isn't a valid move" do
    end
    it "says two positions forward is a valid first move" do
    end
    it "says two positions forward isn't a valid move post-first move" do
    end
    it "says one enemy taken position diagonally is a valid attack" do
    end
    it "recognizes en passant as a valid attack" do
    end
  end
  
  
  

  

  # How determine check mate
  # Just check every single possible next move?
  
  # isInCheck [is King's underAttack?] // isUnderAttack
  # underAttackBy(given)
  # underAttack
  # canAttack(given)
  
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

