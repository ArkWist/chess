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
      b.make_piece("a1", Pawn.new)
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
  #####################

  describe "Move.valid?" do
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
  
  # Move interpretation
  
  describe "Move.start" do
    it "gets a move's start position" do
      move = Move.new("e4, g5")
      expect(move.start).to eq("e4")
    end
  end
  describe "Move.target" do
    it "gets a move's end position" do
      move = Move.new("e4, g5")
      expect(move.target).to eq("g5")
    end
  end
  
  # Notation translation
  
  describe "Position::row_to_notation" do
    it "converts a row array index to notation" do
      expect(Position::row_to_notation(3)).to eq("4")
    end
  end
  describe "Position::row_to_index" do
    it "converts row notation to an array index" do
      expect(Position::row_to_index(3)).to eq(2)
    end
  end
  describe "Position::col_to_notation" do
    it "converts a column array index to notation" do
      expect(Position::col_to_notation(6)).to eq("g")
    end
  end
  describe "Position::col_to_index" do
    it "converts column notation to an array index" do
      expect(Position::col_to_index("e")).to eq(4)
    end
  end
  describe "Position::to_notation" do
    it "converts a square array index to notation" do
      expect(Position::to_notation([2, 3])).to eq("c4")
    end
  end
  describe "Position::to_index" do
    it "converts Chess notation to array indices" do
      expect(Position::to_index("h7")).to eq([7, 6])
    end
  end
  
  describe "Position.new" do
    it "creates an index position from notation input" do
      pos = Position.new("e4")
      expect(pos.col).to eq(4)
      expect(pos.row).to eq(3)
      expect(pos.index).to eq([4, 3])
    end
  end
  
  # Piece representation
  
  describe "Pawn.icon" do
    it "gets the symbol for #{Chess::WHITE} Pawns" do
      expect(b.squares[0][1].icon).to eq("P")
    end
    it "gets the symbol for #{Chess::BLACK} Pawns" do
      expect(b.squares[0][6].icon).to eq("p")
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
      expect(b.ascii_row(5)).to eq("6 |   |   |   |   |   |   |   |   | 6")
    end
  end
  describe "Board.ascii_row" do
    it "writes a horizontal row with a piece" do
      b.squares[3][3] = Pawn.new(white)
      expect(b.ascii_row(3)).to eq("4 |   |   |   | P |   |   |   |   | 4")
    end
    it "writes a horizontal row with pieces" do
      expect(b.ascii_row(7)).to eq("8 | r | n | b | k | q | b | n | r | 8")
      puts b.ascii_separator
      puts b.ascii_row(7)
      puts b.ascii_col_labels
    end
  end
  describe "Board.ascii_col_labels" do
    it "writes a horizontal listing of alphabetical column labels" do
      expect(b.ascii_col_labels).to eq("    a   b   c   d   e   f   g   h    ")
    end
  end
  
  # Pawn move checking
  
  describe "Pawn.valid_moves(position)" do
    it "says one position forward is a valid move" do
      start = Position.new("d3")
      target = Position.new("d4")
      pawn = Pawn.new(white)
      valid_moves = pawn.valid_moves(b, start)  # Pawn must take board and position
      expect(valid_moves.include?(target)).to eq(true)
    end
    it "says two positions forward is a valid first move" do
      start = Position.new("d2")
      target = Position.new("d4")
      pawn = Pawn.new(white)
      valid_moves = pawn.valid_moves(b, start)
      expect(valid_moves.include?(target)).to eq(true)
    end
    it "says taken positions aren't valid moves" do
      start = Position.new("d3")
      target = Position.new("d4")
      pawn = Pawn.new(white)
      col, row = Position::to_index(target)
      b.squares[col, row] = Pawn.new(black)
      valid_moves = pawn.valid_moves(b, start)
      expect(valid_moves.include?(target)).to eq(false)
    end
  end
  
  # Pawn attack checking
  
  describe "Pawn.valid_attacks(position)" do
    it "says diagonal enemies can be attacked" do
      start = Position.new("f4")
      target = Position.new("g5")
      pawn = Pawn.new(white)
      col, row = Position::to_index(target)
      b.squares[col, row] = Pawn.new(black)
      valid_attacks = pawn.valid_attacks(b, start)
      expect(valid_attacks.include?(target)).to eq(true)
    end
  end
  describe "Pawn.valid_specials(position)" do
    it "recognizes en passant attacks" do
      start = Position.new("f5")
      target = Position.new("e6")
      pawn = Pawn.new(white)
      col, row = Position::to_index(target)
      b.squares[col, row - 1] = Pawn.new(black)
      valid_specials = pawn.valid_specials(b, start)
      expect(special_attacks.include?(target)).to eq(true)
    end
  end
  
  # Pawn movement
  
  describe "Board.move(move)" do
    it "moves a Pawn if the move command is valid" do
      start = Position.new("c4")
      target = Position.new("c5")
      pawn = Pawn.new(white)
      b.move(start, target)
      expect(b.squares[2][3]).to eq(empty)
      expect(b.squares[2][4]).to be_instance_of(Pawn)
    end
  end
  
  # Pawn attack
  
  describe "Board.move(attack move)" do
    it "attacks with a Pawn if legal" do
      start = Position.new("c4")
      target = Position.new("b5")
      pawn = Pawn.new(white)
      col, row = Position::to_index(target)
      b.squares[col, row] = Knight.new(black)
      b.move(start, target)
      expect(b.squares[2][4]).to be_instance_of(Pawn)
    end
  end
  
  # Pawn en passant
  
  describe "Board.special(en passant move)" do
    it "completes en passant moves" do
      start = Position.new("c5")
      target = Position.new("b6")
      pawn = Pawn.new(white)
      col, row = Position::to_index(target)
      b.squares[col, row - 1] = Pawn.new(black)
      b.set_en_passant = Position.new("b6")
      b.en_passant_move(start, target)
      expect(b.squares[1][5]).to eq(pawn)
      expect(b.squares[2][4]).to eq(empty)
    end
  end
  
  # Pawn promotion
  
  # Board square information
  # b.get_square
  # b.get_owner
  # b.get_type
  # b.get_icon
  
  
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
  
end

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
  
  
  
  
