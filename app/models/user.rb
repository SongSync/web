class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [ :spotify ]

  has_many :playlists
  def serializable_hash(options={})
    super({
      only: [:id, :name],
      include: [:playlists]
    }.merge(options))
  end
end
