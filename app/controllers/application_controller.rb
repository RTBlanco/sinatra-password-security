require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end

	post "/signup" do
		#your code here!
		if !in_db?(params)
			user = User.new(username: params[:username], password: params[:password])
			if user.save
				redirect to '/login'
			else
				redirect to '/failure'
			end
		end
		redirect to '/failure'
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		#your code here!
		user = User.find_by(username: params[:username])
		if user  && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect to '/success'
		else
			redirect to 'failure'
		end
	end

	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end

		def in_db?(arg)
			user = User.find_by(username: arg[:username])
			user ? true : false 
		end
	end

end
