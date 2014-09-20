class Song < ActiveRecord::Base
  belongs_to :playlist
  has_attached_file :file

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
