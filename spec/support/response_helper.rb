# frozen_string_literal: true

module Response
  module JsonHelpers
    def parsed_body
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
