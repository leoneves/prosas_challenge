# frozen_string_literal: true

module Criterias
  extend Monads::ModulesResponse

  module_function

  def create_or_update(params)
    transaction_response = ActiveRecord::Base.transaction do
      brand_new = true
      criteria = Criteria.find_by(id: params[:id])

      if criteria.nil?
        criteria = Criteria.new(weight: params[:weight])
        criteria.save!
      else
        update_criteria(criteria, params)
        brand_new = false
      end

      response(success: true, value: criteria, brand_new: brand_new)
    rescue ActiveRecord::RecordInvalid
      raise ActiveRecord::Rollback
    end

    return transaction_response if transaction_response.present?

    response(success: false)
  end

  def update_criteria(criteria, params)
    criteria.update(weight: params[:weight])
  end

  private_methods %i[update_criteria]
end
