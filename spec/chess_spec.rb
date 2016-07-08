# spec/chess_spec.rb
require "chess"

describe Position do
end

describe Move do
end

describe Square do
end

describe Pawn do
end

describe Rook do
end

describe Knight do
end

describe Bishop do
end

describe Queen do
end

describe King do
end

describe Chessboard do
  let(:b) { Chessboard.new }
  
=begin
  describe "Chessboard.do_move" do
    context "Black tries to take a piece" do
      it "moves black's piece and removes the piece it captures" do
        b.do_move(Move.new("b2b4"))
        b.do_move(Move.new("b7b6"))
        b.do_move(Move.new("b4b5"))
        b.do_move(Move.new("a7a5"))
        b.do_move(Move.new("b5a6"))
        b.do_move(Move.new("a8a6"))
      end
    end
  end
=end
  
  describe "Chessboard.checkmate?" do
    context "Black puts White into checkmate" do
      it "confirms a checkmate" do
        b.do_move(Move.new("f2f3"))
        b.do_move(Move.new("e7e5"))
        b.do_move(Move.new("g2g4"))
        b.do_move(Move.new("d8h4"))
        b.print_board
        model = b.make_model
        expect(b.in_check?(:white, model)).to eq(true)
        expect(b.checkmate?(:white, model)).to eq(true)
      end
    end
  end
  
  describe "Chessboard.stalemate?" do
    context "White's pieces are all blocked from moving" do
      it "confirms a stalemate" do
        b.remove_piece(Position.new("a1"))
        b.remove_piece(Position.new("b1"))
        b.remove_piece(Position.new("c1"))
        b.remove_piece(Position.new("d1"))
        b.remove_piece(Position.new("e2"))
        b.remove_piece(Position.new("f1"))
        b.remove_piece(Position.new("f2"))
        b.remove_piece(Position.new("g1"))
        b.remove_piece(Position.new("g2"))
        b.remove_piece(Position.new("h1"))
        b.remove_piece(Position.new("h2"))
        b.do_move(Move.new("e1a8"))
        b.do_move(Move.new("a2a7"))
        b.do_move(Move.new("b2b8"))
        b.do_move(Move.new("c2c8"))
        b.do_move(Move.new("d2b7"))
        model = b.make_model
        expect(b.stalemate?(:white, model)).to eq(true)
      end
    end
  end
  
  describe "Chessboard.fifty_moves?" do
    context "fifty moves taken without a capture or pawn movement" do
      it "confirms this fact" do
        25.times do
          b.do_move(Move.new("b1a3"))
          b.do_move(Move.new("a3b1"))
        end
        model = b.make_model
        expect(b.fifty_moves?).to eq(true)
        b.do_move(Move.new("a2a4"))
        expect(b.fifty_moves?).to eq(false)
      end
    end
  end
  
end

#describe Chess do
#  let(:c) { Chess.new }
#end

