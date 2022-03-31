# frozen_string_literal: true

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

  describe '#check' do
    let(:sudoku_solution) { SudokuBoard.new(puzzle_array: solution) }

    context 'with parameter rows' do
      it 'only returns true when all rows pass' do
        expect(sudoku_solution.check(type: 'rows')).to include(true)
        expect(sudoku_solution.check(type: 'rows')).not_to include(false)
      end
    end

    context 'with parameter columns' do
      it 'only returns true when all columns pass' do
        expect(sudoku_solution.check(type: 'columns')).to include(true)
        expect(sudoku_solution.check(type: 'columns')).not_to include(false)
      end
    end

    context 'with parameter blocks' do
      it 'only returns true when all blocks pass' do
        expect(sudoku_solution.check(type: 'blocks')).to include(true)
        expect(sudoku_solution.check(type: 'blocks')).not_to include(false)
      end
    end
  end

  describe '#possible_value' do
    context 'when coordinate point is (3, 3)' do
      let(:sudoku) { SudokuBoard.new(puzzle_string: board_string) }

      it 'shows possible result 5, 9' do
        expect(sudoku.possible_value(3, 3)).to contain_exactly(5, 9)
      end
    end

    context 'when coordinate point is (2, 3)' do
      let(:sudoku) { SudokuBoard.new(puzzle_string: board_string) }

      it 'shows possible result 5' do
        expect(sudoku.possible_value(2, 3)).to contain_exactly(5)
      end
    end
  end
end
