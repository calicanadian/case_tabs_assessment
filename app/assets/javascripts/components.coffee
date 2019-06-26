# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  window.run_command = ->
    $("#command-input").unbind().on "keyup", (e) ->
      e.preventDefault()
      if e.which == 13 || e.keyCode == 13
        command_value = e.target.value
        $.ajax(
          url: "/command_io"
          type: "POST"
          dataType: "JSON"
          data: { input: command_value }
          statusCode: {
            200: (response) ->
              output_result(response.result)

            422: (response) ->
              console.log response.responseJSON.message
          }
        )

  window.output_result = (result) ->
    output_container = document.getElementById('ouput-container')
    $(output_container).html('')
    $("#command-input").val('')
    if result
      console.dir result
      $.each result, (index, res) ->
        switch res.type
          when "INSTALL"
            $("#output-container").html(res.message)
          when "DEPEND"
            $(output_container).html('')
          when "REMOVE"
            $("#output-container").html(res.message)
          when "LIST"
            $("#output-container").html("<ul></ul>")
            $.each res.component, (index, component) ->
              $("#output-container ul").append("
                <li>COMPONENT NAME: " + component.name + "</li>
              ")
          when "HELP"
            $("#output-container").html("<ul></ul>")
            $.each res.message, (index, message) ->
              $("#output-container ul").append("
                <li>" + message + "</li>
              ")
          when "END"
            $("#output-container").html(res.type)
          else
            $("#output-container").html(res.message)

  run_command()
