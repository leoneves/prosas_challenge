# frozen_string_literal: true

FactoryBot.define do
  factory :grade do
    grade { 1.5 }
    assessment { nil }
    criteria { nil }
  end
end
