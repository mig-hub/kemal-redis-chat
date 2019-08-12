doctype html
html
  head
    title Chat
  body
    pre#chat
    form
      input#msg placeholder="message..."
      input type="submit" value="Send"

    script src="https://code.jquery.com/jquery-1.11.3.js"
    javascript:
      $(function() {
        var ws = new WebSocket("ws://" + location.host + "/chat");
        ws.onmessage = function(e) { $('#chat').append(e.data + '\\n') };

        $("form").submit(function(e) {
          e.preventDefault();
          var message = $('#msg').val();
          console.log(message);
          ws.send(message);
          $('#msg').val(''); $('#msg').focus();
        });
      });

