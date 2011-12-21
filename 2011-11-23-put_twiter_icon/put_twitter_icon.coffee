$ ->
  console.log "ready"
  url = "http://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=koyachi"
  $.ajax
    url: url
    dataType: "jsonp"
    crossDomain: "true"
    success: (data) ->
      console.log data

# httpsでJSONPできないらしいのでやめた
