class Post < ApplicationRecord
  belongs_to :user
  belongs_to :job, optional: true
  has_many_attached :attachments
end