defmodule ChatWeb.PageLive.Journey do
  use Phoenix.LiveView

  # def mount(_session, socket) do

  # end
  def render(assigns)do
    ~L"""
    <head>
    <%# <link rel="stylesheet" hr ef="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"> %>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
    * {
      box-sizing: border-box;
    }

    /* Create four equal columns that floats next to each other /
    .column {
      float: left;
      width: 25%;
      padding: 10px;
    }

    / Clear floats after the columns /
    .row:after {
      content: "";
      display: table;
      clear: both;
    }

    / Responsive layout - makes a two column-layout instead of four columns /
    @media screen and (max-width: 900px) {
      .column  {
        width: 50%;
      }
    }

    / Responsive layout - makes the two columns stack on top of each other instead of next to each other */
    @media screen and (max-width: 600px) {
      .column  {
        width: 100%;
      }
    }
    </style>
    </head>
    <body>
    <h2>Central Phase Continuum</h2>
    <p>Start your journey by joining the <b>Initiation</b> Phase ! As your mushroom grows, take a picture to document your journey.
      You will gradually unlock different channels corresponding to different stages of your mushroom growth! Join us, each on our unique paths and explore the journey together!</p>

    <div class="row">
      <div class="column" style="background-color:#aaa;">
        <h2> <a href = "./journey/Initiation"> Initiation </a></h2>
        <%# <p>Start here!</p> %>
      </div>
      <div class="column" style="background-color:#bbb;">
        <h2>Primordia Formation</h2>
        <%# <p>Some text..</p> %>
      </div>
      <div class="column" style="background-color:#ccc;">
        <h2>Mature Fruitbody</h2>
        <%# <p>Some text..</p> %>
      </div>
      <div class="column" style="background-color:#ddd;">
        <h2>Harvest</h2>
        <%# <p>Some text..</p> %>
      </div>
    </div>

    </body>

    """
  end
end
