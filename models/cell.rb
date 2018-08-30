class Cell
  # DEBUG = true
  DEBUG = false
  attr_accessor :value, :possibles
  attr_reader :row, :col, :box

  def initialize(value = nil, x = 0, y = 0, **_args)
    log("INITIALIZE  x: #{x}, y: #{y}, value: #{value}")
    value = nil if value == 0
    unless value.nil?
      raise ArgumentError, 'invalid value for cell' unless (1..9).cover?(value) && value.is_a?(Integer)
    end
    @value = value
    @row = y
    @col = x
    @box = [[0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]][row / 3][col / 3]
    @possibles = (1..9).to_a unless value
    @possibles ||= []
  end

  def solved?
    !value.nil?
  end

  def to_s
    "Cell x: #{col}, y: #{row}, box: #{box}, value: #{value.nil? ? '-' : value} & posibles: #{possibles.inspect}"
  end

  private

  def log(message)
    puts message if DEBUG
  end
end
