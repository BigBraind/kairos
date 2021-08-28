# Kairos
> ho nyn kairos

![Salud](https://64.media.tumblr.com/c3190830c3c97a997c7507c1bb7d47ad/tumblr_n3eqpzSoLf1sh7htzo1_400.gif)

To start your KGB Chat server:

  * Enter the chat directory 
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Next, go back to Chat folder. Migrate using `mix ecto.migrate` to update the repository that maps to Postgres data store
  * In the Chat folder, start Phoenix endpoint with `mix phx.server`OR `iex -S mix.server

Testing:
  * `mix test`
  * `MIX_ENV=test mix coveralls.html` and then access cover/excoveralls.html
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
