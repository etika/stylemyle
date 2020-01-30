class Course < ApplicationRecord
  belongs_to :category
  enum state: [ :active, :archived ]
end
