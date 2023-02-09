% dRuby Face

## Intro

I like DRb because my distributed journey was started from `The dRuby Book` and in my case that was very helpful. Today having variety of servers could be deployed just in a jiffy with Docker, dRuby might seem as a strange choice, but still today it might be perfect fit for some particular tasks; and it just at hand as a part Ruby standard library.

## Usage

Just run the face by

    $ ruby bin/druby.rb

See the face in action by running client (copy John's Id from server console output and provide valid user_id to create a new order)

    $ ruby bin/druby_client.rb

or see its log placed in `druby-client.log`

## Sources

The code structured the following way:

- `app/druby/conf.rb` - face configuration
- `app/druby/face.rb` - face source code
- `app/druby.rb` - require face source

Shared presenters and starter store content placed in `app/extras` directory:

- `presenters.rb`
- `seed.rb`

Orders Domain code placed inside `lib/orders` directory

To simplify development, the dRuby Face started with InMemoryStore, although could be easily changed for PostgreSQL.
