class Category < ApplicationRecord
  belongs_to :vertical
  has_many :courses
  accepts_nested_attributes_for :courses,allow_destroy: true
  enum status: [ :active, :archived ]
  validates :name, uniqueness: true
  validate :check_verticals
  private
   def check_verticals
    vartical_names = Vertical.pluck(:name)
    if vertical_names.include?(self.name)
      self.errors[:base] << "Please add category with different name as it this name  already been used in vertical name of the thi"
     end
  end
end
