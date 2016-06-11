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
  
  describe "Position::to_index" do
    it "converts notation to index"
      #expect(Position::to_index("b5")).to eq([1, 4])
      pos = Position.new("b5")
      expect(pos.to_index("b5")).to eq([1, 4])
    end
  end
=begin  
  # Piece manipulation
  
  describe "Board.make_piece" do
    it "creates a Piece on the board" do
      b.make_piece("a1", Pawn.new(white))
      expect(b.get_piece("a1")).to be_instance_of(Pawn)
    end
  end

  describe "Board.remove_piece" do
    it "removes a Piece from the board" do
      b.make_piece("c4", Pawn.new(white))
      b.remove_piece("c4")
      expect(b.get_piece("c4")).to eq(empty)
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
  
  # Piece interpretation
  
  describe "Piece.get_owner" do
    it "says who owns a Piece" do
      pos = "f5"
      b.make_piece(pos, Pawn.new(black))
      piece = b.get_piece(pos)
      expect(piece.get_owner).to eq(black)
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
  
  ######### Pawn should know where it is??? ###########
  ######### Should know so don't have to pass it all the time ####
  
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
      expect(piece.promote?(pos)).to eq(true)
    end
  end
  
  # En passant capture // just through normal move mechanics and a special check
  
  # Check // Would Be Check // Hold King reference specially
  
  describe "King.under_attack?" do
    it "checks if a player is in Check" do
      b.remove_piece("e1")
      pos = "e6"
      b.make_piece(pos, King.new(white))
      king = b.get_piece(pos)
      expect(king.under_attack?(b)).to eq(true)
    end
  end
  
  # Castling // Should have a variable for if castling could be legal
  
  describe "Board.can_castle?" do
    it "checks if the King and Rook have ever moved" do
      start, target = "e1", "a1"
      b.left_castle # column is a
      b.right_castle # column is h
    end
    it "checks if something is in the way of the King and Rook" do
      # checks necessary squares are :empty
    end
    it "checks if any relevant intermediary square is in Check" do
      # does under_attack? on necessary squares
    end
  end
  
  # Checkmate // This is just Check if in Check, with all possible moves
=end
end
