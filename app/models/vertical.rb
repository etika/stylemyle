class Vertical < ApplicationRecord
  has_many :categories
  accepts_nested_attributes_for :categories,allow_destroy: true
  validate :check_categories
  validates_presence_of :name
  validates :name, uniqueness: true
  private
  def check_categories
    category_names = Category.pluck(:name)
    if category_names.include?(self.name)
      self.errors[:base] << "Please add vertical with different name as it has already been used"
     end
  end
end
