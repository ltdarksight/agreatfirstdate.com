module EventDescriptorsHelper
  def clear_descriptor_ids
    @type_ids = {text: 0, string: 0, date: 0}
  end

  def descriptor_field_name(descriptor)
    @type_ids ||= {text: 0, string: 0, date: 0}
    "#{descriptor.field_type}_#{@type_ids[descriptor.field_type.to_sym]+=1}"
  end

  def event_descriptor_title(descriptor)
    I18n.t("event_descriptors.#{descriptor.name}", default: '')
  end
end