require 'datamapper'
require 'json'
require 'v8'

class Runtime
  def log(message)
    puts "#{message}"
  end
end

class Personality 
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :bluetooth_id, String, :length=> 0..40
  property :code, Text
  property :state, String, :default => "ACTIVE"
  property :environment, Text

  def self.active
    Personality.all(:state => "ACTIVE")
  end

  def self.dispatch(event)
    active.each do |a|
      puts "RUNNING #{a}"
      Personality.transaction do
        a.run(event)
      end
    end
  end

  def run(event)
    begin
    ctx = V8::Context.new
    type,time,args = *event
    ctx['ego'] = {:name=>self.name,:state=>self.state }
    ctx['lib'] = Runtime.new
    ctx['env'] = JSON.parse(self.environment)
    ctx['event'] = {:type=>type,:time=>time,:args=>args}
    ctx.eval(self.code)
    environment = ctx['env'].to_json
    save()
    rescue Exception => e
      puts e
    end
  end

end



