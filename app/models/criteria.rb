# frozen_string_literal: true

class Criteria < ApplicationRecord
  validates :weight, presence: true
end
