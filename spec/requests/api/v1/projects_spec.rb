# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  describe 'POST /create' do
    subject(:do_request) do
      post api_v1_projects_path, params: params, as: :json
      response
    end

    context 'without project id' do
      let(:params) do
        {
          name: 'p1'
        }
      end

      it { is_expected.to have_http_status(:created) }
    end

    context 'with project id' do
      before { create(:project, id: 2, name: 'p1') }

      let(:params) do
        {
          id: 2,
          name: 'p1-new'
        }
      end

      it { is_expected.to have_http_status(:created) }

      it do
        do_request
        expect(Project.find(2)).to have_attributes(name: 'p1-new')
      end
    end

    context 'with assessments' do
      let(:criteria) { create(:criteria, id: 1, weight: 3.5) }

      let(:params) do
        {
          name: 'p1',
          assessments: [
            {
              grades: [
                {
                  grade: 7.5,
                  criteria: {
                    id: criteria.id,
                    weight: criteria.weight
                  }
                }
              ]
            }
          ]
        }
      end

      it { is_expected.to have_http_status(:created) }

      it do
        do_request
        expect(Project.last.assessments).not_to be_empty
      end
    end

    context 'without grades' do
      let(:criteria) { create(:criteria, id: 1, weight: 3.5) }

      let(:params) do
        {
          name: 'p1',
          assessments: [
            {
              grades: []
            }
          ]
        }
      end

      it { is_expected.to have_http_status(:created) }

      it do
        do_request
        expect(Project.last.assessments).to be_empty
      end
    end
  end

  describe 'GET /index' do
    subject(:do_request) do
      get api_v1_projects_path, params: params
      response
    end

    context 'without paginate' do
      before { create_list(:project, 2, :with_assessments, size: 2) }

      let(:params) { nil }
      let(:satisfied_response) do
        satisfy do |res|
          res.is_a?(Array) && res.each { |obj| !obj[:assessments].empty? }
        end
      end

      it { is_expected.to have_http_status(:ok) }
      it do
        do_request
        expect(parsed_body).to satisfied_response
      end
    end

    context 'with paginate' do
      before { create_list(:project, 2, :with_assessments, size: 2) }

      let(:params) { { page: 2 } }
      let(:satisfied_response) do
        satisfy do |res|
          res.is_a?(Array) && res.empty?
        end
      end

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
