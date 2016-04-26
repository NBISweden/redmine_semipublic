class PublicLink < ActiveRecord::Base
  unloadable
  #belongs_to :watchable, :polymorphic => true

  def initialize(attributes=nil, *args)
    super
    self.issue = issue
    self.active = true
    self.url = SecureRandom.urlsafe_base64
  end

end
