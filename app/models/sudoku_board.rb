class SudokuBoard
  attr_accessor :puzzle_string, :puzzle_array

  def initialize(puzzle_string: nil, puzzle_array: nil)
    @puzzle_string = puzzle_string
    @puzzle_array = puzzle_array
  end

  def to_board
    rows.map { |row| convert_to_integer_array(row) }
  end

  def find_empty_position
    case puzzle_string.class.to_s
    when 'String'
      index_empty = reorder.enum_for(:scan, /0/).map { Regexp.last_match.offset(0).last }
      coordinate_converter(index_empty)
    else
      raise StandardError, 'Given unknown type, only allow input string class.'
    end
  end

  def check_columns
    rows.map { |row| right_serial?(check_string: row) }
  end

  def to_string
    puzzle_string = puzzle_array.join('')
    @puzzle_string = puzzle_string
  end

  private

  def rows(size: 9)
    puzzle_string.scan(/.{#{size}}/)
  end

  def convert_to_integer_array(string)
    string.split(//).map(&:to_i)
  end

  def reorder(size: 9)
    puzzle_string.scan(/.{#{size}}/).reverse.join(',').gsub(/[\s,]/, '')
  end

  def coordinate_converter(array)
    array.map { |number| to_coordinate(number: number) }
  end

  def to_coordinate(number:, size: 9)
    x_coordinate = (number % size).zero? ? size : number % size
    y_coordinate = (number % size).zero? ? number / size : number / size + 1

    [x_coordinate, y_coordinate]
  end

  def right_serial?(check_string:, size: 9)
    check_string.size == size && check_string.squeeze.chars.sort.join('').match?(/123456789/)
  end
end
