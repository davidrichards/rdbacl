require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('rdbacl', '0.1.0') do |p|
  p.description              = "Ruby interface for dbacl." 
  p.url                      = "http://github.com/davidrichards/rdbacl" 
  p.author                   = "David Richards" 
  p.email                    = "davidlamontrichards@gmail.com" 
  p.ignore_pattern           = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
