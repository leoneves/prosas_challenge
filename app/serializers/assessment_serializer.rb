# frozen_string_literal: true

class AssessmentSerializer < ActiveModel::Serializer
  attributes :id, :grades, :weighted_mean

  def grades
    ActiveModel::Serializer::CollectionSerializer.new(object.grades, each_serializer: GradeSerializer)
  end
end
