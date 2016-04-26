require 'securerandom'

class PublicLinkController < ApplicationController
  unloadable

  def create_url()
    @url = SecureRandom.urlsafe_base64
  end

  def resolve
          pl = public_links.find(params[:url])
          if(pl && pl.active)
                  puts issueno
                  return issue.url
          else
                  return 401
          end
  end
end
