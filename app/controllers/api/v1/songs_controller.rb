class Api::V1::SongsController < Api::V1::ApiController
  load_and_authorize_resource

  def index
    render json: @user.songs
  end

  def show
    render json: Song.find(params[:id])
  end

  def destroy
    render json: @song.destroy
  end
end
