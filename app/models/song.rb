class Song < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
  has_and_belongs_to_many :playlists

  def serializable_hash(options={})
    super({
      only: [:id, :name],
      methods: [:file_url]
    }.merge(options))
  end

  def file_url
    file.url
  end
end
