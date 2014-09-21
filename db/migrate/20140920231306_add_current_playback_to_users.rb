class AddCurrentPlaybackToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_song_id, :integer
    add_column :users, :current_playlist_id, :integer
    add_column :users, :current_timestamp, :float
  end
end
