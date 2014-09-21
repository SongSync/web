class Song < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => /\Amedia\/.*\Z/

  default_scope -> { order('id ASC') }

  has_and_belongs_to_many :playlists

  def serializable_hash(options={})
    super({
      only: [:id, :name],
      methods: [:file_url]
    }.merge(options)).merge(errors: errors.full_messages)
  end

  def file_url
    file.url
  end
end
