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
  has_one :profile, through: :recipient

  acts_as_estimable profile: :profile

  validates :sender_id, :recipient_id, :subject, :body, presence: true
  validates :subject, length: {maximum: 30}

  after_create :decrement_points

  def save(validate = true)
    if valid? && UserMailer.say_hi(self).deliver
      run_callbacks(:create)
    end
    validate ? valid? : true
  end

  private

  def decrement_points
    sender.profile.reload
    sender.profile.decrement!(:points, 100)
  end
end