# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'save' do
    subject { described_class.new(params) }

    context 'with all valid params' do
      let(:params) do
        { name: 'p1', average: 1.5 }
      end

      it { is_expected.to be_valid }
    end
  end
end
