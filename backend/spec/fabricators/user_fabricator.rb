Fabricator(:user) do
  name { Faker::Name.name }
  email { sequence(:email) { |i| "user_#{i}@example.com" } }
  password { "password123" }
  password_confirmation { "password123" }
  provider { "local" }
  uid { nil }
end

Fabricator(:user_without_password_digest, from: :user) do
  password { nil }
  password_confirmation { nil }
end

Fabricator(:user_with_diferent_provider, from: :user) do
  password { nil }
  password_confirmation { nil }
  provider { "github" }
  uid { "123456" }
end