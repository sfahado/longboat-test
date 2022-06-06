FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password { 'StrongPassword' }
    locked { false }
    failed { 0 }
  end
end
