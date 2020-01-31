FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course ##{n}" }
    author { 'Karl Bose' }
    state { 'active' }
    category
  end
end
