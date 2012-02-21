module EventTypesHelper
  def event_type_title(event_type)
    I18n.t "event_types.#{event_type.name}.event_title"
  end
end

