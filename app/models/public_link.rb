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
  if Rails::VERSION::MAJOR < 4
  def self.find_by(*args)
          logger.info "#{ args }"
          #where(*args).take
          return PublicLink.find{|p| p.issue_id == args[0][:issue_id].to_i} if(args[0].has_key?(:issue_id)) 
          return PublicLink.find{|p| p.url == args[0][:url]} if(args[0].has_key?(:url)) 
  end
  end

end
