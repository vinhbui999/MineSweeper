# frozen_string_literal: true

class Creator < ApplicationRecord
  has_one :board, inverse_of: :creator

  accepts_nested_attributes_for :board, allow_destroy: true
end
