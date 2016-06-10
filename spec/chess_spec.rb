# spec/chess_spec.rb
require "chess"

describe Chess do
  let(:c) { Chess.new }
  let(:b) { c.board }
  let(:s) { c.board.squares }
  let(:p) { c.player }
  let(:white) { Chess::WHITE }
  let(:black) { Chess::BLACK }
  let(:empty) { Chess::EMPTY }

  # Chess creation
  
  describe "Chess.new" do
    it "sets player to #{Chess::WHITE}" do
      expect(p).to eq(white)
    end
    it "creates a new game board" do
      expect(c.board).to be_instance_of(Board)
    end
  end

  # Board creation
  
  describe "Board.new" do
    it "creates an 8 x 8 array of squares" do
      expect(s.length).to eq(8)
      expect(s[0].length).to eq(8)
    end
  end
  
  # Board notation
  
  describe "Position.new" do
    it "converts notation to index"
      expect(Position::to_index("b5")).to eq([1, 4])
    end
  end
  
  # Piece manipulation
  
  describe "Board.make_piece" do
    it "creates a Piece on the board" do
      b.make_piece("a1", Pawn.new(white))
      expect(b.get_piece("a1")).to be_instance_of(Pawn)
    end
  end
  
  describe "Board.kill_piece" do
    it "removes a Piece from the board" do
      b.make_piece("c4", Pawn.new(white))
      b.kill_piece("c4")
      expect(b.get_piece("c4")).to eq(empty)
    end
  end
  
  describe "Board.move_piece"
    it "moves a Piece from one square to another" do
      b.make_piece("c4", Pawn.new(white))
      b.move_piece("c4", "c5")
      expect(b.get_piece("c5")).to be_instance_of(pawn)
    end
  end
  
  # Board setup
  
  describe "Board.set_board" do
    it "puts #{Chess::WHITE} Pawns in their starting positions" do
      b.set_board
      expect(b.get_piece("e2")).to be_instance_of(Pawn)
    end
    it "puts #{Chess::WHITE} Pieces in their starting positions" do
      b.set_board
      expect(b.get_piece("b1")).to be_instance_of(Knight)
    end
    it "puts #{Chess::BLACK} Pieces in their starting positions" do
      b.set_board
      expect(b.get_piece("c8")).to be_instance_of(Bishop)
    end
  end
  
  # Player switching
  
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
  
  # Position validation
  
  describe "Position::valid?" do
    it "validates a legal position" do
      expect(Position::valid?("a3")).to eq(true)
    end
    it "invalidates illegal positions" do
      expect(Position::valid?("p3")).to eq(false)
    end
    it "invalidates nonconforming positions" do
      expect(Position::valid?("a3g")).to eq(false)
    end
  end
  
  # Move interpretation

  describe "Move::valid?" do
    it "validates A#A# formatting" do
      expect(Move::valid?("e4g5")).to eq(true)
    end
    it "validates A# A# formatting" do
      expect(Move::valid?("e4 g5")).to eq(true)
    end
    it "validates A#,A# formatting" do
      expect(Move::valid?("e4,g5")).to eq(true)
      expect(Move::valid?("e4, g5")).to eq(true)
    end
  end
  
  describe "Move::normalize" do
    it "converts moves to a standard format" do
      expect(Move::normalize("e4, g4")).to eq("e4g4")
    end
  end
  
  # Move decompilation
  
  describe "Move::get_start" do
    it "gets a move's start position" d
      expect(Move::get_start("e4g5")).to eq("e4")
    end
  end
  describe "Move::get_target" do
    it "gets a move's end position" do
      expect(Move::get_target("e4g5")).to eq("g5")
    end
  end
  
  # Piece representation
  
  describe "Piece.symbol" do
    it "gets the symbol for #{Chess::WHITE} Pawns" do
      expect(b.get_piece("a2").icon).to eq("P")
    end
    it "gets the symbol for #{Chess::BLACK} Knights" do
      expect(b.get_piece("b8").icon).to eq("k")
    end
  end
  
  # Board representation
  
  describe "Board.ascii_separator" do
    it "writes a horizontal row separating line" do
      expect(b.ascii_separator).to eq("   --- --- --- --- --- --- --- ---   ")
    end
  end
  describe "Board.ascii_row" do
    it "writes a horizontal row without pieces" do
      expect(b.ascii_row(5)).to eq("5 |   |   |   |   |   |   |   |   | 5")
    end
    it "writes a horizontal row with a piece" do
      b.make_piece("d4", Pawn.new(white))
      expect(b.ascii_row(4)).to eq("4 |   |   |   | P |   |   |   |   | 4")
    end
    it "writes a horizontal row with pieces" do
      expect(b.ascii_row(8)).to eq("8 | r | n | b | k | q | b | n | r | 8")
    end
  end
  describe "Board.ascii_col_labels" do
    it "writes a horizontal listing of alphabetical column labels" do
      expect(b.ascii_col_labels).to eq("    a   b   c   d   e   f   g   h    ")
    end
  end
  
  ######### Pawn should know where it is ###########
  
  # Pawn move checking
  
  describe "Pawn.get_moves" do
    it "puts one move forward in the move list" do
      start, target = "d3", "d4"
      b.make_piece(start, Pawn.new(white))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(true)
    end
    it "doesn't put blocked moves in the move list" do
      start, target = "d3", "d4"
      b.make_piece(start, Pawn.new(white))
      b.make_piece(target, Pawn.new(black))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(false)
    end
  end
    
  # Pawn capture checking
  
  describe "Pawn.get_captures" do
    it "puts diagonal attacks in the attack list" do
      start, target = "d3", "e4"
      b.make_piece(start, Pawn.new(white))
      b.make_piece(target, Pawn.new(black))
      piece = b.get_piece(start)
      moves = piece.get_captures(start)
      expect(moves.include?(target)).to eq(true)
    end
  end
  
  # Pawn two square move checking
  
  describe "Pawn.get_double_step_move" do
    context "Pawn is on its second rank" do
      it "checks if a two step move is valid" do
        start, target = "d2", "d4"
        b.make_piece(start, Pawn.new(white))
        piece = b.get_piece(start)
        move = piece.get_double_step_move(start)
        expect(move.include?(target)).to eq(true)
      end
    end
  end
  
  ###### If en passant capture matches candidate for target #########
  ###### So this is called from Board, not from Pawn get_moves
  ###### Board would check captures, then check moves, then compare to special
  
  # Pawn en passant capture checking
  
  describe "Pawn.get_en_passant_capture" do
    context "Pawn is on its fifth rank" do
      it "checks if en passant capture is possible" do
        start, target, e_p = "b5", "c6", "c5"
        b.make_piece(start, Pawn.new(white))
        piece = b.get_piece(start)
        move = piece.get_en_passant_capture(target)
        expect(move.include?(e_p)).to eq(true)
      end
    end
  end

  ####### Handled as a special case by Board after moving if Pawn #######
  
  # Pawn promotion checking
  
  describe "Pawn.promote?" do
    it "checks if Pawn is eligible for promotion" do
      pos = "e8"
      b.make_piece(pos, Pawn.new(white))
      piece = b.get_piece(pos)
      expect(piece.promote?).to eq(true)
    end
  end

  # Piece capture
  
  
  # Piece removal
  
  
  # Piece movement
  
  
  
  # En passant capture
  
  
  # Castling
  
  
  # Pawn promotion
  
  # Board square information
  # b.get_square
  # b.get_owner
  # b.get_type
  # b.get_icon
  
