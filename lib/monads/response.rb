# frozen_string_literal: true

module Monads
  class Response
    attr_reader :value, :success, :brand_new

    def initialize(success, brand_new, value = nil)
      @success = success
      @brand_new = brand_new
      @value = value
    end

    def success?
      success
    end

    def brand_new?
      brand_new
    end
  end
end
