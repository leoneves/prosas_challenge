# frozen_string_literal: true

FactoryBot.define do
  factory :assessment do
    weighted_mean { 1.5 }
    project { nil }
  end
end
