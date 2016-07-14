# lib/savedata.rb

module SaveDataReader

  def SaveDataReader.read_variable(line)
    line.split("=").at(0)
  end
  
  def SaveDataReader.read_value(line)
    line.split("=").at(1)
  end
  
  def SaveDataReader.read_sub_variable
    line.split(":").at(0)
  end
  
  def SaveDataReader.read_sub_value
    line.split(":").at(1)
  end
end

# End
