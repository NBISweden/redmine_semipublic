class PublicLink < ActiveRecord::Base
  unloadable
  belongs_to :watchable

  def initialize(attributes=nil, *args)
    super
    self.active = true
    self.url = SecureRandom.urlsafe_base64
    self.issueno = @isue.id
  end

end
