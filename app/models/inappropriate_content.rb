class InappropriateContent < ActiveRecord::Base
  belongs_to :content, polymorphic: true

  after_create :lock_content
  after_destroy :unlock_content
  after_update :notify_admin, if: lambda {|c| c.status.to_s == 'awaiting' }
  after_update :still_inappropriate, if: lambda {|c| c.status.to_s == 'active' }

  validates :content_id, uniqueness: {scope: [:content_type]}

  def lock_content
    content.lock!
    InappropriateContentMailer.inappropriate(self).deliver
  end

  def unlock_content
    content.unlock!
    InappropriateContentMailer.appropriate(self).deliver
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:only] = [:id, :reason, :status, :content_id, :content_type]
    options[:methods] = [:parent_id]
    super
  end

  def parent_id
    case content_type
      when 'EventItem'
        content.pillar.id
    end
  end

  def notify_admin
    InappropriateContentMailer.check_appropriate(self).deliver
  end

  def still_inappropriate
    InappropriateContentMailer.still_inappropriate(self).deliver
  end
end
