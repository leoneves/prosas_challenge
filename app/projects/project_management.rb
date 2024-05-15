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

  def update_assessments(new_assessments, project)
    persisted_assessments = Assessment.where(id: new_assessments.pluck(:id))
    changed_assessments = persisted_assessments.map do |assessment|
      assessment_to_change = new_assessments.find { |h| h[:id] == assessment.id }
      assessment_for_calc = merge_updated_grades_in_assessment(assessment, assessment_to_change)
      assessment_for_calc.weighted_mean = Assessments.calc_weighted_mean(assessment_for_calc)
      assessment.update!(weighted_mean: assessment_for_calc.weighted_mean)
      assessment_for_calc
    end

    project.update!(average: Assessments.calc_average(Utils.update_object_in_list(project.assessments, changed_assessments)))
  end

  def update_project(project, params)
    project.update(name: params[:name])
    update_assessments(params[:assessments], project.id) if params[:assessments].present?
    project.update!(average: Assessments.calc_average(project.assessments)) if project.assessments.present?
    project
  end

  def merge_updated_grades_in_assessment(saved_assessment, new_assessment)
    Assessment.new.tap do |o|
      new_assessment[:grades].each do |g|
        updated_grade = Grade.hash_to_object(g, saved_assessment)
        o.grades << updated_grade
        Grade.update_by_id(updated_grade.id, updated_grade)
      end
      index_to_reject = new_assessment[:grades].pluck(:id)
      o.grades << saved_assessment.grades.reject { |g| index_to_reject.include?(g.id) }
      o.id = saved_assessment.id
    end
  end

  private_methods %i[create_new_project update_project]
end
