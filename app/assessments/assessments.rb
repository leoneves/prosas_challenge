# frozen_string_literal: true

module Assessments
  extend Monads::ModulesResponse

  module_function

  def calc_weighted_mean(assessment)
    sum_of_criterias = 0
    grades_accumulator = assessment.grades.reduce(0) do |accumulator, grade|
      sum_of_criterias += grade.criteria.weight
      accumulator + (grade.grade * grade.criteria.weight)
    end

    (grades_accumulator / sum_of_criterias).round(2)
  end

  def calc_average(assessments)
    weighted_mean_accumulator = assessments.reduce(0) do |accumulator, assessment|
      accumulator + assessment.weighted_mean
    end

    weighted_mean_accumulator / assessments.size
  end
end
