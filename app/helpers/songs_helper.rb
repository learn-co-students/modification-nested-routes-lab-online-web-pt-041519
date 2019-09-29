module SongsHelper

  def artist_id_field(song)
    if song.artist.nil?
      select_tag "song[artist_id]", options_from_collection_for_select(Artist.all, :id, :name)
    else
      hidden_field_tag "song[artist_id]", song.artist_id
    end
  end

  # def artist_label(song)
  #   if song.artist.nil?
  #     label "song[artist_id]", "Select Artist: "
  #   else
  #     label "song[artist_id]", song.artist.name
  #   end
  # end

end
