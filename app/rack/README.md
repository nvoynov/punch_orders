% Rack Face

## Intro

I chosen Rack because of the nature of the app that is API that does not require anything else beyond request response cycle.

## Usage

Just run the face by

    $ rackup bin/config.ru

See the face in action by running client (copy John's Id from server console output and provide valid user_id to create a new order)

    $ ruby bin/rack_client.rb

or see its log placed in `rack-client.log`

## Sources

The code structured the following way:

- `app/rack/conf.rb` - face configuration
- `app/rack/face.rb` - face source code
- `app/rack.rb` - require face source

@@todo actions are basically proxy objects to call domain services with arguments from `Rack::Request` 

@@todo Shared presenters and starter store content placed in `app/extras` directory:

- `presenters.rb`
- `seed.rb`

Orders Domain code placed inside `lib/orders` directory

To simplify development, the Rack Face started with InMemoryStore, although could be easily changed for PostgreSQL.

@@todo how to provide PostgreSQL store
