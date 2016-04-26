# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get '/view/:url', to: 'public_links#resolve'

resources :public_links do
     member do
                put :toggle
                get :dbgoutput
     end
end


