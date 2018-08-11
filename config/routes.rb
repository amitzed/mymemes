Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # =================================================
  #             ROUTES FOR TEXTS MODEL
  # =================================================
  get '/texts', to: 'texts#index'
  match '*path', to: 'texts#index', via: :all
  get '/texts/:id', to: 'texts#show'
  # create just texts, no image
  post '/texts', to: 'texts#createOne'
  # create a text to a specific image
  post '/images/:id/pic', to: 'texts#createForImage'
  delete '/texts/:id', to: 'texts#delete'
  put '/texts/:id', to: 'texts#update'

  # =================================================
  #             ROUTES FOR IMAGE MODEL
  # =================================================
  get '/images', to: 'images#index'
  get '/images/:id', to: 'images#show'
  # create just an image, no pic
  post '/images', to: 'images#create'
  post '/texts/:id/image', to: 'images#createWithPic'
  delete '/images/:id', to: 'images#delete'
  put '/images/:id', to: 'images#update'

end
