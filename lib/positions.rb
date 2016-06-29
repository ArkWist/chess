
class Square
  attr_reader :player, :type

  def initialize(player = :none, type = :none)
    @player = player
    @type = type
  end
end


class Move
  attr_reader :origin, :destination
  
  def initialize(move)
    @origin = Position.new(get_origin(move))
    @destination = Position.new(get_destination(move))
  end
  
  def set(move)
    initialize(move)
  end
  
  private
  
  def get_origin(move)
    origin = split(normalize(move))[0]
  end

  def get_destination(move)
    destination = split(normalize(move))[1]
  end
  
  def split(move)
    move = normalize(move)
    origin, destination = move[0..1], move[2..3]
  end
  
  def normalize(move)
    move = move.delete(/ ,/)
  end
end
  

class Position
  attr_reader :index, :notation
  
  def initialize(pos)
    @index = to_index(pos)
    @notation = to_notation(pos)
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