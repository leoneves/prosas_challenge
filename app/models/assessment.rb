# frozen_string_literal: true

class Assessment < ApplicationRecord
  belongs_to :project

  has_many :grades, dependent: :restrict_with_error
end
