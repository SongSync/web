class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :songs

  def serializable_hash(options={})
    super({
      only: [:id, :name],
      include: [:songs]
    }.merge(options))
  end
end
