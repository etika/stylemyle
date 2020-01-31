class Course < ApplicationRecord
  belongs_to :category
  enum state: [ :active, :archived ]
  validates_presence_of :name, :author, :state
end
