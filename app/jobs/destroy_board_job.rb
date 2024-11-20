# frozen_string_literal: true

class DestroyBoardJob < ApplicationJob
  queue_as :default

  def perform(board_id)
    # Do something later
    return unless board_id.present?

    Cell.where(board_id: board_id).destroy_all
  end
end
