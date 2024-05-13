# frozen_string_literal: true

class Grade < ApplicationRecord
  belongs_to :assessment
  belongs_to :criteria
end
