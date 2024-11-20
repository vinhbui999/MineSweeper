# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :boards do |t|
      t.integer :height
      t.integer :width
      t.integer :creator_id
      t.integer :number_of_mines

      t.timestamps
    end
  end
end
