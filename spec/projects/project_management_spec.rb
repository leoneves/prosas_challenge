# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagement do
  describe '.create_or_update_project' do
    subject(:create_or_update_project) do
      described_class.create_or_update_project(params)
    end

    let(:params) do
      {
        name: 'p1'
      }
    end

    context 'without id' do
      it { is_expected.to be_success }
      it { is_expected.to be_brand_new }
    end

    context 'with id' do
      before do
        create(:project, id: 1, name: 'p1')
        params[:id] = 1
      end

      it { is_expected.to be_success }
      it { is_expected.not_to be_brand_new }
    end

    context 'with assessments' do
      let(:params) do
        {
          name: 'p1',
          assessments: [
            {
              grades: [
                {
                  grade: 1,
                  criteria: {
                    weight: 2
                  }
                },
                {
                  grade: 2,
                  criteria: {
                    weight: 1
                  }
                }
              ]
            },
            {
              grades: [
                {
                  grade: 4,
                  criteria: {
                    weight: 2
                  }
                },
                {
                  grade: 8,
                  criteria: {
                    weight: 1
                  }
                }
              ]
            }
          ]
        }
      end

      it { is_expected.to be_success }

      it do
        create_or_update_project
        project = Project.find_by(name: 'p1')
        expect(project.average).to eq(3.33)
      end
    end

    context 'with error while save project' do
      before { allow_any_instance_of(Project).to receive(:save!).and_raise(ActiveRecord::RecordInvalid) }

      it { is_expected.not_to be_success }
    end

    context 'with error while save assessments' do
      before { allow_any_instance_of(Assessment).to receive(:save!).and_raise(ActiveRecord::RecordInvalid) }

      let(:params) do
        {
          name: 'p1',
          assessments: [
            grades: [
              {
                grade: 7.5,
                criteria: {
                  weight: 2
                }
              }
            ]
          ]
        }
      end

      it { is_expected.not_to be_success }

      it do
        create_or_update_project
        expect(Project.all.size).to eq(0)
        expect(Assessment.all.size).to eq(0)
        expect(Criteria.all.size).to eq(0)
        expect(Grade.all.size).to eq(0)
      end
    end
  end
end
