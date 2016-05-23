require 'rubygems'
require 'sinatra'
require 'haml'
require 'pony'
require 'sqlite3'
# require 'sinatra/reloader'
configure do
  def get_db
    return SQLite3::Database.new 'BarberShop3.db'
  end
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
 "Users"
(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
 "username" TEXT, "phone" TEXT,
 "datestamp" TEXT, "barber" TEXT,
 "color" TEXT
)'
end

get '/' do
  erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
  @error = 'smth went wrong!!!'
  erb :about
end

get '/contacts' do
  haml :contacts
end

get '/visit' do
  erb :visit
end
get '/showusers' do
  db = get_db
  db.results_as_hash = true

     @results = db.execute 'select * from Users order by id desc'
  # @results = db.execute 'select * from Users '


      # f = File.open("views/showusers.erb", "r")
      # f.write "<p> visitors name: #{row['username']} дата приема #{ row['datestamp']}"
      # f.close
  erb :showusers
end
post '/contact' do
  name = params[:name]
  mail = params[:mail]
  body = params[:body]
  Pony.mail(:to => 'koren.hmel@gmail.com', :from => mail, :subject => 'art inquiry from'+ name, :body => body)
  haml :contacts
end
post '/visit' do

  @username = params[:username]
  @phone    = params[:phone]
  @datetime = params[:datetime]
  @barber   = params[:barber]
  @color    = params[:color]

  hh = { username: 'имя', phone: ' ваш телефон', datetime: ' дату и число встречи' }


  if @username.empty?|| @datetime.empty? ||@phone.empty?
    @error ="Введите #{hh.select { |key, value| params[key] == "" }.values.join(", ")}"
    return erb :visit
  else
    db = get_db
    db.execute 'insert into
  users
(
username,
phone,
datestamp,
barber,
color
)
values (?,?,?,?,?)', [@username, @phone, @datetime, @barber, @color]
    @succes = "#{@username}, с вами назначена встреча на #{@datetime}. Ваша персональная инф: Имя: #{@username}, телефон: #{@phone}"
    return erb :visit
  end


end

