ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require './app/data_mapper_setup'
require 'bcrypt'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, 'super secret'


  get '/' do
    redirect '/users/new'
  end

 get '/users/new' do
    @user = User.new
    erb(:'users/new')
  end

  post '/users' do
    @user = User.new(email: params[:email],
                        password: params[:password],
                        password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect '/links'
    else
      flash.now[:notice] = "Either Invalid email address or Password and confirmation password do not match"
      erb :'users/new'
    end
  end

  get '/links/new' do
    erb(:'links/new')
  end

  post '/links' do
    link = Link.create(title: params[:title], url: params[:url])
    params[:name].split(" ").each do |tag|
      link.tags << Tag.create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/links' do
    @links=Link.all
    erb(:'links/index')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == $0
end

