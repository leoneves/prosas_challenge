# frozen_string_literal: true

module Utils
  module_function

  def update_object_in_list(array, new_versions_of_objects)
    reject_ids = new_versions_of_objects.pluck(:id)
    without_given_object = array.reject { |g| reject_ids.include?(g.id) }
    without_given_object + new_versions_of_objects
  end
end
