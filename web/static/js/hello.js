import {Socket, LongPoller} from "phoenix"
import Cookies from 'js-cookie'

class InnerHello {

  static init(){

    let socket = new Socket("/socket", {params: {token: window.userToken}})

    console.log("socket connecting")
    socket.connect()

    var $status    = $("#status")
    var $messages  = $("#messages")
    var $input     = $("#message-input")
    var $username  = $("#username")
    var $onlinecount  = $("#onlinecount")

    socket.onOpen( ev => console.log("OPEN", ev) )
    socket.onError( ev => console.log("ERROR", ev) )
    socket.onClose( e => console.log("CLOSE", e))

    var chan = socket.channel("rooms:boom", {user: "helapu", pwd: "4242"})
    chan.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    $username.val( Cookies.get("username") )
    console.log( Cookies.get("username") );

    $username.change(function() {
      console.log($(this).val());
      Cookies.set("username", "helapu");
    })


    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        chan.push("new:msg", {user: $username.val(), body: $input.val()})
        $input.val("")
      }
    })

    chan.on("count:online", msg => {
      console.log(  );
      $onlinecount.text( "当前在线人数 " + msg["online"] )
    })

    chan.on("new:msg", msg => {
      $messages.append(this.messageTemplate(msg))
      scrollTo(0, document.body.scrollHeight)
    })

    chan.on("user:entered", msg => {
      var username = this.sanitize(msg.user || "anonymous")
      $messages.append(`<br/><i>[${username} entered]</i>`)
    })
  }

  static sanitize(html){ return $("<div/>").text(html).html() }

  static messageTemplate(msg){
    let username = this.sanitize(msg.user || "anonymous")
    let body     = this.sanitize(msg.body)

    return(`<p><a href='#'>[${username}]</a>&nbsp; ${body}</p>`)
  }

}

InnerHello.init()
