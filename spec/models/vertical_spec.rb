require 'rails_helper'

RSpec.describe Vertical, type: :model  do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:categories) }

  it 'validates uniqueness of name across Vertical and Category models' do
    create :category, name: 'TEST'
    vertical = build :vertical, name: 'TEST'
    expect(vertical).not_to be_valid
  end
end
