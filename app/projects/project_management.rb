# frozen_string_literal: true

module ProjectManagement
  extend Monads::ModulesResponse

  module_function

  def create_or_update_project(params)
    transaction_response = ActiveRecord::Base.transaction do
      brand_new = true
      project = Project.find_by(id: params[:id])

      if project.nil?
        project = create_new_project(params)
      else
        project = update_project(project, params)
        brand_new = false
      end

      response(success: true, value: project, brand_new: brand_new)
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

      persisted_assessment = Assessment.new(project_id: project_id)

      grades = assessment[:grades]&.map do |grade|
        criteria = Criteria.create(weight: grade[:criteria][:weight])
        Grade.new(grade: grade[:grade], assessment_id: persisted_assessment.id, criteria_id: criteria.id)
      end
      persisted_assessment.grades = grades
      persisted_assessment.weighted_mean = Assessments.calc_weighted_mean(persisted_assessment)
      persisted_assessment.save!
    end
  end

  def create_new_project(params)
    project = Project.new(name: params[:name])
    project.save!
    create_assessment(params[:assessments], project.id)
    project.update!(average: Assessments.calc_average(project.assessments)) if project.assessments.present?
    project
  end

  # I will implement later
  def update_assessment(_assessments, _project); end

  def update_project(project, params)
    project.update(name: params[:name])
    update_assessment(params[:assessments], project.id)
    project.update!(average: Assessments.calc_average(project.assessments)) if project.assessments.present?
    project
  end

  private_methods %i[create_new_project update_project]
end
