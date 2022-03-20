class ChangeColumnsAddNotnullOnRelationships < ActiveRecord::Migration[6.1]
  def change
    change_column_null :relationships, :followed_id, false
  end
end
