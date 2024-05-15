# frozen_string_literal: true

module Api
  module V1
    class CriteriasController < ApplicationController
      def create
        permitted_params = params.permit(:id, :weight)

        response = Criterias.create_or_update(permitted_params)

        return unless response.success?

        render json: response.value, status: :created
      end
    end
  end
end
