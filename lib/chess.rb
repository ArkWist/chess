# Chess

class Chess
  PLAYERS = [:White, :Black]
  attr_reader :board, :player

  def initialize
    @board = Board.new
    @player = PLAYERS.first
    #play
  end

  def next_player
    @player == PLAYERS.first ? @player = PLAYERS.last : @player = PLAYERS.first
  end

  def play
    @board.display
    player_turn(@player)
  end

  def player_turn
    next_player unless @board.empty?
    move
    @board.display
    player_turn unless check_mate?
  end


# Replay should be outside of Chess class
# So no need for reset?
