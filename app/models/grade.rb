# frozen_string_literal: true

class Grade < ApplicationRecord
  validates :grade, presence: true
  validates :grade, numericality: { only_integer: false }

  belongs_to :assessment
  belongs_to :criteria
end
