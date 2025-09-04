FactoryBot.define do
  factory :phash_result do
    image { nil }
    similarity { 1.5 }
    decision { "MyString" }
  end
end
