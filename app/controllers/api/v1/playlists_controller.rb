class Api::V1::PlaylistsController < Api::V1::ApiController
  load_and_authorize_resource

  def index
    render json: @user.playlists
  end

  def create
    render json: @user.playlists.create(playlist_params)
  end

  def show
    render json: Playlist.find(params[:id])
  end

  def update
    render json: @playlist.update_attributes(playlist_params)
  end

  def destroy
    render json: @playlist.destroy
  end

  def add
    @playlist.song_ids += params[:song_ids]
    @playlist.song_ids.uniq!
    @playlist.save
    render json: @playlist
  end

  def remove
    @playlist.song_ids -= params[:song_ids]
    @playlist.save
    render json: @playlist
  end

private
  def playlist_params
    params.require(:playlist).permit(:name)
  end
end