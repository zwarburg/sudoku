# Console: require '.\sudoku.rb'
require_relative 'cell'
require 'colorize'

class Sudoku
  attr_accessor :board
  DEBUG = true
  # DEBUG = false
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
      @board.map!.with_index do |row , y|
        row.map!.with_index do |value, x|
          Cell.new(value, x, y)
        end
      end
    else
      @board = []
      SIZE.times do |y|
        row = []
        SIZE.times do |x|
          row << Cell.new(nil, y, x)
        end
        @board << row
      end
    end
    self.update_possibles!
  end

  def ==(other_object)
    self.all_values == other_object.all_values
  end
  
  def all_values
    @board.map{|row| row.map{|cell| cell.value}}    
  end
  
  def to_p
    result = <<~BOARD
      +---------+---------+---------+---------+---------+---------+---------+---------+---------+
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      +---------+---------+---------|---------+---------+---------|---------+---------+---------+
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      +---------+---------+---------|---------+---------+---------|---------+---------+---------+
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      |XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|XXXXXXXXX XXXXXXXXX XXXXXXXXX|
      +---------+---------+---------+---------+---------+---------+---------+---------+---------+
    BOARD
    @board.flatten.each do |cell|
      output = cell.solved? ? "#{cell.value}".center(9).red : cell.possibles.join.center(9)
      result.sub!(/XXXXXXXXX/, output)
    end
    result
  end

  def to_s
    result = <<~BOARD
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
    BOARD
    @board.flatten.each do |cell|
      value = cell.value || ' '
      result.sub!(/X/, value.to_s)
    end
    result
  end

  def solve!
    until solved?
      @changed = false
      log('################')
      log(self.to_p)
      @board.each_with_index do |row, x|
        row.each_with_index do |_col, y|
          cell = self[x, y]
          next unless cell.value.nil?
          allowed_values = allowed_in_cell(x, y)
          raise "There are no possible values for #{x}, #{y}" if allowed_values.empty?
          if allowed_values.size == 1
            self[x, y] = allowed_values[0]
            @changed = true
          else
            allowed_values.each do |val|
              if unique_in_row?(cell, val) || unique_in_col?(cell, val) || unique_in_square?(cell, val)
                cell.value = val
                @changed = true
              end
            end
          end
          
          log("The cell at #{x}, #{y} can be: #{allowed_values.inspect}")
        end
      end
      update_possibles!
      raise 'Not solvable at this time' unless @changed
    end
  end

  def solved?
    @board.flatten.none?{ |cell| cell.value.nil? }
  end
  
  def unique_in_row?(cell, value)
    raise ArgumentError, 'invalid value for cell' unless cell.possibles.include?(value)
    row = row(cell.row)
    row.each do |test_cell|
      next if cell == test_cell
      return false if test_cell.possibles.include?(value)
    end
    true
  end
  
  def unique_in_col?(cell, value)
    raise ArgumentError, 'invalid value for cell' unless cell.possibles.include?(value)
    col = col(cell.col)
    col.each do |test_cell|
      next if cell == test_cell
      return false if test_cell.possibles.include?(value)
    end
    true
  end
  
  def unique_in_square?(cell, value)
    raise ArgumentError, 'invalid value for cell' unless cell.possibles.include?(value) 
    square = square(cell.col, cell.row).flatten
    square.each do |test_cell|
      next if cell == test_cell
      return false if test_cell.possibles.include?(value)
    end
    true
  end
  
  def update_possibles!
    @board.each do |row|
      row.each do |cell|
        cell.possibles = (cell.solved? ? [] : allowed_in_cell(cell.col, cell.row))
      end
    end
    @board
  end

  def [](x, y)
    @board[y][x]
  end

  def []=(x, y, value)
    raise "#{value} is not allowed in the row #{y}" unless allowed_in_row(y).include?(value)
    raise "#{value} is not allowed in the col #{x}" unless allowed_in_col(x).include?(value)
    raise "#{value} is not allowed in the square at #{x}, #{y}" unless allowed_in_square(x, y).include?(value)
    @board[y][x].value = value
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
    NUMBERS - values(row(y)) - values(col(x)) - values(square(x, y))
  end
  
  def allowed_in_row(y)
    NUMBERS - values(row(y))
  end

  def allowed_in_col(x)
    NUMBERS - values(col(x))
  end

  def allowed_in_square(x, y)
    NUMBERS - values(square(x, y))
  end

  private
  
  def values(arr)
    arr.flatten.map{|cell| cell.value}
  end

  def log(message)
    puts message if DEBUG
  end
end
