class Api::V1::PlaybackController < Api::V1::ApiController
  def index
    render json: {
      current_timestamp: @user.current_timestamp,
      current_song_id: @user.current_song_id,
      current_playlist_id: @user.current_playlist_id
    }
  end
  def create
    @user.update_attributes(playback_params)
    render json: {success: true}
  end
private
  def playback_params
    params.require(:playback).permit(:current_song_id, :current_playlist_id, :current_timestamp)
  end
end