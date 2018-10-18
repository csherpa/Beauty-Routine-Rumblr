require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

require './models/post.rb'
require './models/user.rb'

enable :sessions
# set :database, {adapter: 'postgresql', database: 'r-umblr_blog'}

get '/' do 
    if session[:user_id] 
        @user = User.find_by(username: params[:username])
        unless session[:user_id].nil?

            @user = User.find(session[:user_id])
            @posts = Post.all.limit(20).reverse
        end

        erb :signin_homepage
    else
        erb :signup_homepage
    end
end

get '/signin' do 
    erb :sign_in
end

post '/signin' do 
    @user = User.find_by(username: params[:username])

    if @user && @user.password == params[:password]
        session[:user_id] = @user.id
        flash[:info] = "#{@user.username} logged in"
        redirect '/'
    else
        flash[:warning] = 'Incorrect Username or Password !!! TRY AGAIN'
        redirect '/signin'
    end
end

get '/signup' do 
    erb :sign_up
end

post '/signup' do 
    @user = User.create(
        username: params[:username],
        password: params[:password],
        email: params[:email],
        firstname: params[:firstname],
        lastname: params[:lastname],
        birthday: params[:birthday]
    )
    session[:user_id] = @user.id 
    flash[:success] = 'Thank you for signing up, @user.username'
    redirect '/'
end

get '/signout' do 
    session[:user_id] = nil
    redirect '/'
end

# EVERYTHING ABOVE WORKS DO NOT TOUCH IT 

get '/profile' do
    @user = User.find_by(id: session[:user_id])
    erb :profile
end

get '/users/:id/edit' do 
    @current_user = User.find(params[:id])
    @user = User.find_by(id: session[:user_id])

    erb :edit_account
end  

put '/users/:id' do
    @current_user = User.find(params[:id])
    @current_user.update(
        username: params[:username],
        password: params[:password],
        email: params[:email],
        firstname: params[:firstname],
        lastname: params[:lastname],
        birthday: params[:birthday]
        )
    redirect '/profile'
end

delete'/users/:id' do
    @current_user = User.find(params[:id])
    @current_user.destroy
    session[:user_id]=nil
    redirect '/'
end

# POST CRUD WORKS EXECPT FOR THE EDIT POSTS

get "/create_post" do
    @user = User.find_by(id: session[:user_id])
    erb :create_post
end

post "/create_post" do

    @user = User.find_by(id: session[:user_id])
   
    @post = Post.create(
        post_name: params[:post_name],     
        post_info: params[:post_info],
        image_url: params[:image_url],
        user_id: @user.id
    )
    redirect "/posts"
    
end

get '/posts/:id/edit' do
    @current_post = Post.find(params[:id])
    erb :edit_post
end

put '/posts/:id' do
    @current_post = Post.find(params[:id])
    @current_post.update(
      post_name: params[:post_name],
      post_info: params[:post_info]
      
    )
    redirect '/posts'
end

get '/posts' do 
    @user = User.find(session[:user_id])
    @posts =  Post.where(user_id: @user.id)    
    erb :my_posts
end

get '/posts' do 
    @posts = Post.all
    erb :signin_homepage
end

delete '/posts/:id' do
    @current_post = Post.find(params[:id])
    @current_post.destroy
    redirect '/posts'
end














# get '/user/:id' do
#     @user = User.find_by(id: session[:user_id])
#     @current_user = User.find(params[:id])
#     @current_user_posts = @current_user.posts
#     @user_posts = @current_user.posts.order("created_at DESC")
#     @allusers = User.all

#     erb :user_posts
# end



# @current_post.user_id = User.find_by(session[:user_id]) 
    # @user = User.find_by(id: session[:user_id])

# get '/my_posts' do
#     @posts = Post.all
#     # @user = User.find(session[:user_id])
#     # @my_posts =  Post.where(user_id: @user.id)
#     erb :my_posts
# end

# get'/posts' do
#     @user = User.find_by(id: session[:user_id])
#     #below shows all other peoples posts
#     @allposts = Post.order("created_at DESC")
#     @allusers= User.all
   
#     erb :all_posts
# end

