class PublicLinkController < ApplicationController
  unloadable


  def resolve
    issueno = public_links.find(params[:url])
    puts issueno
  end
end
