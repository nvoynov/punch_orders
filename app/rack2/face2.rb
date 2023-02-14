require 'json'
require_relative 'filters'
include Filters

def face
  pipeline = proc{|env|
    Authorize.(env)
      .then{|payload, context| Produce.(payload, context)}
      .then{|payload, context| Present.(payload, context)}
  }

  lambda{|env|
    headers = {"content-type" => "application/json"}
    begin
      payload = pipeline.(env)
      [200, headers, [payload]]
    rescue UnauthorizedAccess401 => e
      puts e.backtrace.join(?\n)
      [401, headers, [JSON.generate({error: e.message})]]
    rescue NotFound404 => e
      puts e.backtrace.join(?\n)
      [404, headers, [JSON.generate({error: e.message})]]
    rescue => e
      puts e.backtrace.join(?\n)
      [500, headers, [JSON.generate({error: e.message})]]
    end
  }
end
