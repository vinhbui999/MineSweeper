# frozen_string_literal: true

class Cell < ApplicationRecord
  belongs_to :board, inverse_of: :cells

  def mine?
    is_mine
  end
end
