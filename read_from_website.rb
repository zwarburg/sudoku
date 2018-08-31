require 'open-uri'
require_relative 'models/sudoku'
PUZZLE_ID = /link for this puzzle">([\w]*) Puzzle ([\d,]*)/
TABLE = /(<TABLE id="puzzle_grid".*<\/TABLE>)/
INPUTS = /<INPUT[^>]*>/
VALUE = /VALUE="([\d])"/

def get_puzzle
  html = open('https://nine.websudoku.com/?level=1').read
  puzzles_ids = html.scan(PUZZLE_ID)
  html = html.scan(TABLE).first.first
  inputs = html.scan(INPUTS)
  chars = []
  inputs.each do |cell|
    result = cell.scan(VALUE)
    chars << (result.empty? ? nil : result[0][0].to_i)
  end

  board = chars.each_slice(9).to_a
  puzzle = Sudoku.new(board: board)
  difficulties = ['Easy', 'Medium', 'Hard', 'Evil']
  difficulty = puzzles_ids[0][0]
  id = puzzles_ids[0][1].delete(',')
  puts puzzles_ids[0][0]

  puts "https://www.websudoku.com/?level=#{difficulties.index(difficulty)+1}&set_id=#{id}"
  puzzle.solve!
end


get_puzzle