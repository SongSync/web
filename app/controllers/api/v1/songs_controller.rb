class Api::V1::SongsController < Api::V1::ApiController
  load_and_authorize_resource

  def index
    render json: @user.songs
  end

  def create
    @song = @user.songs.create(song_params)
    Playlist.find(params[:playlist_id].to_i).songs << @song if params[:playlist_id].to_i > 0
    render json: @song
  end

  def show
    render json: Song.find(params[:id])
  end

  def update
    render json: @song.update_attributes(song_params)
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

    pars[:file] = params[:file] if params[:file]
    return pars
  end
end
