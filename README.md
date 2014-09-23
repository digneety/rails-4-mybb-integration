## Rails 4 and MyBB 1.8 User Scheme Integration 

These "snippets" covers basic user authentication with MyBB 1.8 and Rails 4. If I find more time I will create a rails gem.

### How to

Create an additionally connection to mybb database. You can see that in
**app/models/user.rb** I have used the name ``mybb_database_{production,development}``. You can change however you like due to the MIT license.

My routes were follows 

``
  root 'welcome#index'
  get 'auth/sign_in' => 'auth#new', as: 'sign_in'
  post 'auth/sign_in' => 'auth#create'
  delete 'auth/sign_out' => 'auth#destroy', as: 'sign_out'
``

In **app/controllers/auth_controller.rb** you need to change variables to own
purposes, which are self-explanatory

In **app/helpers/application_helper.rb** you find helper methods like
``current_user`` or ``user_signed_in?``

In **app/controllers/application_helper.rb** you find methods comparable to the
helper methods and additionally ``authenticate_user``
