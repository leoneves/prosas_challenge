# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grade, type: :model do
  describe 'save' do
    subject { described_class.new(params) }

    context 'with all valid params' do
      let(:assessment) { create(:assessment, project: create(:project)) }
      let(:criteria) { create(:criteria) }
      let(:params) do
        { grade: 7.58, assessment_id: assessment.id, criteria_id: criteria.id  }
      end

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(assessment: assessment, criteria: criteria) }
    end
  end
end
