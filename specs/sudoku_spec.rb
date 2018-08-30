require 'rspec'
require_relative '../models/sudoku'

BOARD = [[8, nil, 5, 3, 6, 9, nil, nil, nil], [nil, 4, nil, 5, nil, nil, 6, 1, 9], [nil, 9, 2, 7, nil, nil, nil, 8, 5], [2, 6, 9, nil, 3, nil, 1, 7, nil], [nil, nil, 1, 2, 4, 7, nil, nil, 3], [nil, 3, nil, nil, nil, 1, 5, 2, 8], [9, nil, 6, nil, 5, 8, nil, 3, nil], [4, nil, nil, nil, 2, 6, 8, 5, nil], [1, 5, nil, nil, nil, nil, 2, nil, 6]]
BEGINNER = '../fixtures/beginner.txt'.freeze
BEGINNER_SOLUTION = '../fixtures/beginner_solution.txt'.freeze
EASY = '../fixtures/easy.txt'.freeze
EASY_SOLUTION = '../fixtures/easy_solution.txt'.freeze
MEDIUM = '../fixtures/medium.txt'.freeze
MEDIUM_SOLUTION = '../fixtures/medium_solution.txt'.freeze

describe 'Sudoku' do
  describe 'initialize' do
    it 'creates an empty board' do
      expect(Sudoku.new.all_values).to eq(Array.new(9) { Array.new(9) })
    end

    it 'creates a board from a file' do
      expect(Sudoku.new(filename: EASY).all_values).to eq(BOARD)
    end

    it 'creates a board from an array' do
      board = BOARD.map(&:dup)
      expect(Sudoku.new(board: board).all_values).to eq(BOARD)
    end
  end

  describe 'display' do
    it 'parses a board to a string' do
      board = <<~TEXT
        +-------+-------+-------+
        | 8   5 | 3 6 9 |       |
        |   4   | 5     | 6 1 9 |
        |   9 2 | 7     |   8 5 |
        +-------+-------+-------+
        | 2 6 9 |   3   | 1 7   |
        |     1 | 2 4 7 |     3 |
        |   3   |     1 | 5 2 8 |
        +-------+-------+-------+
        | 9   6 |   5 8 |   3   |
        | 4     |   2 6 | 8 5   |
        | 1 5   |       | 2   6 |
        +-------+-------+-------+
      TEXT
      expect(generate_puzzle.to_s).to eq(board)
    end
    it 'parses a board to display the possible values for each cell' do
      board = <<~TEXT 
        +---------+---------+---------+---------+---------+---------+---------+---------+---------+
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        +---------+---------+---------|---------+---------+---------|---------+---------+---------+
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        +---------+---------+---------|---------+---------+---------|---------+---------+---------+
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        |123456789 123456789 123456789|123456789 123456789 123456789|123456789 123456789 123456789|
        +---------+---------+---------+---------+---------+---------+---------+---------+---------+
      TEXT
      expect(Sudoku.new.to_p).to eq(board)
    end
  end

  describe 'setters' do
    it 'can set a value' do
      puzzle = generate_puzzle
      puzzle[8, 0] = 2
      expect(puzzle[8, 0].value).to eq(2)
    end

    it 'raises an error for duplicate in row' do
      expect { generate_puzzle[0, 2] = 5 }.to raise_error('5 is not allowed in the row 2')
    end

    it 'raises an error for duplicate in col' do
      expect { generate_puzzle[0, 2] = 4 }.to raise_error('4 is not allowed in the col 0')
    end

    it 'raises an error for duplicate in square' do
      expect { generate_puzzle[1, 0] = 2 }.to raise_error('2 is not allowed in the square at 1, 0')
    end
  end

  describe 'getters' do
    it 'can get a specific value' do
      expect(generate_puzzle[1, 2].value).to eq(9)
    end

    it 'can get a nil value' do
      expect(generate_puzzle[3, 8].value).to be_nil
    end

    it 'can retreive a specific row' do
      expect(generate_puzzle.row(3).map{|cell| cell.value}).to eq([2, 6, 9, nil, 3, nil, 1, 7, nil])
    end

    it 'can retreive a specific column' do
      expect(generate_puzzle.col(6).map{|cell| cell.value}).to eq([nil, 6, nil, 1, nil, 5, nil, 8, 2])
    end

    it 'can retreive a specific square' do
      expect(generate_puzzle.square(8, 0).map{|row| row.map{|cell| cell.value}}).to eq([[nil, nil, nil], [6, 1, 9], [nil, 8, 5]])
    end
  end

  describe 'solved' do
    it 'is false for an incomplete puzzle' do
      expect(generate_puzzle.solved?).to be false
    end

    it 'is true for a completed puzzle' do
      expect(Sudoku.new(filename: EASY_SOLUTION).solved?).to be true
    end
  end

  describe 'allowed in' do
    it 'verifies the values that are allowed in a row' do
      expect(generate_puzzle.allowed_in_row(5)).to eq([4, 6, 7, 9])
    end

    it 'verifies the values that are allowed in a col' do
      expect(generate_puzzle.allowed_in_col(3)).to eq([1, 4, 6, 8, 9])
    end

    it 'verifies the values that are allowed in a square' do
      expect(generate_puzzle.allowed_in_square(1, 2)).to eq([1, 3, 6, 7])
    end

    it 'verifies the values that are allowed in a particular cell' do
      expect(generate_puzzle.allowed_in_cell(8, 0)).to eq([2, 4, 7])
    end
  end

  describe 'solve' do
    it 'raises an error if the puzzle cannot be solved' do
      expect { Sudoku.new.solve! }.to raise_error('Not solvable at this time')
    end

    it 'solves a beginner puzzle' do
      puzzle = Sudoku.new(filename: BEGINNER)
      puzzle.solve!
      expect(puzzle).to eq(Sudoku.new(filename: BEGINNER_SOLUTION))
    end

    it 'solves an easy puzzle' do
      puzzle = Sudoku.new(filename: EASY)
      puzzle.solve!
      expect(puzzle).to eq(Sudoku.new(filename: EASY_SOLUTION))
    end

    it 'solves a medium puzzle' do
      puzzle = Sudoku.new(filename: MEDIUM)
      puzzle.solve!
      expect(puzzle).to eq(Sudoku.new(filename: MEDIUM_SOLUTION))
    end
  end
  
  describe 'solving strategies' do
    before(:each) do 
      @puzzle = Sudoku.new(filename: MEDIUM)
    end
    describe 'unique in row' do
      it 'raises an error if the cell cannot be the given value' do
        expect{ @puzzle.unique_in_row?(@puzzle[1,2], 9) }.to raise_error(ArgumentError)
      end
      it 'returns true if a cell is the only in the row that can be a given value' do
        expect(@puzzle.unique_in_row?(@puzzle[1,2], 2)).to be true
      end
      it 'returns false if a cell is NOT the only in the row that can be a given value' do
        expect(@puzzle.unique_in_row?(@puzzle[1,2], 3)).to be false
      end
    end
    describe 'unique in column' do
      it 'raises an error if the cell cannot be the given value' do
        expect{@puzzle.unique_in_col?(@puzzle[8,2], 7) }.to raise_error(ArgumentError)
      end
      it 'returns true if a cell is the only in the row that can be a given value' do
        expect(@puzzle.unique_in_col?(@puzzle[8,2], 6)).to be true
      end
      
      it 'returns false if a cell is NOT the only in the row that can be a given value' do
        expect(@puzzle.unique_in_col?(@puzzle[8,2], 8)).to be false
      end
    end
    describe 'unique in square' do
      it 'raises an error if the cell cannot be the given value' do
        expect{@puzzle.unique_in_square?(@puzzle[0,5], 9) }.to raise_error(ArgumentError)
      end
      it 'returns true if a cell is the only in the row that can be a given value' do
        expect(@puzzle.unique_in_square?(@puzzle[7,6], 2)).to be true
      end
      
      it 'returns false if a cell is NOT the only in the row that can be a given value' do
        expect(@puzzle.unique_in_square?(@puzzle[7,6], 8)).to be false
      end
    end
  end

  def generate_puzzle
    Sudoku.new(filename: EASY)
  end
end
