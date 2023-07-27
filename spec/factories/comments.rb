FactoryBot.define do
  factory :comment do
    association :post
    association :author, factory: :user
  end
end