end


  # Really need an easier way to reference notation
  # Should always pass notation as a letter and a number
  
=begin
  Put in "e4g5"
  Says start is "e4"
  Says target is "g5" >> target = Position.new(move.target) (so is Position)
  Checks ownership of Position >> Board.checkPiece
  Checks moves for Position >> Board.piece
  Sees if movelist includes Position (all done in index)
  
  "e4" and "g5" are strings as that's easier to deal with
  Positions are with indexes
=end
  
  # Pass Positions back and forth? -------------
  
  # Move = gets.chomp
  # Check formatting (letter, number, letter, number)
  # >> Comment that it isn't flexible but could be with (letters, numbers...)
  # Start = Move.start
  # Target = Move.target
  # Convert both to index
  # Check if they are valid
  
  # Board interpretation procedures
  

=begin
# Change to symbols and upper/lower for white/black
Makes Chess
Makes Board
Makes Player white
Makes Player black
Can change player
Sets Board dimensions
Puts Pieces on Board
Can write Separators
Can write Pieces
Can write blank squares
Can write column labels
Convert Notation to Index
Convert Index to Notation
-- row, column, both, or x 2 (move) [just do the math, regardless of validity]
Movement;
# How to see moves, vs attack moves, vs special moves?
validate both positions, then--
ask: valid_move? (must pass board so can see pieces in the way)
ask: valid_attack? (often the same as valid_move?)
-- then check special? en passant, castle, etc
-- check if promotion
-- check if put king in check
=end


=begin

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


=end
  
