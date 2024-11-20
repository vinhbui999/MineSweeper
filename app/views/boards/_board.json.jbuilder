# frozen_string_literal: true

json.extract! board, :id, :height, :width, :creator_id, :number_of_mines, :created_at, :updated_at
json.url board_url(board, format: :json)
