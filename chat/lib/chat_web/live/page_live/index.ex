defmodule ChatWeb.PageLive.Index do
  # use Phoenix.LiveView
  use ChatWeb, :live_view

  @impl true
  def mount(_params, _sessions, socket) do
    # socket = assign(socket)
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def render(assigns)do
    ~L"""
      <h2>Cultivators All-Chat</h2>

      <div class="row">
        <!-- <div class="col-xs-3" style="width: 25%; margin-left: 0;"> -->
        <!--   <input type="text" id="name" class="form-control" placeholder="Your Name" style="border: 2px gold solid; font-size: 1.3em;" autofocus> -->
        <!-- </div> -->
        <div class="col-xs-9" style="width: 100%; margin-left: 0%; ">
          <input type="text" id="msg" class="form-control" placeholder="In the beginning was the Word..." style="border: 2px gold solid; font-size: 1.3em;">
        </div>
      </div>


      <!-- The list of messages will appear here: -->
      <ul id="msg-list" style="list-style: none; min-height:200px;">
      </ul>
    """
  end

  def handle_event(_params, _session, socket) do
    

  end
end
