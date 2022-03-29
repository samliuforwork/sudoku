class SudokuBoard
  attr_accessor :puzzle_string, :puzzle_array

  def initialize(puzzle_string: nil, puzzle_array: nil)
    @puzzle_string = puzzle_string
    @puzzle_array = puzzle_array
    convert_to_string if puzzle_array.present? && puzzle_string.nil?
  end

  def to_board
    rows.map { |row| convert_to_integer_array(row) }
  end

  def find_empty_position
    case puzzle_string.class.to_s
    when 'String'
      index_empty = reorder.enum_for(:scan, /0/).map { Regexp.last_match.offset(0).last }
      all_coordinate_converter(index_empty)
    else
      raise StandardError, 'Given unknown type, only allow input string class.'
    end
  end

  def rows(size: 9)
    puzzle_string.scan(/.{#{size}}/)
  end

  def columns(size: 9)
    (0..(size - 1)).map do |index|
      puzzle_string.scan(/.{#{size}}/).map { |column| column[index] }.join('')
    end
  end

  def blocks(size: 9, block_size: 3)
    result = []

    block_size.times do |index|
      block_range = index * block_size..(index * block_size + 2)
      middle_range = block_size..(block_size + 2)

      result << rows.map { |row| row[block_range] }.first(block_size).join('')
      result << rows.map { |row| row[block_range] }[middle_range].join('')
      result << rows.map { |row| row[block_range] }.last(block_size).join('')
    end

    result
  end

  def check(type:)
    case type
    when 'rows'
      type = self.rows
    when 'columns'
      type = self.columns
    when 'blocks'
      type = self.blocks
    end
    type.map { |board| right_serial?(check_string: board) }
  end

  private

  def convert_to_string
    puzzle_string = puzzle_array.join('')
    @puzzle_string = puzzle_string
  end

  def convert_to_integer_array(string)
    string.split(//).map(&:to_i)
  end

  def reorder(size: 9)
    puzzle_string.scan(/.{#{size}}/).reverse.join(',').gsub(/[\s,]/, '')
  end

  def all_coordinate_converter(array)
    array.map { |number| coordinate_converter(number: number) }
  end

  def coordinate_converter(number:, size: 9)
    x_coordinate = (number % size).zero? ? size : number % size
    y_coordinate = (number % size).zero? ? number / size : number / size + 1

    [x_coordinate, y_coordinate]
  end

  def right_serial?(check_string:, size: 9)
    check_string.size == size && check_string.squeeze.chars.sort.join('').match?(/123456789/)
  end
end
