# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Criterias', type: :request do
  describe 'POST /create' do
    subject do
      post api_v1_criterias_path, params: params, as: :json
      response
    end

    context 'with new criteria' do
      let(:params) do
        { weight: 2 }
      end

      it { is_expected.to have_http_status(:created) }
    end

    context 'with existent criteria' do
      before do
        assessment = create(:assessment, id: 1, project: create(:project))
        grade = create(:grade, assessment: assessment, criteria: create(:criteria, id: 1, weight: 3))
        assessment.update(grades: [grade])
      end

      let(:params) do
        { id: 1, weight: 1 }
      end

      it { is_expected.to have_http_status(:created) }
    end
  end
end
