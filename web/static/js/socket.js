import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

console.log("socket connecting");

socket.connect()

socket.onOpen( ev => console.log("OPEN", ev) )
socket.onError( ev => console.log("ERROR", ev) )
socket.onClose( e => console.log("CLOSE", e))

let chan = socket.channel("room:boom", {})

chan.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

// b.onError(e => console.log("something went wrong", e))
// b.onClose(e => console.log("channel closed", e))
chan.on("new:msg", msg => {
  console.log("receive new masseg");
  console.log(msg);
})

chan.on("join", msg => {
  console.log("join ok---");
  console.log(msg);
})

//
export default socket
