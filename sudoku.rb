class Sudoku
  attr_accessor :board
  SIZE = 9
  NUMBERS = (1..9).to_a

  def initialize(board = nil)
    if board
      raise ArgumentError, "board dimensions not valid" if board.length != SIZE
      board.each do |row|
        raise ArgumentError, "board dimensions not valid"  if row.length != SIZE
      end
      @board = board
      @board.map!{|row| row.map!{ |col| col == 0 ? nil : col}}
    else
      @board = Array.new(SIZE) { Array.new(SIZE) }
      # @board.each_with_index do |row, x|
      #   row.each_with_index do |col, y|
      #     @board[x][y] = y+1
      #   end
      # end
    end
  end

  def to_s
    @board.each_with_index do |row, x|
      row.each_with_index do |col, y|
        cell = @board[x][y]
        print "#{cell || ' '}\s"
        print "|\s" if y==2 || y == 5
      end
      print "\n- - - + - - - + - - -"  if x==2 || x == 5
      puts ''
    end
  end

  def [](x,y)
    @board[y][x]
  end

  def []=(x, y, value)
    raise "#{value} is not allowed in the row #{y}" unless allowed_in_row(y).include?(value)
    raise "#{value} is not allowed in the col #{x}" unless allowed_in_col(x).include?(value)
    raise "#{value} is not allowed in the square at #{x}, #{y}" unless allowed_in_square(x, y).include?(value)
    @board[y][x] = value
  end

  def row(y)
    @board[y]
  end

  def col(x)
    @board.map{|row| row[x]}
  end

  def allowed_in_row(y)
    (NUMBERS - row(y))
  end

  def allowed_in_col(x)
    (NUMBERS - col(x))
  end

  def allowed_in_square(x, y)
    x = 3 * (x/3)
    y = 3 * (y/3)

    vals = []
    3.times do |i|
      3.times do |j|
        vals << @board[x+i][y+j]
      end
    end
    NUMBERS - vals
  end



  def row_valid?(arr)
    return true
  end
  def col_valid?(arr)
    return true
  end
  def box_valid?(box)
    return true
  end
end