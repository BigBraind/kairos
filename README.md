# Kairos
>> ho nyn kairos

To start your KGB server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Migrate using `mix ecto.migrate` to update the repository that maps to Postgres data store
  * Start Phoenix endpoint with `mix phx.server`OR `iex -S mix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
