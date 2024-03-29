require 'securerandom'

class PublicLinksController < ApplicationController
  unloadable
  skip_before_action :check_if_login_required
  skip_before_action :verify_authenticity_token
  before_action :require_admin, :only => [:index, :destroy]
  before_action :find_public_link_by_issue, :only => [:toggle]
  before_action :find_public_link_by_url, :only => [:resolve, :download]
  before_action :find_public_link, :only => [:destroy]
  accept_api_auth :toggle, :index, :create

  def new
    @public_link = PublicLink.new(:issue_id => params[:id])
  end

  def create
    @public_link = PublicLink.new(:issue_id => params[:id])
    if @public_link.save
      respond_to do |format|
        format.html { redirect_to_referer_or Issue.find(@public_link.issue_id) }
        format.api  { render json: @public_link, status: :created }
        format.js
      end
    end
  end

  def destroy
    @public_link.destroy
    respond_to do |format|
      format.html { redirect_to "/public_links" }
      format.js {}
    end
  end

  def resolve
    unless @public_link
      render_404
      return
    end
    @issue = Issue.find(@public_link.issue_id)
    @project = @issue.project
    if(@public_link.active && @project.module_enabled?(:semipublic_links))
      if User.current.allowed_to?(:edit_issues, @project)
        redirect_to "/issues/#{@public_link.issue_id}"
      else
        if(Redmine::VERSION::MAJOR >= 3)
          @journals = @issue.journals.includes(:user, :details).
            references(:user, :details).
            reorder(:created_on, :id).to_a
        else
          @journals = @issue.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC")
        end
        @journals.each_with_index {|j,i| j.indice = i+1}
        @journals.reject!(&:private_notes?)
        Journal.preload_journals_details_custom_fields(@journals)
        @journals.select! {|journal| journal.notes? || journal.visible_details.any?}
        @journals.reverse! if User.current.wants_comments_in_reverse_order?

        @changesets = @issue.changesets.visible.preload(:repository, :user).to_a
        @changesets.reverse! if User.current.wants_comments_in_reverse_order?

        @relations = @issue.relations.select {|r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
        @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
        @priorities = IssuePriority.active
        @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
        @relation = IssueRelation.new

        render "view", layout: "semi_public"
      end
    else
      @message = "Sorry, but this link is not active."
      render "common/error"
    end
  end

  def download
    @issue = Issue.find(@public_link.issue_id)
    @attachment = Attachment.find(params[:id])
    if(@attachment.container_type == "Issue" && @attachment.container_id == @public_link.issue_id)
      if @attachment.container.is_a?(Version) || @attachment.container.is_a?(Project)
        @attachment.increment_download
      end
      logger.info "sending file"
      send_file @attachment.diskfile, :filename => filename_for_content_disposition(@attachment.filename),
        :type => Redmine::MimeType.of(@attachment.filename).to_s,
        :disposition => (@attachment.image? ? 'inline' : 'attachment')

    else
      render_404
    end


  end

  def toggle
    @project = Issue.find(@public_link.issue_id).project
    logger.info "params in controller: #{params}"
    #if(authorize())
    if(authorize("issues", :edit))
      @public_link.toggle!(:active)
      respond_to do |format|
        format.html { redirect_to_referer_or Issue.find(@public_link.issue_id) }
        format.js
      end

     end
  end

  def index
    @public_links = PublicLink.all
    render :index
  end


  private

  def create_url()
    @url = SecureRandom.urlsafe_base64
  end

  def find_public_link
    @public_link = PublicLink.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_public_link_by_issue
    @public_link = PublicLink.find_by(:issue_id => params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_public_link_by_url
    @public_link = PublicLink.find_by(:url => params[:url])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
