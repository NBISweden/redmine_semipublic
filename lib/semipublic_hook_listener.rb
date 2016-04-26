class SemipublicHookListener < Redmine::Hook::ViewListener
          render_on :view_issues_show_description_bottom, :partial => "public_link/public_link" 
end

