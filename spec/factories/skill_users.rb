FactoryBot.define do
  factory :skill_user do
    skill_id skill
    user_id user
    years Random.new.rand(1..4)
  end
end
