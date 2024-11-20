# frozen_string_literal: true

class CreateCells < ActiveRecord::Migration[7.2]
  def change
    create_table :cells do |t|
      t.integer :board_id
      t.integer :row
      t.integer :col
      t.boolean :is_mine, default: false

      t.timestamps
    end
  end
end
