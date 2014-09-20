class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :songs

  def serializable_hash(options={})
    super({
      only: [:id, :name],
      methods: [:song_ids]
    }.merge(options))
  end
end
