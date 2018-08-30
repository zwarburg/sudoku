# Console: require '.\sudoku.rb'

class Sudoku
  attr_accessor :board
  DEBUG = false
  SIZE = 9
  NUMBERS = (1..9).to_a

  def initialize(**args)
    board = File.open(args[:filename]).map { |line| line[0, 9].chars.map(&:to_i) } if args[:filename]
    board = args[:board] if !board && args[:board]
    if board || args[:board]
      raise ArgumentError, 'board dimensions not valid' if board.length != SIZE
      board.each do |row|
        raise ArgumentError, 'board dimensions not valid' if row.length != SIZE
      end
      @board = board.dup
      @board.map! { |row| row.map! { |col| col == 0 ? nil : col } }
    else
      @board = Array.new(SIZE) { Array.new(SIZE) }
    end
  end

  def ==(other_object)
    board == other_object.board
  end

  def to_s
    # TODO: Can this be refactored to use the map function?
    result = ''
    @board.each_with_index do |row, x|
      row.each_with_index do |_col, y|
        cell = @board[x][y]
        result += "#{cell || ' '}\s"
        result += "|\s" if y == 2 || y == 5
      end
      result += "\n- - - + - - - + - - -" if x == 2 || x == 5
      result += "\n"
    end
    result
  end

  def solve!
    until solved?
      @changed = false
      log('################')
      @board.each_with_index do |row, x|
        row.each_with_index do |_col, y|
          next unless self[x, y].nil?
          allowed_values = allowed_in_cell(x, y)
          raise "There are no possible values for #{x}, #{y}" if allowed_values.empty?
          if allowed_values.size == 1
            self[x, y] = allowed_values[0]
            @changed = true
          end
          log("The cell at #{x}, #{y} can be: #{allowed_values.inspect}")
        end
      end
      raise 'Not solvable at this time' unless @changed
    end
  end

  def solved?
    @board.flatten.none?(&:nil?)
  end

  def [](x, y)
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
    @board.map { |row| row[x] }
  end

  def square(x, y)
    x = 3 * (x / 3)
    y = 3 * (y / 3)

    3.times.map { |j| 3.times.map { |i| @board[y + j][x + i] } }
  end

  def allowed_in_cell(x, y)
    NUMBERS - row(y) - col(x) - square(x, y)
  end

  def allowed_in_row(y)
    NUMBERS - row(y)
  end

  def allowed_in_col(x)
    NUMBERS - col(x)
  end

  def allowed_in_square(x, y)
    NUMBERS - square(x, y).flatten
  end

  private

  def log(message)
    puts message if DEBUG
  end
end
