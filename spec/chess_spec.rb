# spec/chess_spec.rb
require "chess"

describe Chess do
  c = chess.new; c.start_match
end

#describe Position do
#end

#describe Move do
#end

#describe Square do
#end

#describe Pawn do
#end

#describe Rook do
#end

#describe Knight do
#end

#describe Bishop do
#end

#describe Queen do
#end

#describe King do
#end

describe Chessboard do
  let(:b) { Chessboard.new }

# Move legality checks
# Normal move
# Double-step
# Capture
# En passant
# Castle
# Check
# Checkmate
# Stalemate
# Fifty-move-rule
# Insufficient material
# Quit
# Draw
# Save
# Load

# Chessboard methods
=begin
initialize

print_board

verify_move(player, move)

do_move(move)

promote?(move)

do_promotion(move, type)

in_check?

checkmate?

stalemate?

fifty_moves?

insufficient_material?

threefold_repetition?

make_save_Data

reset_board

load_line(line)

verify_move_legality(player, move)

blocked_move?(player, destination)

illegal_move?(origin, destination)

can_en_passant?(origin, destination, <board>)

is_castle_move?(origin, destination)

can_castle?

is_kingside?(origin, destination)

get_castle_rook_position(origin, destination)

under_attack?(player, pos, board)

under_en_passant_attack?(player, pos, board)

are_safe_moves?(player, moves, origin, board)

get_enemy_captures(player, board)

project_en_passant(move, board)

project_castle(move, board)

model_castle(origin, destination, board)

clean_up_after_special_moves(move)

record_double_step(move)

complete_en_passant(move)

complete_castle(move)

make_type_list

only_kings?(type_list)

only_kings_and_bishops?(type_list)

only_kings_and_knight?

on_same_color?(type)

make_white_pieces

make_black_pieces

make_pieces_at(player, type, *pos)

make_model

make_projection_model

is_unmoved_at?(pos)

list_to_notation(list)

get_piece(pos, board)

get_square(pos, board)

get_piece_index(pos)

remove_piece(pos)

kill_piece(pos)

update_tracking(move)

print_rank(board, rank)

print_files

get_character_for(square)

get_playerized_character(player, index)

load_piece_data(line)
=end

end

describe Chess do
  let(:c) { Chess.new }
  
# Chess methods
=begin
initialize

start_match

next_plaer

play

manage_match

try_turn

try_command(input)

try_save

try_load

try_draw

try_move(input)

complete_move(move)

handle_promote(move)

ask_promote

in_check?

checkmate?

stalemate?

fifty_moves?

insufficient_material?

threefold_repetition?

try_fifty_move_draw

try_insufficient_material_draw

try_threefold_draw

ask_permission(player, &block)

report_rejected_move

report_rejected_slot

handle_game_results(game_results)

ask_file_slot(&block)

get_filename(slot)

slot_exists?(slot)

complete_save(slot)

prepare_load(slot)

complete_load

print_board

is_raw_command?(input)

is_raw_move?(input)

is_raw_position?(pos)
=end

end
  
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
=begin
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
=end
