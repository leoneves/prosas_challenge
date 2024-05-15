# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { 'MyString' }
    average { 1.5 }
  end

  trait :with_assessments do
    transient do
      size { 1 }
    end

    after(:create) do |project, evaluator|
      create_list(:assessment, evaluator.size, project_id: project.id)
    end
  end
end
