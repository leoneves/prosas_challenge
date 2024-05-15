# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  has_many :assessments, serializer: AssessmentSerializer
end
