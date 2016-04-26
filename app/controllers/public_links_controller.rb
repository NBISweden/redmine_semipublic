require 'securerandom'

class PublicLinksController < ApplicationController
  unloadable
  
  before_filter :require_admin, :only => [:index]

  def new
    @public_link = PublicLink.new(:issue => @issue)
  end

  def create
   public_link = PublicLink.new(:issue => @issue)
  end

  def resolve
          pl = public_links.find(params[:url])
          if(pl && pl.active)
                  puts issueno
                  return issue.url
                  render "issues/show"
          else
                  return 401
          end
  end

  def toggle
      pl = public_links.find(params[:id])
      #(render_403; return false) unless @pl.issue.editable_by?(User.current)
      pl.active.toggle
  end

  def index
    @public_links = PublicLink.all
    render :index
  end

private
  def create_url()
    @url = SecureRandom.urlsafe_base64
  end

      
end
