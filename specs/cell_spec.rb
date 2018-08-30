require 'rspec'
require_relative '../models/cell'

describe 'Cell' do
  describe 'initialize' do
    it 'initializes with a null value' do
      expect(Cell.new(nil, 0, 0).value).to be_nil
    end

    it 'initializes a zero to nil' do
      expect(Cell.new(0, 0, 0).value).to be_nil
    end

    it 'initializes with a given value' do
      expect(Cell.new(5, 0, 0).value).to eq(5)
    end

    it 'raises an error if value is not in proper range' do
      expect { Cell.new(25) }.to raise_error(ArgumentError, 'invalid value for cell')
    end

    it 'raises an error if value is not an integer' do
      expect { Cell.new(5.5) }.to raise_error(ArgumentError, 'invalid value for cell')
      expect { Cell.new('foo') }.to raise_error(ArgumentError, 'invalid value for cell')
    end

    it 'sets the box in accordance with row and col' do
      expect(Cell.new(5, 5, 5).box).to eq(4)
      expect(Cell.new(5, 5, 8).box).to eq(7)
    end
  end

  describe 'solved?' do
    it 'returns false if the value is nil' do
      expect(Cell.new(0, 0, 0).solved?).to be false
    end

    it 'returns true if the value is NOT nil' do
      expect(Cell.new(5, 0, 0).solved?).to be true
    end
  end
end
