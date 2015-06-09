And /^I lookup an Object Code with that Object Sub Type$/ do
  object_code_having_object_sub_type = nil
  while true
    object_code_having_object_sub_type = get_random_object_code(@parameter_values.sample)
    break if object_code_having_object_sub_type != nil
  end
  @lookup_object_code = object_code_having_object_sub_type
end
