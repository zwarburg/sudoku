require 'rspec'
require_relative 'sudoku'

BOARD = [[8, nil, 5, 3, 6, 9, nil, nil, nil], [nil, 4, nil, 5, nil, nil, 6, 1, 9], [nil, 9, 2, 7, nil, nil, nil, 8, 5], [2, 6, 9, nil, 3, nil, 1, 7, nil], [nil, nil, 1, 2, 4, 7, nil, nil, 3], [nil, 3, nil, nil, nil, 1, 5, 2, 8], [9, nil, 6, nil, 5, 8, nil, 3, nil], [4, nil, nil, nil, 2, 6, 8, 5, nil], [1, 5, nil, nil, nil, nil, 2, nil, 6]].freeze
BEGINNER = 'fixtures/beginner.txt'.freeze
BEGINNER_SOLUTION = 'fixtures/beginner_solution.txt'.freeze
FILENAME = 'fixtures/easy.txt'.freeze
SOLUTION_FILE = 'fixtures/easy_solution.txt'.freeze

describe 'Sudoku' do
  describe 'initialize' do
    it 'creates an empty board' do
      expect(Sudoku.new.board).to eq(Array.new(9) { Array.new(9) })
    end

    it 'creates a baord from a file' do
      expect(Sudoku.new(filename: FILENAME).board).to eq(BOARD)
    end

    it 'creates a baord from an array' do
      expect(Sudoku.new(board: BOARD).board).to eq(BOARD)
    end
  end

  describe 'display' do
    it 'parses a board to a string' do
      board = <<-TEXT
8   5 | 3 6 9 |       
  4   | 5     | 6 1 9 
  9 2 | 7     |   8 5 
- - - + - - - + - - -
2 6 9 |   3   | 1 7   
    1 | 2 4 7 |     3 
  3   |     1 | 5 2 8 
- - - + - - - + - - -
9   6 |   5 8 |   3   
4     |   2 6 | 8 5   
1 5   |       | 2   6 
TEXT
      expect(generate_puzzle.to_s).to eq(board)
    end
  end

  describe 'setters' do
    it 'can set a value' do
      puzzle = generate_puzzle
      puzzle[8, 0] = 2
      expect(puzzle[8, 0]).to eq(2)
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
      expect(generate_puzzle[1, 2]).to eq(9)
    end

    it 'can get a nil value' do
      expect(generate_puzzle[3, 8]).to be_nil
    end

    it 'can retreive a specific row' do
      expect(generate_puzzle.row(3)).to eq([2, 6, 9, nil, 3, nil, 1, 7, nil])
    end

    it 'can retreive a specific column' do
      expect(generate_puzzle.col(6)).to eq([nil, 6, nil, 1, nil, 5, nil, 8, 2])
    end

    it 'can retreive a specific square' do
      expect(generate_puzzle.square(8, 0)).to eq([[nil, nil, nil], [6, 1, 9], [nil, 8, 5]])
    end
  end

  describe 'solved' do
    it 'is false for an incomplete puzzle' do
      expect(generate_puzzle.solved?).to be false
    end

    it 'is true for a completed puzzle' do
      expect(Sudoku.new(filename: SOLUTION_FILE).solved?).to be true
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
      expect(generate_puzzle.allowed_in_cell(8, 0)).to eq([1, 2, 4, 7])
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

    # it 'tries to solves the puzzle' do
    #   puzzle = generate_puzzle
    #   puts puzzle
    #   puts "#########################"
    #   puzzle.solve!
    #   puts "#########################"
    #   puts puzzle
    # end
  end

  def generate_puzzle
    Sudoku.new(filename: FILENAME)
  end
end
