require 'set'

describe 'Sudoku solver' do
  include_context 'shared stuff'

  describe '#board_string' do
    let(:result) { parse_board(board_string) }

    it 'converts board_string to sudoku board' do
      expect(result).to eq(board)
    end
  end

  describe '#find_empty_position' do
    it 'find board empty position with x-y coordinate' do
      expect(find_empty_position(board_string).to_set).to eq(empty_positions.to_set)
    end
  end
end

def parse_board(string)
  string.scan(/.{9}/).map { |row| convert_to_integer_array(row) }
end

def convert_to_integer_array(string)
  string.split(//).map(&:to_i)
end

def find_empty_position(board)
  case board.class.to_s
  when 'String'
    index_empty = reorder(board_string: board).enum_for(:scan, /0/).map { Regexp.last_match.offset(0).last }
    coordinate_converter(index_empty)
  when 'Array'
  else
  end
end

def coordinate_converter(array)
  array.map { |number| to_coordinate(number: number) }
end

def to_coordinate(number:, size: 9)
  x_coordinate = number % size == 0 ? size : number % size
  y_coordinate = number % size == 0 ? number / size : number / size + 1

  [x_coordinate, y_coordinate]
end

def reorder(board_string:, size: 9)
  board_string.scan(/.{#{size}}/).reverse.join(',').gsub(/[\s,]/, '')
end
