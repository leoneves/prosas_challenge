# frozen_string_literal: true

class GradeSerializer < ActiveModel::Serializer
  attributes :id, :criteria, :grade

  belongs_to :criteria
end
