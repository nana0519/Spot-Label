class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.integer "end_user_id", null: false
      t.text "introduction"
      t.string "address", null: false

      t.timestamps
    end
  end
end
