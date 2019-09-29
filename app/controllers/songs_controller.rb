class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    # IF an :artist_id is being passed in && that :artist_id does not exist
    # redirect to artists index with alert
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: "Artist not found."

    # ELSE create a new song object with an :artist_id
    # :artist_id will either be passed from params or equal to nil if not passed in
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    # binding.pry
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    # IF an :artist_id is being passed in
    if params[:artist_id]
      # Find the artist
      artist = Artist.find_by(id: params[:artist_id])
      # IF artist not found, redirect
      if artist.nil?
        redirect_to artists_path, alert: "Artist not found."
      # IF artist was found
      else
        # Search for given song within artist's songs
        @song = artist.songs.find_by(id: params[:id])
        # If song is not found within artist songs, redirect to artist songs page with alert
        redirect_to artist_songs_path(artist), alert: "Song not found." if @song.nil?
      end
    # No artist ID was provided - just find song.
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end
