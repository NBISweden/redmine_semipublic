require_dependency 'semipublic_hook_listener'
Redmine::Plugin.register :redmine_semipublic do
  name 'Redmine Semipublic plugin'
  author 'Mikael Borg'
  description 'Semipublic issue views'
  version '0.0.2'
  url 'https://github.com/NBISweden/redmine_semipublic'
  author_url 'https://github.com/nmb'
  project_module :semipublic_links do
    permission :edit_public_links, :public_links => :toggle
  end
  menu :admin_menu, :semi_public, { :controller => 'public_links', :action => 'index' }, :caption => 'Public Links'
  settings :default => {'empty' => true}, :partial => 'settings/semipublic_footer'
end
