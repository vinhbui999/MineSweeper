# frozen_string_literal: true

class AddNameColumnToBoard < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :name, :string
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
