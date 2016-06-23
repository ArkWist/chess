# spec/chess_spec.rb
require "chess"

describe Chess do
  let(:c) { Chess.new }
  let(:b) { c.board }
  #let(:s) { c.board.squares }
  let(:p) { c.player }
  let(:white) { Chess::WHITE }
  let(:black) { Chess::BLACK }
  let(:empty) { Chess::EMPTY }
  let(:nopos) { Chess::NO_POS }

  # Chess creation
  
  describe "Chess.new" do
    it "sets player to #{Chess::EMPTY}" do
      expect(p).to eq(empty)
    end
    it "creates a new game board" do
      expect(c.board).to be_instance_of(Board)
    end
  end

  # Board creation
  
  # Squares no longer need to public
  #describe "Board.new" do
  #  it "creates an 8 x 8 array of squares" do
  #    expect(s.length).to eq(8)
  #    expect(s[0].length).to eq(8)
  #  end
  #end

  # Board notation
  ######## Should create Positions before translating them ###########
  describe "Position.to_index" do
    it "converts stored position notation to array index" do
      pos = Position.new("b5")
      expect(pos.to_index).to eq([1, 4])
    end
  end
 
  # Piece manipulation
  
  describe "Board.place_piece" do
    it "creates a piece on the board" do
      b.place_piece("a1", Pawn.new(white))
      piece = b.get_piece("a1")
      expect(piece).to be_instance_of(Pawn)
      expect(piece.pos.pos).to eq("a1")
    end
  end

  describe "Board.remove_piece" do
    it "removes a Piece from the board" do
      b.place_piece("c4", Pawn.new(white))
      b.remove_piece("c4")
      expect(b.get_piece("c4")).to eq(empty)
    end
  end

  describe "Board.kill_piece" do
    it "removes a Piece from the board" do
      b.place_piece("c4", Pawn.new(white))
      b.kill_piece("c4")
      expect(b.get_piece("c4")).to eq(empty)
    end
  end

  describe "Board.move_piece" do
    it "moves a Piece from one square to another" do
      b.place_piece("c4", Pawn.new(white))
      b.move_piece("c4", "c5")
      expect(b.get_piece("c5")).to be_instance_of(Pawn)
    end
  end

  # Piece interpretation
  describe "Piece.player" do
    it "says who owns a Piece" do
      pos = "f5"
      b.place_piece(pos, Pawn.new(black))
      piece = b.get_piece(pos)
      expect(piece.player).to eq(black)
    end
  end
  
  # Board setup
  
  describe "Board.set_board" do
    it "puts #{Chess::WHITE} Pawns in their starting positions" do
      b.set_board(white, black)
      expect(b.get_piece("e2")).to be_instance_of(Pawn)
    end
    it "puts #{Chess::WHITE} pieces in their starting positions" do
      b.set_board(white, black)
      expect(b.get_piece("b1")).to be_instance_of(Knight)
    end
    it "puts #{Chess::BLACK} pieces in their starting positions" do
      b.set_board(white, black)
      expect(b.get_piece("c8")).to be_instance_of(Bishop)
    end
  end

  # Player switching
  
  describe "Chess.next_player" do
    it "changes from #{Chess::WHITE} player to #{Chess::BLACK} player" do
      c.next_player
      c.next_player
      expect(c.player).to eq(black)
    end
    it "changes from #{Chess::BLACK} player to #{Chess::WHITE} player" do
      3.times { c.next_player }
      expect(c.player).to eq(white)
    end
  end

  # Position validation
  
  describe "Board.valid_position?" do
    it "validates a legal position" do
      expect(b.valid_position?("a3")).to eq(true)
    end
    it "invalidates illegal positions" do
      expect(b.valid_position?("p3")).to eq(false)
    end
    it "invalidates nonconforming positions" do
      expect(b.valid_position?("a3g")).to eq(false)
    end
  end

  # Move interpretation

  describe "Board.normalize_move" do
    it "converts moves to a standard format" do
      expect(b.normalize_move("e4, g4")).to eq("e4g4")
    end
  end
  
  describe "Board.valid_move?" do
    it "validates A#A# formatting" do
      expect(b.valid_move?("e4g5")).to eq(true)
    end
    it "validates A# A# formatting" do
      expect(b.valid_move?("e4 g5")).to eq(true)
    end
    it "validates A#,A# formatting" do
      expect(b.valid_move?("e4,g5")).to eq(true)
      expect(b.valid_move?("e4, g5")).to eq(true)
    end
  end

  # Move decompilation
  
  describe "Board.get_move_start" do
    it "gets a move's start position" do
      expect(b.get_move_start("e4g5")).to eq("e4")
    end
  end
  describe "Board.get_move_target" do
    it "gets a move's end position" do
      expect(b.get_move_target("e4g5")).to eq("g5")
    end
  end

  # Piece representation
  
  describe "Piece.symbol" do
    it "gets the symbol for #{Chess::WHITE} Pawns" do
      expect(b.get_piece("a2").icon).to eq("P")
    end
    it "gets the symbol for #{Chess::BLACK} Knights" do
      expect(b.get_piece("b8").icon).to eq("n")
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
      b.place_piece("d4", Pawn.new(white))
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

  # Pawn move checking
  
  describe "Pawn.get_moves" do
    it "puts one move forward in the move list" do
      start, target = "d3", "d4"
      b.place_piece(start, Pawn.new(white))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(true)
    end
    it "doesn't put blocked moves in the move list" do
      start, target = "d3", "d4"
      b.place_piece(start, Pawn.new(white))
      b.place_piece(target, Pawn.new(black))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(false)
    end
  end

  # Pawn two square move checking
  
  describe "Pawn.get_double_step" do
    context "Pawn is on its second rank" do
      it "checks if a two step move is valid" do
        start, target = "d2", "d4"
        b.place_piece(start, Pawn.new(white))
        piece = b.get_piece(start)
        move = piece.get_double_step(b)
        expect(move.include?(target)).to eq(true)
      end
    end
  end

  # Pawn capture checking
  
  describe "Pawn.get_captures" do
    it "puts diagonal attacks in the attack list" do
      start, target = "d3", "e4"
      b.place_piece(start, Pawn.new(white))
      b.place_piece(target, Pawn.new(black))
      piece = b.get_piece(start)
      moves = piece.get_captures(b)
      expect(moves.include?(target)).to eq(true)
    end
  end

  # Pawn en passant capture checking
  
  describe "Pawn.get_en_passant_capture" do
    context "Pawn is on its fifth rank" do
      it "checks if en passant capture is possible" do
        start, target, e_p = "b5", "c6", "c5"
        b.place_piece(start, Pawn.new(white))
        piece = b.get_piece(start)
        b.reset_en_passant(e_p)
        move = piece.get_en_passant_capture(b)
        expect(move.include?(target)).to eq(true)
      end
    end
  end
  
  # Pawn move
  
  describe "Board.move" do
    context "Standard pawn movement" do
      it "moves the pawn to the given empty location" do
        start, target = "c3", "c4"
        move = "#{start}#{target}"
        b.place_piece(start, Pawn.new(white))
        b.move_piece(move)
        expect(b.get_piece(start)).to eq(empty)
        expect(b.get_piece(target)).to be_instance_of(Pawn)
      end
    end
    context "Double step movement" do
      it "sets en passant when making a move" do
        start, target = "b2", "b4"
        move = "#{start}#{target}"
        b.place_piece(start, Pawn.new(white))
        #b.move_piece(move)
        #expect(b.get_piece(start)).to eq(empty)
        #expect(b.get_piece(target)).to be_instance_of(Pawn)
      end
    end
  end
  
  # Pawn movement through Chess turn
  
  describe "Chess.do_move" do
    it "takes a move and executes it" do
      start, target = "b2", "b4"
      c.next_player
      c.do_move(b.get_piece(start), start, target)
      expect(b.get_piece(start)).to eq(empty)
      piece = b.get_piece(target)
      expect(piece).to be_instance_of(Pawn)
      expect(piece.read_pos).to eq(target)
    end
    it "rejects a move from a blank space" do
      start, target = "b3", "b4"
      c.next_player
      c.do_move(b.get_piece(start), start, target)
      expect(b.get_piece(start)).to eq(empty)
      expect(b.get_piece(target)).to eq(empty)
    end
  end
  
  describe "Chess.do_move" do
    it "takes a move and executes it" do
      start, target = "b2", "b4"
      c.next_player
      c.do_move(b.get_piece(start), start, target)
      expect(b.get_piece(start)).to eq(empty)
      piece = b.get_piece(target)
      expect(piece).to be_instance_of(Pawn)
      expect(piece.read_pos).to eq(target)
    end
  end
  
  # Pawn promotion
  
  describe "Board.get_promoted_piece" do
    it "Makes an asked for piece" do
      piece = b.get_promoted_piece(white, "q")
      expect(piece).to be_instance_of(Queen)
    end
  end
  
  # Rook move checking
  
  describe "Rook.get_moves" do
    it "puts multiple moves in the move list" do
      start, target, another = "d3", "d6", "g3"
      b.place_piece(start, Rook.new(white))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(true)
      expect(moves.include?(another)).to eq(true)
    end
    it "doesn't put blocked moves in the move list" do
      start, target = "d3", "d6"
      b.place_piece(start, Rook.new(white))
      b.place_piece(target, Pawn.new(black))
      piece = b.get_piece(start)
      moves = piece.get_moves(b)
      expect(moves.include?(target)).to eq(false)
    end
  end
  
  # Rook capture checking
  
  # Rook castle checking
  
  
  
    
=begin
  ####### Handled as a special case by Board after moving if Pawn #######
  
  # Pawn promotion checking
  
  describe "Pawn.promote?" do
    it "checks if Pawn is eligible for promotion" do
      pos = "e8"
      b.place_piece(pos, Pawn.new(white))
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
      b.place_piece(pos, King.new(white))
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
