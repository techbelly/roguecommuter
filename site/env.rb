require "bundler/setup"
Bundler.require(:default)

environment = ENV["RACK_ENV"] || 'development'

app_path = File.dirname(__FILE__)
database = "sqlite3://#{app_path}/#{environment}.db"

DataMapper::setup(:default, database )

require 'db'

DataMapper.finalize
DataMapper.auto_upgrade!

code = <<-EOF
  lib.print(env['hello']+" FROM "+ego['name']);
EOF

environment = {'hello' => "HELLO WORLD"}.to_json

Personality.first_or_create({:name=>"UMBRELLAR"},{:environment=>environment,:code=>code})
Personality.first_or_create({:name=>"BAGMAN"},{:environment=>environment,:code=>code})

