FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    posts_counter { 0 }
  end
end
