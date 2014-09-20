class FixRelations < ActiveRecord::Migration
  def change
    remove_column :songs, :playlist_id
    add_column :songs, :user_id, :integer, index: true
  end
end
