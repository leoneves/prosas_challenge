# frozen_string_literal: true

module Monads
  module ModulesResponse
    def response(success:, value: nil, brand_new: false)
      Response.new(success, brand_new, value)
    end
  end
end
