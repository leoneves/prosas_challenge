# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Criteria, type: :model do
  describe 'save' do
    subject { described_class.new(params) }

    context 'with all valid params' do
      let(:params) do
        { weight: 1.5 }
      end

      it { is_expected.to be_valid }
    end

    context 'without weight' do
      let(:params) do
        { weight: nil }
      end

      it { is_expected.not_to be_valid }
    end
  end
end
