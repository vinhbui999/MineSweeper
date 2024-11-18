class CreateCreators < ActiveRecord::Migration[7.2]
  def change
    create_table :creators do |t|
      t.string :email

      t.timestamps
    end
  end
end
