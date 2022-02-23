// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// 
// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vesavendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import {InitCheckout} from "./init_checkout"

let Hooks = {} // for creating hooks
Hooks.InitCheckout = InitCheckout

// hooks for emptying the input on the echo form
Hooks.EmptyInput = {
    updated() {
        this.el.elements[2].value = " "
    }
}



// hooks for separating msg on rendering echoes
Hooks.SeparatingMsg = {
    compare_date(current_date, date_cursor, chat_element) {
        let li = document.createElement("li"); // create new list item DOM element
        if (typeof current_date == "undefined") { // start state
            current_date = date_cursor;
            li.innerHTML += '<div style="width: 100%; height: 25px;  border-bottom: 1px solid gold; text-align: center"><span style="color:#192756; padding: 0 10px; font-style: oblique;">' + current_date + '</span></div>'

        } else if (current_date !== date_cursor) {
            current_date = date_cursor;
            li.innerHTML += '<div style="width: 100%; height: 25px;  border-bottom: 1px solid gold; text-align: center"><span style="color:#192756; padding: 0 10px; font-style: oblique;">' + current_date + '</span></div>'
        }
        chat_element.insertBefore(li, chat_element.childNodes[0])
        return current_date

    },

    mounted() {
        var current_date;
        let ul = document.getElementById("echoes-list-echoes").children; // getting the ul element of rendering the echoes object

        for (var i = 0; i < ul.length; i++) {
            var date_cursor;
            var current_date;
            date_cursor = ul[i].dataset.date.split(" ")[0]; //getting the date
            current_date = this.compare_date(current_date, date_cursor, ul[i]) // updating date
        }
    }

}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params:
    {
        _csrf_token: csrfToken,
        locale: Intl.NumberFormat().resolvedOptions().locale,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        timezone_offset: -(new Date().getTimezoneOffset() / 60)
    },
    metadata:
    {
        keyup: (e, el) => {
            return {
                key: e.key,
                metaKey: e.metaKey,
                repeat: e.repeat
            }
        }
    },
    hooks: Hooks
}
)

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#D9BB41"}, shadowColor: "rgba(0, 0, 0, .5)" })

window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

    // expose liveSocket on window for web console debug logs and latency simulation:
    >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
