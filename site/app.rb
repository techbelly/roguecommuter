require 'sinatra'
require 'db'
require 'thread'
require 'json'

EVENT_QUEUE   = Queue.new()
RUNNING = true
CLOCK_DELAY = 5
PAUSED = false

Thread.new do
  puts "CREATING CONSUMER THREAD"
  while RUNNING
    # Yes, there's a race condition here. No I don't care.
    if PAUSED
      sleep CLOCK_DELAY
      next
    end
    event = EVENT_QUEUE.pop
    Personality.dispatch(event)
  end
end

Thread.new do
  puts "CREATING TICKER THREAD"
  while RUNNING
    EVENT_QUEUE << [:tick, Time.now, {}]
    sleep CLOCK_DELAY 
  end
end


set :root, File.dirname(__FILE__)

get '/' do
  @personalities = Personality.all
  erb :index
end

get '/bluetooth/:id' do
    personality = Personality.first(:bluetooth_id => params[:id])
  Personality.transaction do
    personality.state="PHONE"
    personality.save
  end
    content_type :json
    personality.to_json
end

post '/bluetooth/:id' do
  Personality.transaction do
   personality = Personality.first(:bluetooth_id => params[:id])
   personality.environment = JSON.pretty_generate(params[:env])
   personality.state="ACTIVE"
   personality.save
  end
  content_type :json
  personality.to_json
end

post '/' do
    PAUSED = true
    sleep CLOCK_DELAY
    puts params.inspect
    if params["personality_id"]
      personality = Personality.get(params["personality_id"].to_i)
      puts "GOT #{personality.inspect}"
    else
      personality = Personality.new(:name=> params["name"])
    end
    personality.code = params["code"]
    personality.bluetooth_id = params["bluetooth_id"]
    personality.environment = JSON.pretty_generate(JSON.parse(params["env"]))
    personality.save()
    PAUSED = false
  redirect '/'
end


