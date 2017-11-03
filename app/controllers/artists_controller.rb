class ArtistsController < ApplicationController
  def index
    preference = Preference.first
    if preference
      sort_order = preference.first.artist_sort_order
    else
      sort_order = 'ASC'
    end

    @artists = Artist.order("name #{sort_order}").all
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    if Preference.first.allow_create_artists
      @artist = Artist.new
    else
      flash[:alert] = "Preference settings do not allow creation of new artists"
      redirect_to artists_path
    end
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :new
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])

    @artist.update(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    flash[:notice] = "Artist deleted."
    redirect_to artists_path
  end

  private

  def artist_params
    params.require(:artist).permit(:name)
  end
end
