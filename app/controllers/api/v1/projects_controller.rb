# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      def create
        permitted_params = params.permit(:id, :name, assessments: [:grade, { criteria: %i[id weight] }])

        response = ProjectManagement.create_or_update_project(permitted_params)

        return unless response.success?

        render json: response.value, status: :created
      end
    end
  end
end