# get '/post/:id' do
#     @current_post = Post.find(params[:id])
#     @user = User.find_by(id: session[:user_id])
#     @allusers=User.all
#     @posts= Post.all

#     erb :view_post 
# end
  
# end
# get '/my_posts' do
#     @user = User.find_by(id: session[:user_id])
#     # @allposts = Post.order("created_at DESC")
#     # @allposts = Post.where(user_id: @user.id)
#     @my_posts =  Post.where(user_id: @user.id)
    
#     erb :my_posts
# end




# all posts
# get '/post/:id' do
#     @created_post = Post.find(params[:id])
#     erb :show_single_post
# end


# get'/posts' do
#     @user = User.find_by(id: session[:user_id])
#     #below shows all other peoples posts
#     @allposts = Post.order("created_at DESC")
#     @allusers= User.all  
#     erb :all_posts
# end
# put '/posts/:id' do
#     @user = User.find_by(id: session[:user_id])
#     @random_user = User.order('RANDOM()').limit(4)
#     @current_post = Post.find(params[:id])
#     @allusers=User.all
#     @posts= Post.all
#     @few_posts = Post.order('RANDOM()').limit(4)
#     @current_post.update(
#     post_name: params[:post_name],
#     post_info: params[:post_info],
#     image_url: params[:image_url]
#     )
#     erb :view_post
# end






# USER CRUD DONE
# get '/profile/:id' do
#     @user = User.find(params[:id])
#     erb :profile
# end

# get '/edit_account/:id' do
#     @user = User.find(params[:id])
#     erb :edit_account
#   end
  
#   post '/edit_account' do
#       @user = User.update(
#         username: params[:username],
#         password: params[:password],
#         email: params[:email]
#       )
#       redirect "/profile/#{session[:user_id]}"
#   end


# delete '/delete_account' do
#     @user = User.find(session[:user_id])
#     @user.destroy
#     session[:user_id] = nil
#     flash[:warning] = "Account #{user.username} and all posts have been deleted."
#     redirect "/"
# end
# delete '/delete_account/:id' do 
#     User.destroy(session[:user_id])
#     session[:user_id] = nil
#     flash[:warning] = "Account #{user.username} and all posts have been deleted."
#     redirect "/"
# end

#CRUD FOR POSTS

# get '/new_post' do 
#     @user = User.find_by(id: session[:user_id])
#     erb :create_post
# end 

# post '/new_post' do 
#     @user = User.find(session[:user_id])
#     @post = Post.create(
#         post_name: params[:post_name],
#         post_info: params[:post_info],
#         user_id: @user.id,
#         image_url: params[:imgage_url]
#     )
#     flash[:success] = "Post '#{params[:post_name]}' has been published."
#     redirect '/'
# end




# get '/new_post' do 
#     @user = User.find(session[:user_id])
#     erb :create_post
# end

# post '/new_post' do 
#     @user = User.find(session[:user_id])
#     @post = Post.create(
#         post_name: params[:post_name],
#         post_info: params[:post_info],
#         user_id: @user.id,
#         image_url: params[:imgage_url]
#     )
#     flash[:success] = "Post '#{params[:post_name]}' has been published."
#     redirect '/'
# end















# edit post
# get '/edit_post/:id' do
#     @user = User.find(session[:user_id])
#     @post = Post.find(params[:id])
#     erb :edit_post
# end

# post '/edit_post/:id' do
#     @post = Post.find(params[:id])
#     @post.update(
#         post_name: params[:post_name],
#         post_info: params[:post_info],
#         image_url: params[:imgage_url]
#     )

#     flash[:success] = "Post '#{params[:title]}' has been updated."
#     redirect '/my_posts'
# end

# get '/show_post' do
#     @user = User.find(session[:user_id])
#     @show_posts =  Post.where(user_id: @user.id)
#     erb :show_posts
# end

# get '/delete_post/:id' do
#     @user = User.find(session[:user_id])
#     post = Post.find(params[:id])
#     Post.destroy(post.id)
#     flash[:warning] = "Post '#{post.title}' has been deleted."
#     redirect '/my_posts'
# end


















