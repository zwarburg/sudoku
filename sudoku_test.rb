require 'minitest/autorun'
require_relative 'sudoku'

BOARD = [[nil, 2, nil, nil, nil, 8, 5], [4, nil, 5], [8, nil, nil]]

class SudokuTest < Minitest::Test
  def test_creates_empty_board
    assert_equal Array.new(9){ Array.new(9) }, Sudoku.new.board
  end

  # def test_creates_board_with_numbers
  #   assert_equal BOARD, Sudoku.new(BOARD).board
  # end

  def test_read_line_by_line
    puts generate_puzzle
  end

  def test_get_specific_value
    assert_equal generate_puzzle[1,2], 9
  end

  def test_get_another_specific_value
    assert_equal generate_puzzle[3,8], nil
  end

  def test_set_value
    puzzle = generate_puzzle
    puzzle[8,0] = 2
    assert_equal puzzle[8,0], 2
  end

  def test_set_value_errors_for_duplicate_in_row
    puzzle = generate_puzzle
    err = assert_raises() { puzzle[0,2] = 5 }
    assert_equal '5 is not allowed in the row 2', err.message
  end

  def test_set_value_errors_for_duplicate_in_col
    puzzle = generate_puzzle
    err = assert_raises()  { puzzle[0,2] = 4 }
    assert_equal '4 is not allowed in the col 0', err.message
  end

  def test_set_value_errors_for_duplicate_in_square
    puzzle = generate_puzzle
    err = assert_raises()  { puzzle[1,0] = 2 }
    assert_equal '2 is not allowed in the square at 1, 0', err.message
  end

  def test_get_row
    assert_equal [2,6,9,nil,3,nil,1,7,nil], generate_puzzle.row(3)
  end

  def test_get_col
    assert_equal [nil, 6, nil, 1, nil, 5, nil, 8, 2], generate_puzzle.col(6)
  end

  private

  def generate_puzzle
    lines = Array.new
    File.open('puzzle1.txt').each { |line| lines << line[0,9].chars.map{|val| val.to_i }}
    return Sudoku.new(lines)
  end
end
