require 'set'

RSpec.describe SudokuBoard, type: :model do
  include_context 'shared stuff'
  let(:sudoku) { SudokuBoard.new(puzzle_string: board_string) }

  describe '#board_string' do
    it 'converts board_string to sudoku board' do
      expect(sudoku.to_board).to eq(board)
    end
  end

  describe '#find_empty_position' do
    it 'find board empty position with x-y coordinate' do
      expect(sudoku.find_empty_position.to_set).to eq(empty_positions.to_set)
    end
  end

  describe '#check_columns' do
    let(:sudoku_solution) { SudokuBoard.new(puzzle_array: solution) }

    it 'only returns true when all rows pass' do
      sudoku_solution.to_string
      expect(sudoku_solution.check_columns).to include(true)
      expect(sudoku_solution.check_columns).not_to include(false)
    end
  end
end
