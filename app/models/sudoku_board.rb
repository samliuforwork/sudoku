# frozen_string_literal: true

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

  def all_blocks(block_size: 3)
    result = []
    block_size.times do |index|
      result << blocks_sections(index: index).reverse
    end

    result.flatten
  end

  def blocks_sections(index:, block_size: 3)
    block_range = index * block_size..(index * block_size + 2)
    middle_range = block_size..(block_size + 2)
    rows_section = rows.map { |row| row[block_range] }

    [
      rows_section.first(block_size).join(''),
      rows_section[middle_range].join(''),
      rows_section.last(block_size).join('')
    ]
  end

  def check(type:)
    case type
    when 'rows'
      type = rows
    when 'columns'
      type = columns
    when 'blocks'
      type = all_blocks
    end

    type.map { |board| right_serial?(check_string: board) }
  end

  def possible_value(x_coordinate, y_coordinate)
    row = convert_to_integer_array(rows.reverse[y_coordinate - 1])
    column = convert_to_integer_array(columns[x_coordinate - 1])
    block_index = block_position(x_coordinate, y_coordinate)
    block_hash = Hash[
                  all_blocks
                  # .map(&:reverse)
                  .flatten
                  .zip(
                  [
                    [1, 1], [1, 2], [1, 3],
                    [2, 1], [2, 2], [2, 3],
                    [3, 1], [3, 2], [3, 3]
                  ]
                )
                      ]
    block = block_hash.key(block_index)

    [*1..9] - (row + column + convert_to_integer_array(block))
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

  def block_position(x_coordinate, y_coordinate)
    case x_coordinate
    when (1..3)
      x_position = 1
    when (4..6)
      x_position = 2
    when (7..9)
      x_position = 3
    end

    case y_coordinate
    when (1..3)
      y_position = 1
    when (4..6)
      y_position = 2
    when (7..9)
      y_position = 3
    end

    [x_position, y_position]
  end
end
