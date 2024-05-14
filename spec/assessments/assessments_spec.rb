# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assessments do
  describe '.calc_weighted_mean' do
    subject { described_class.calc_weighted_mean(assessment) }

    let(:assessment) { create(:assessment, project: create(:project)) }

    context 'with two grades' do
      before { assessment.grades = grades }

      let(:grades) do
        create_list(:grade, 2, grade: 1.5, criteria: create(:criteria, weight: 2), assessment: assessment)
      end

      it { is_expected.to eq(1.5) }
    end

    context 'with five grades' do
      before { assessment.grades = grades }

      let(:grades) do
        [
          create(:grade, grade: 1, criteria: create(:criteria, weight: 5), assessment: assessment),
          create(:grade, grade: 2, criteria: create(:criteria, weight: 4), assessment: assessment),
          create(:grade, grade: 3, criteria: create(:criteria, weight: 3), assessment: assessment),
          create(:grade, grade: 4, criteria: create(:criteria, weight: 2), assessment: assessment),
          create(:grade, grade: 5, criteria: create(:criteria, weight: 1), assessment: assessment)
        ]
      end

      it { is_expected.to eq(2.33) }
    end
  end

  describe '.calc_average' do
    subject { described_class.calc_average(assessments) }

    let(:project) { create(:project, name: 'p1') }

    context 'with five assessments' do
      let(:assessments) do
        [
          create(:assessment, project: project, weighted_mean: 2),
          create(:assessment, project: project, weighted_mean: 4),
          create(:assessment, project: project, weighted_mean: 6),
          create(:assessment, project: project, weighted_mean: 8),
          create(:assessment, project: project, weighted_mean: 10)
        ]
      end

      it { is_expected.to eq(6) }
    end
  end
end
