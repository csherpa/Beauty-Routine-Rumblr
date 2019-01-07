require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

require './models/post.rb'
require './models/user.rb'

enable :sessions

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

