class ChangeColumnDefaultToEndUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :end_users, :introduction, from: nil, to: "" 
  end
end
