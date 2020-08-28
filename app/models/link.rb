class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp, message: 'has invalid format'
end
