class App
   def call(env)
     headers = {
       'content-type' => 'text/html'
     }

     response = ['<h1>Greetings from Rack!</h1>']

     [200, headers, response]
   end
end

run App.new
