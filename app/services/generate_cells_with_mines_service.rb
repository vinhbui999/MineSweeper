# frozen_string_literal: true

class GenerateCellsWithMinesService < ApplicationService
  def initialize(board)
    @board = board
  end

  def call
    mines_coordinates = get_random_mine_coordinates(@board).map { |r, c| { row: r, col: c, is_mine: true, board_id: @board.id } }
    create_mines_cells(mines_coordinates)
  end

  def get_random_mine_coordinates(board)
    arr_size = (board.height * board.width)
    coordinates = []
    existed_index = {}
    board.number_of_mines.times do
      loop do
        random_index = rand(0...arr_size)
        next if existed_index[random_index.to_s] == 'true'

        coordinates << get_coordinates(random_index, board.width)
        existed_index.merge!(random_index.to_s => 'true')
        break
      end
    end
    coordinates
  end

  def get_coordinates(index, cols)
    row = (index / cols)
    col = (index % cols)
    # transfer type return
    [row, col]
  end

  def create_mines_cells(mines_coordinates)
    # threads = []
    # mines_coordinates.each_slice(10) do |slice|
    #   threads << Thread.new { Cell.create!(slice) }
    # end
    # threads.each(&:join)
    Cell.insert_all(mines_coordinates)
  end
end
