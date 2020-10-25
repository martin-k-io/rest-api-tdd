FactoryBot.define do
  factory :access_token do
    token { "access-token-string" }
    user nil
  end
end
