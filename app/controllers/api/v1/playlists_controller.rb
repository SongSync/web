class Api::V1::PlaylistsController < ApiController
  load_and_authorize_resource

  def index
    render json: @user.playlists
  end

  def show
    render json: Playlist.find(params[:id])
  end
end