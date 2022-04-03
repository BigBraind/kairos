
# Forms Branch

## 3 April
-  Something weird is going on, but the form branch has the nicest forms for now, and the best-working (but not perfect) carousel component made by Brandon. Only semi-works on transition page. Hence, am will merge it over to develop


# Tailwind Branch

## 9 Feb
- run `mix deps.get` to get the TailWindCSS dependency
- run `mix tailwind.install` to download the standalone Tailwind CLI and generate a tailwind.config.js file in the `./assets` directory. (Its already in but just get the CLI)


<br>

- Chris McCord tutorial (https://fly.io/phoenix-files/tailwind-standalone/) is depracated, big bruh.
- Implemented TailWindCSS dedicated tutorial for phoenix instead, slightly different steps https://tailwindcss.com/docs/guides/phoenix 
- Slight Change: For `config.exs`, I changed input path from `css/app.css` (doesnt exist in our dir) to `../assets/css/app.css` to fit our directory. Both paths didnt crash nor cause any issues
- Added some tailwind code `index.html.heex` (you gotta login first to see), and it works. Only caveat is that EVERY OTHER CSS fails LMAO, will check it out w BB.B
---
<br>
<br>
<br>






# Lifecycle

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