# Create, Edit and Delete Posts
# get '/post' do 
#     @posts =Post.all
#     erb :posts
# end

# get '/post/new' do 
#     @user = User.find(session[:user_id])
#     erb :new_post
# end


# #Show Action -> GET /resource/:id
# get '/post/:id' do 
#     @specific_post = Post.find(params[:id])
#     erb :show_post
# end


# post '/post' do 
#     @user = User.find(session[:user_id])
#     @post = Post.create(
#         title: params[:title],
#         image: params[:image],
#         content: params[:content],
#         user_id: @user.id
#     )
#     flash[:success] = "Post '#{params[:title]}' has been posted."
#     redirect '/posts'
# end

# get '/post/:id/edit' do
#     @current_post = Post.find(params[:id])
#     erb :edit_post
# end

# put '/post/:id' do 
#     @current_post = Dog.find(params[:id])
#     @current_post.update(
#         title: params[:title],
#         image: params[:image], 
#         content: params[:content]
#     )
# end

# delete '/post/:id' do 
#     @current_post = Dog.find(params[:id])
#     @current_post.destroy
#     redirect '/posts'
# end


























# get "/" do
#     if session[:user_id]
#         @user = User.find_by(id: session[:user_id])
#         @user_posts= Post.where(user_id: session[:user_id]).order("created_at")
#         @allusers = User.all
#         @posts=Post.order("created_at DESC").limit(6)
        
#         erb :signup_homepage
#     else
#         # @posts=Post.order("created_at DESC").limit(6)
#         # @allusers = User.all
#         erb :signin_homepage
#     end
  
# end
# get '/profile/:id' do
#     @user = User.find(params[:id])
#     erb :profile
# end

# get '/edit_account/:id' do
#     @user = User.find(params[:id])
#     erb :edit_profile
#   end
  
#   post '/edit_account' do
#       @user = User.update(
#         username: params[:username],
#         password: params[:password],
#         email: params[:email]
#       )
#       redirect "/profile/#{session[:user_id]}"
#   end
  
  

#     get '/delete' do 
#         @user = User.find(session[:user_id])
#         User.destroy(session[:user_id])
#         session[:user_id] = nil
#         flash[:warning] = 'Account has been deleted'
#         redirect "/"
#     end 

# get '/new_post' do 
#     erb :new_post
# end


# get '/profile' do 
#     @user = User.find(session[:id])
#     @posts = Post.where(user_id: session[:id])
#     erb :profile
# end

# get '/profile/:id' do 
#     @user = User.find(params[:id])
#     @posts = Post.where(user_id: session[:id])
#     erb :profile
# end 

# get '/edit_profile/:id' do 
#     @user = User.find(params[:id])
#     erb :edit_profile
# end 

# post '/edit_profile' do   
#     @user = User.update(
#         username: params[:username],
#         password: params[:password],
#         email: params[:password]
#     )
#     redirect '/profile'
# end

# # # delete user account
# # 

# # # create new posts

# get '/new_post' do 
#     @user = User.find(session[:user_id])
#     erb :new_post
# end 


# # displays all new_post 
# post '/new_post' do 
#     @user = User.find(session[:user_id])
#     @post = Post.create(
#         post_name: params[:post_name],
#         post_info: params[:post_info],
#         user_id: @user.id,
#         imgae_url: params[:image_url]
#     )
#     flash[:success] = 'Great job in creating a new post'
#     redirect '/new_post'
# end 

# # post update
# get '/edit_post/:id' do 
#     @post = Post.find(params[:id])
#     @post.update(
#         post_name: params[:post_name],
#         post_info: params[:post_info],
#         image_url: params[:image_url]
#     )
#     flash[:success] = 'Post has been updated'
#     redirect '/all_posts'
# end

# get '/all_posts' do 
#     @user = User.find(session[:user_id])
#     @all_posts = Post.where(user_id: @user.id)
#     erb :all_posts
# end

# get '/post_delete/:id' do 
#     # @user = User.find(session[:user_id])
#     post = Post.find(params[:id])
#     Post.destroy
#     # add and alert with flash
#     redirect '/all_posts'
# end

# def get_current_user
#     User.find(session[:user_id]).username
# end