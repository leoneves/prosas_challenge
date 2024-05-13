# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assessment, type: :model do
  describe 'save' do
    subject { described_class.new(params) }

    context 'with all valid params' do
      let(:project) { create(:project) }
      let(:params) do
        { weighted_mean: 7.58, project_id: project.id }
      end

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes(project_id: project.id) }
    end
  end
end
