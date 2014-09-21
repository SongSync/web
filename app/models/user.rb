class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [ :spotify ]

  before_create { self.api_key = SecureRandom.urlsafe_base64(32) }
  after_create { playlists.create(name: 'Your First Playlist') }

  has_many :playlists
  has_many :songs

  def serializable_hash(options={})
    super({
      only: [:id, :name, :api_key, :current_song_id, :current_timestamp],
      include: [:playlists]
    }.merge(options))
  end
end
