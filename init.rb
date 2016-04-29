require_dependency 'semipublic_hook_listener'
Redmine::Plugin.register :redmine_semipublic do
  name 'Redmine Semipublic plugin'
  author 'Mikael Borg'
  description 'Semipublic issue views'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  project_module :semipublic_links do
    permission :edit_public_links, :public_links => :toggle
  end
  menu :admin_menu, :semi_public, { :controller => 'public_links', :action => 'index' }, :caption => 'Public Links'

end
