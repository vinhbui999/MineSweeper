# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :creator, inverse_of: :board
  has_many :cells, inverse_of: :board, dependent: :destroy

  def cell_at(row, col)
    cells.find_by(row: row, col: col)
  end

  def formatted_created_date
    created_at.strftime('%Y/%m/%d %H:%M:%S')
  end
end
