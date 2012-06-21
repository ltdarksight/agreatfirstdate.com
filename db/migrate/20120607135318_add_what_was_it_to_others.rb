class AddWhatWasItToOthers < ActiveRecord::Migration
  def change
    event_types = EventType.find(:all, :conditions => ['name LIKE ?', "%_other"])
    event_types.each do |et|
      et.event_descriptors.create!(field_type: :string, name: 'what_was_it', sort: 99)
    end
  end
end
