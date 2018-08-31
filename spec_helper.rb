require 'rspec'

Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |model|
  require model
end

BOARD = [[8, nil, 5, 3, 6, 9, nil, nil, nil], [nil, 4, nil, 5, nil, nil, 6, 1, 9], [nil, 9, 2, 7, nil, nil, nil, 8, 5], [2, 6, 9, nil, 3, nil, 1, 7, nil], [nil, nil, 1, 2, 4, 7, nil, nil, 3], [nil, 3, nil, nil, nil, 1, 5, 2, 8], [9, nil, 6, nil, 5, 8, nil, 3, nil], [4, nil, nil, nil, 2, 6, 8, 5, nil], [1, 5, nil, nil, nil, nil, 2, nil, 6]]
BEGINNER = File.expand_path('fixtures/beginner.txt', File.dirname(__FILE__))
BEGINNER_SOLUTION = File.expand_path('fixtures/beginner_solution.txt', File.dirname(__FILE__))
EASY = File.expand_path('fixtures/easy.txt', File.dirname(__FILE__))
EASY_SOLUTION = File.expand_path('fixtures/easy_solution.txt', File.dirname(__FILE__))
MEDIUM = File.expand_path('fixtures/medium.txt', File.dirname(__FILE__))
MEDIUM_SOLUTION = File.expand_path('fixtures/medium_solution.txt', File.dirname(__FILE__))
HARD = File.expand_path('fixtures/hard.txt', File.dirname(__FILE__))
HARD_SOLUTION = File.expand_path('fixtures/hard_solution.txt', File.dirname(__FILE__))
