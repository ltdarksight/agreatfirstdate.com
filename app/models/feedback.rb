class Feedback < Tableless
  column :email, :string
  column :subject, :string
  column :body, :text
  column :user_id, :integer

  belongs_to :user
  has_one :profile, through: :user

  validates :subject, :body, presence: true
  validates :subject, length: {maximum: 30}

  def save(validate = true)
    if valid? && FeedbackMailer.feedback(self).deliver
      run_callbacks(:create)
    end
    validate ? valid? : true
  end
end
