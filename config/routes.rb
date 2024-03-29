# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get '/view/:url', to: 'public_links#resolve'
get '/view/:url/download/:id/:filename(.:format)', to: 'public_links#download', :id => /\d+/, :filename => /.*/
post '/issues/:id/public_link/new', to: 'public_links#create'
put '/issues/:id/public_link/toggle', to: 'public_links#toggle'

resources :public_links do
  member do
    put :toggle
    get :dbgoutput
  end
end
