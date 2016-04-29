class PublicLink < ActiveRecord::Base
  unloadable
  #belongs_to :watchable, :polymorphic => true
  attr_accessible :issue_id, :active, :url
  validates_uniqueness_of :url

  def initialize(attributes=nil, *args)
    super
    self.issue_id = issue_id
    self.active = true
    self.url = SecureRandom.urlsafe_base64
  end

end
