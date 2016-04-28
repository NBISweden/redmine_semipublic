class SemipublicHookListener < Redmine::Hook::ViewListener
          render_on :view_issues_show_description_bottom, :partial => "public_links/public_link" 
end

