# lib/positions.rb

class Position
  attr_reader :index, :notation
  
  def initialize(pos = :none)
    @index = pos == :none ? pos : to_index(pos)
    @notation = pos == :none ? pos : to_notation(pos)
  end
  
  def set(pos)
    initialize(pos)
  end

  private
  
  def to_index(pos)
    file, rank = split(pos)
    if !file.is_a?(Integer)
      file = ("a".."z").to_a.find_index(file.downcase)
      rank = rank.to_i - 1
    end
    @index = [file, rank]
  end
  
  def to_notation(pos)
    file, rank = split(pos)
    if file.is_a?(Integer)
      file = ("a".."z").to_a.at(file)
      rank += 1
    end
    @notation = "#{file}#{rank}"
  end
  
  def split(pos)
    file, rank = pos[0], pos[1]
  end
end


class Move
  attr_reader :origin, :destination, :positions
  
  def initialize(move)
    @origin = Position.new(get_origin(move))
    @destination = Position.new(get_destination(move))
    @positions = [@origin, @destination]
  end

  def set(move)
    initialize(move)
  end
  
  private
  
  def get_origin(move)
    origin = split(normalize(move))[0]
    origin = split(move)[0]
  end

  def get_destination(move)
    destination = split(normalize(move))[1]
    destination = split(move)[1]
  end
  
  def split(move)
    move = normalize(move)
    origin, destination = move[0..1], move[2..3]
  end
  
  # Mirrored in Chess::is_raw_move? (as a boolean check).
  def normalize(move)
    move.downcase.gsub(/[, ]+/, "")
  end
end


class Square
  attr_reader :player, :type

  def initialize(player = :none, type = :none)
    @player = player
    @type = type
  end
end

# End