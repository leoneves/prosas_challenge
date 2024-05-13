# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :assessments, dependent: :restrict_with_error
end
