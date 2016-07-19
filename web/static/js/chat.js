import {Socket, LongPoller} from "phoenix"

class WebChat {

  static init() {
    let socket = new Socket("/socket", {params: {token: window.userToken}})

    console.log("socket connecting")
    socket.connect()

    $('#loginbtn').click( function () {
      console.log("login btn");
      WebChat.connect()
    })
  }
  static connect(){

    let socket = new Socket("/socket", {params: {token: window.userToken}})

    console.log("socket connecting")
    socket.connect()

    var $status    = $("#status")
    var $messages  = $("#messages")
    var $input     = $("#message-input")
    var $username  = $("#username")
    var $tousername  = $("#tousername")

    var $onlinecount  = $("#onlinecount")

    socket.onOpen( ev => console.log("OPEN", ev) )
    socket.onError( ev => console.log("ERROR", ev) )
    socket.onClose( e => console.log("CLOSE", e))

    var chan = socket.channel("rooms:plan", {uuid: $username.val(), token: "4242"})
    chan.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        chan.push("new:msg", {fromuuid: $username.val(), touuid: $tousername.val(), msg: $input.val()})
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
      var username = this.sanitize(msg.fromuuid || "anonymous")
      $messages.append(`<br/><i>[${username} entered]</i>`)
    })
  }

  static sanitize(html){ return $("<div/>").text(html).html() }

  static messageTemplate(msg){
    let username = this.sanitize(msg.fromuuid || "anonymous")
    let info     = this.sanitize(msg.msg)

    return(`<p><a href='#'>[${username}]</a>&nbsp; ${info}</p>`)
  }
}

WebChat.init()
