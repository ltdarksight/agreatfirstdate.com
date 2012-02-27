class Email < ActiveRecord::Base
  def self.columns
    @columns ||= []
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,
        default,
        sql_type.to_s,
        null)
  end

  column :subject, :string
  column :body, :text
  column :sender_id, :integer
  column :recipient_id, :integer
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :sender_id, :recipient_id, :subject, :body, presence: true
  validates :subject, length: {maximum: 30}

  after_create :send_email

  def save(validate = true)
    if valid?
      UserMailer.say_hi(self).deliver
      sender.profile.update_attribute(:points, sender.profile.points - 100)
    end
    validate ? valid? : true
  end

end