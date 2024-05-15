# frozen_string_literal: true

class Grade < ApplicationRecord
  validates :grade, presence: true
  validates :grade, numericality: { only_integer: false }

  belongs_to :assessment
  belongs_to :criteria

  def self.hash_to_object(hash, assessment)
    new(
      id: hash[:id],
      grade: hash[:grade],
      assessment: assessment,
      criteria: Criteria.new(hash[:criteria]),
      assessment_id: assessment.id,
      criteria_id: hash[:criteria][:id]
    )
  end

  def self.update_by_id(id, attributes)
    Grade.update!(id, grade: attributes[:grade])
  end
end
