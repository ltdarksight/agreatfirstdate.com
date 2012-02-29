class EventItem < ActiveRecord::Base
  acts_as_estimable profile: :profile, limit: 4

  belongs_to :pillar
  belongs_to :event_type
  has_many :event_descriptors, through: :event_type
  has_many :event_items_event_photos, dependent: :destroy
  has_many :event_photos, through: :event_items_event_photos

  before_validation :set_date

  validates :pillar_id, :event_type_id, :presence => true
  validate :valid_date
  delegate :has_attachments, :title, to: :event_type, prefix: true

  %w[date_1 date_2].each do |date_field|
    define_method("#{date_field}=") do |value|
      self[date_field] = DateTime.strptime(value, I18n.t('date.formats.default')) rescue nil
    end
  end

  def profile
    pillar.profile
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    logger.debug options[:scope]
    options[:methods] = :event_type_title, :event_type_has_attachments, :fields, :title, :description
    options[:include] ||= []
    options[:include] += [event_photos: {only: [:id, :image]}]
    options[:only] = [:id, :pillar_id, :date_1, :date_2, :text_1, :text_2, :string_1, :string_2]
    hash = super
    %w[date_1 date_2].each do |date_field|
      hash[date_field] = I18n.l(hash[date_field].to_date) rescue nil
    end
    hash
  end

  def fields
    type_ids = {text: 0, string: 0, date: 0}
    event_type.event_descriptors.inject([]) do |res, descriptor|
      field_name = "#{descriptor.field_type}_#{type_ids[descriptor.field_type.to_sym]+=1}"
      res << ({field: field_name, label: descriptor.title})
      res
    end
  end

  def values
    type_ids = {text: 0, string: 0, date: 0}
    event_type.event_descriptors.inject({}) do |res, descriptor|
      field_name = "#{descriptor.field_type}_#{type_ids[descriptor.field_type.to_sym]+=1}".to_sym
      res[descriptor.name] = send(field_name)
      res
    end
  end

  def set_date
    self[:date_1] = date_1 || Date.today
  end

  def valid_date
    errors[:date_1] << "can't be grater than #{I18n.l Date.today}" if date_1.to_date > Date.today
  end

  def title
    replace_patterns I18n.t "event_types.#{event_type.name}.title"
  end

  def description
    replace_patterns I18n.t "event_types.#{event_type.name}.description"
  end

  def replace_patterns(source)
    values.each {|(name, value)| source.gsub!(/#\[#{name}\]/, value.to_s) }
    source
  end
end
