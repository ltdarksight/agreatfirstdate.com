class EventItem < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :event_type
  has_many :event_descriptors, through: :event_type
  has_many :event_items_event_photos
  has_many :event_photos, through: :event_items_event_photos

  validates :pillar_id, :event_type_id, :presence => true

  delegate :title, :has_attachments, to: :event_type, prefix: true

  %w[date_1 date_2].each do |date_field|
    define_method("#{date_field}=") do |value|
      self[date_field] = DateTime.strptime(value, I18n.t('date.formats.default')) rescue nil
    end
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :event_type_title, :event_type_has_attachments, :fields
    options[:include] ||= []
    options[:include] += [:event_type, :event_photos]
    #options[:only] = [:id, :has_attachments]
    hash = super
    %w[date_1 date_2].each do |date_field|
      hash[date_field] = I18n.l(hash[date_field].to_date) rescue nil
    end
    hash
  end

  def fields
    @type_ids ||= {text: 0, string: 0, date: 0}
    event_type.event_descriptors.inject([]) do |res, descriptor|
      res << ({field: "#{descriptor.field_type}_#{@type_ids[descriptor.field_type.to_sym]+=1}", label: descriptor.title})
      res
    end
  end
end
