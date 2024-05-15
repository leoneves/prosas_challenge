# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        page = (params[:page] || 1).to_i

        projects = Project.includes(assessments: [grades: :criteria]).page(page)
        return render json: projects, status: :ok if projects.any?

        head(:not_found)
      end

      def create
        permitted_params = params.permit(:id, :name, assessments: [grades: [:grade, { criteria: %i[id weight] }]])

        response = ProjectManagement.create_or_update_project(permitted_params)

        return unless response.success?

        render json: response.value, status: :created
      end
    end
  end
end
