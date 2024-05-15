# frozen_string_literal: true

module Criterias
  extend Monads::ModulesResponse

  module_function

  def create_or_update(params)
    transaction_response = ActiveRecord::Base.transaction do
      brand_new = true
      criteria = Criteria.find_by(id: params[:id])

      if criteria.nil?
        criteria = Criteria.new(weight: params[:weight])
        criteria.save!
      else
        update_criteria(criteria, params)
        brand_new = false
      end

      response(success: true, value: criteria, brand_new: brand_new)
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end

    return transaction_response if transaction_response.present?

    response(success: false)
  end

  def update_criteria(criteria, params)
    if criteria.weight != params[:weight].to_i
      assessments = Assessment.includes(:grades).where(grades: { criteria: criteria })
      assessments.each do |assessment|
        grade_to_update = assessment.grades.find { |grade| grade.criteria_id == params[:id] }
        grade_to_update.criteria.weight = params[:weight]
        ProjectManagement.update_assessments(convert_to_hash(assessments), assessment.project)
      end
    end

    criteria.update(weight: params[:weight])
  end

  def convert_to_hash(assessments)
    JSON.parse(
      ActiveModel::Serializer::CollectionSerializer.new(
        assessments, each_serializer: AssessmentSerializer
      ).to_json, symbolize_names: true
    )
  end

  private_methods %i[update_criteria]
end
