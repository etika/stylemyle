require 'rails_helper'
RSpec.describe Category, type: :model do
  subject { build :category }

  it { should belong_to(:vertical) }
  it { should have_many(:courses) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:state) }

  it 'validates uniqueness of name across Vertical and Category models' do
    create :vertical, name: 'TEST'
    category = build :category, name: 'TEST'

    expect(category).not_to be_valid
  end
end
