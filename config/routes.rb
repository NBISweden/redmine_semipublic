# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get '/view/:url', to: 'public_link_controller#resolve'
resources :public_links do
        pl do
                put :toggle
        end
end


