# frozen_string_literal: true

module ProjectManagement
  extend Monads::ModulesResponse

  module_function

  def create_or_update_project(params)
    transaction_response = ActiveRecord::Base.transaction do
      brand_new = true
      project = Project.find_by(id: params[:id])

      if project.nil?
        project = Project.new(name: params[:name])
        project.save!
      else
        project.update(name: params[:name])
        brand_new = false
      end

      create_assessment(params[:assessments], project.id)

      response(success: project.persisted?, value: project, brand_new: brand_new)
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end

    return transaction_response if transaction_response.present?

    response(success: false)
  end

  def create_assessment(assessments, project_id)
    return if assessments.blank?

    assessments.each do |assessment|
      next if assessment[:grades].empty?

      persisted_assessment = Assessment.create(project_id: project_id)
      assessment[:grades]&.each do |grade|
        criteria = Criteria.create(weight: grade[:criteria][:weight])
        Grade.create(grade: grade[:grade], assessment_id: persisted_assessment.id, criteria_id: criteria.id)
      end
    end
  end
end
