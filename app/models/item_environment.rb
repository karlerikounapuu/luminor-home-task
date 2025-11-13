class ItemEnvironment < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :configuration_items, dependent: :restrict_with_error
end
