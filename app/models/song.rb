class Song < ActiveRecord::Base
  belongs_to :playlist

  def serializable_hash(options={})
    super({
      only: [:id, :name]
    }.merge(options))
  end
end
