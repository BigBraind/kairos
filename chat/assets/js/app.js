// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import socket from "./socket"
import "phoenix_html"
//name of message sender, retarded implementation using live view metadata in html and email 9001K version
// checking header for user_mail gtg
if(document.head.querySelector("[name~=user_mail][content]"))
{
  let time = new Intl.DateTimeFormat("en-US" , {
    hour: "numeric",
    dayPeriod: 'narrow',
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
  })
  let date = new Intl.DateTimeFormat("en-GB" , {
    month: "short",
    day: "2-digit",
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
  })

  var present_date // your internal frame of reference date
  var current_date // from inbound messages in channel
  var date_state // keeping track of deltas
  var past_date // past messages in reveries
  let phase = window.location.pathname.split("/").pop()
  let topic = 'journey:' + phase
  let data = {}
  let channel = socket.channel(topic, data); // connect to chat "room"

  channel.on('shout', function (payload) { // listen to the 'shout' event
    console.log(payload)
    let li = document.createElement("li"); // create new list item DOM element
    let name = payload.name || 'guest';    // get name from payload or set default
    current_date = date.format(payload.time)
    if(typeof present_date === "undefined"){
      li.innerHTML = '<b>' + name + '</b>: ' + payload.message + '<i style="float:right;color: gray;"> '+ time.format(payload.time)+ '</i>'; // set li contents
      li.innerHTML += '<div style="width: 100%; height: 25px;  border-bottom: 1px solid gold; text-align: center"><span style="color:#192756; padding: 0 10px; font-style: oblique;">'+ "Session Genesis" +'</span></div>'
      present_date = current_date
    }
    else if (present_date !== current_date){
      li.innerHTML = '<b>' + name + '</b>: ' + payload.message + '<i style="float:right;color: gray;"> '+ time.format(payload.time)+ '</i>'; // set li contents
      li.innerHTML += '<div style="width: 100%; height: 25px;  border-bottom: 1px solid gold; text-align: center"><span style="color:#192756; padding: 0 10px; font-style: oblique;">'+ present_date +'</span></div>'
      present_state = current_date
    }
    else {
      li.innerHTML += '<b>' + name + '</b>: ' + payload.message + '<i style="float:right;color: gray;"> '+ time.format(payload.time)+ '</i>'; // set li contents
    }


    ul.insertBefore(li, ul.childNodes[0]);                    // prepend to list
  });

  channel.on('reverie', function (payload) { // listen to the 'shout' event
    console.log(payload)
    let li = document.createElement("li"); // create new list item DOM element
    payload.time = payload.time* 1000
    past_date = date.format(payload.time)
    if(date_state !== past_date){
      if(typeof date_state !== "undefined") li.innerHTML = '<div style="width: 100%; height: 25px;  border-bottom: 1px solid gold; text-align: center"><span style="color:#192756; padding: 0 10px; font-style: oblique;">'+ date_state +'</span></div>'
      date_state = past_date
    }
    let name = payload.name || 'guest';    // get name from payload or set default
    li.innerHTML += '<b>' + name  + '</b>: ' + payload.message + '<i style="float:right;color: gray;"> '+ time.format(payload.time)+ '</i>'; // set li contents
    ul.append(li);                    // prepend to list
  });

  channel.join().receive("ok", resp => { console.log("Joined successfully", resp) });
  let ul = document.getElementById('msg-list');
  let name = document.head.querySelector("[name~=user_mail][content]").content.split('@')[0];
  let message = document.getElementById('msg');            // message input field
  let type = "public"
  // "listen" for the [Enter] keypress event to send a message:
  msg.addEventListener('keypress', function (event) {
    if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.
      channel.push('shout', { // send the message to the server on "shout" channel
        name: name,     // get value of "name" of person sending the message
        message: message.value,    // get message text (value) from msg input field.
        type: type,
        time: Date.now(),
        journey: topic  // replace with variable lobby name
      });
      msg.value = '';         // reset the message input field for next message.
    }
  });

}
