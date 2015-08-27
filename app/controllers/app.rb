require_relative "../../config/environment"
require_relative "../models/snap"
require_relative "../models/user"

class ApplicationController < Sinatra::Base
  uploadLocation = "../../static/uploads/"
  configure do
    set :public_folder, File.join(File.dirname(__FILE__), "../../static")
    set :views, File.join(File.dirname(__FILE__), "../views")
	enable :sessions
	set :session_secret, "I'm totally not snapchat."
  end

  get '/' do
    erb :land
  end
  
  get "/login" do 
	redirect "/"
  end

  post "/login" do
  	session[:username] = params[:username]
	if User.where({:name => params[:username]}).length == 0
		user = User.new({:name => params[:username]})
		user.save
	end
    redirect "/main"
  end
  
  get "/main" do
  	puts session[:username]
  	if session[:username] == nil
		redirect '/'
	else
		erb :index, :locals=>{:snaps => Snap.where({:to => session[:username], :opened => false}).all}
	end
  end

  get "/send" do
	if session[:username] == nil
		redirect '/'	
	else
		erb :send, :locals => {:users => User.where.not({:name => session[:username]})}
	end
  end

  post "/send" do
    from = session[:username]
    to = params["to"]
    fileDetails = params["file"]
    tempFile = File.open(fileDetails[:tempfile])
    uuid = SecureRandom.uuid
    finalPath = File.join(File.dirname(__FILE__), File.join(uploadLocation, uuid))
    storedFile = File.open(finalPath, "w")
    storedFile.write(tempFile.read)
    tempFile.close
    storedFile.close
    dbHash = {
      :from => from,
      :to => to,
      :filepath => "uploads/#{uuid}",
      :mime => fileDetails[:type],
      :time_sent => Time.now,
      :opened => false
    }
    snap = Snap.new(dbHash)
    snap.save
  	redirect "/main"
  end 

  get "/open/:id" do
    snap = Snap.where({:id => params[:id]}).take
    if !snap.opened
      snap.opened = true
      snap.save
      "{\"error\": 0, \"imgPath\": \"/#{snap.filepath}\"}"
    else
      "{\"error\": 1}"
    end 
  end

  get "/close/:id" do
    snap = Snap.where({:id => params[:id]}).take
    File.delete(File.join("../static/", snap.filePath))
  end

  post "/logout" do
  	session.clear	
	redirect "/"
  end
  
end
