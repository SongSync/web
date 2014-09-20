class Api::V1::PlaylistsController < Api::V1::ApiController
  load_and_authorize_resource

  def index
    render json: @user.playlists
  end

  def show
    render json: Playlist.find(params[:id])
  end

  def destroy
    render json: @playlist.destroy
  end
end