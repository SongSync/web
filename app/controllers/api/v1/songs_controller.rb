class Api::V1::SongsController < Api::V1::ApiController
  load_and_authorize_resource

  def index
    render json: @user.songs
  end

  def create
    render json: @user.songs.create(song_params)
  end

  def show
    render json: Song.find(params[:id])
  end

  def destroy
    render json: @song.destroy
  end
private
  def song_params
    pars = params.require(:song)
    if pars.is_a? String
      pars = JSON.parse pars
    else
      pars = pars.permit(:name, :file)
    end

    pars[:file] = params[:file]
    return pars
  end
end
