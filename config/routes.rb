Rails.application.routes.draw do

	post 'login', to: 'users#login', as: :login
	get 'login', to: 'users#new', as: :new_login
	delete 'logout', to: 'users#logout', as: :logout
  get 'welcome', to: 'users#welcome', as: :welcome
	root to: 'users#welcome'

end
