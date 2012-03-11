testHSL = (s) ->
  result = [
    [160, s, 0.9]
    [160, s, 0.7]
    [160, s, 0.5]
    [160, s, 0.3]
    [160, s, 0.1]

    [120, s, 0.9]
    [120, s, 0.7]
    [120, s, 0.5]
    [120, s, 0.3]
    [120, s, 0.1]

    [80, s, 0.9]
    [80, s, 0.7]
    [80, s, 0.5]
    [80, s, 0.3]
    [80, s, 0.1]

    [40, s, 0.9]
    [40, s, 0.7]
    [40, s, 0.5]
    [40, s, 0.3]
    [40, s, 0.1]

    [0, s, 0.9]
    [0, s, 0.7]
    [0, s, 0.5]
    [0, s, 0.3]
    [0, s, 0.1]

    [-40, s, 0.9]
    [-40, s, 0.7]
    [-40, s, 0.5]
    [-40, s, 0.3]
    [-40, s, 0.1]

    [-80, s, 0.9]
    [-80, s, 0.7]
    [-80, s, 0.5]
    [-80, s, 0.3]
    [-80, s, 0.1]

    [-120, s, 0.9]
    [-120, s, 0.7]
    [-120, s, 0.5]
    [-120, s, 0.3]
    [-120, s, 0.1]

    [-160, s, 0.9]
    [-160, s, 0.7]
    [-160, s, 0.5]
    [-160, s, 0.3]
    [-160, s, 0.1]

    [-180, s, 0.9]
    [-180, s, 0.7]
    [-180, s, 0.5]
    [-180, s, 0.3]
    [-180, s, 0.1]
  ].map((hsl) ->
    "<span class=\"cell\" style=\"background-color:#{ chroma.hsl(hsl).hex() };\">.</span>"
  ).join("")
  result

testLAB = (a) ->
  result = [
    [0.9, a, -0.3]
    [0.7, a, -0.3]
    [0.5, a, -0.3]
    [0.3, a, -0.3]
    [0.1, a, -0.3]

    [0.9, a, -0.2]
    [0.7, a, -0.2]
    [0.5, a, -0.2]
    [0.3, a, -0.2]
    [0.1, a, -0.2]

    [0.9, a, -0.1]
    [0.7, a, -0.1]
    [0.5, a, -0.1]
    [0.3, a, -0.1]
    [0.1, a, -0.1]

    [0.9, a, 0]
    [0.7, a, 0]
    [0.5, a, 0]
    [0.3, a, 0]
    [0.1, a, 0]

    [0.9, a, 0.1]
    [0.7, a, 0.1]
    [0.5, a, 0.1]
    [0.3, a, 0.1]
    [0.1, a, 0.1]

    [0.9, a, 0.2]
    [0.7, a, 0.2]
    [0.5, a, 0.2]
    [0.3, a, 0.2]
    [0.1, a, 0.2]

    [0.9, a, 0.3]
    [0.7, a, 0.3]
    [0.5, a, 0.3]
    [0.3, a, 0.3]
    [0.1, a, 0.3]

    [0.9, a, 0.4]
    [0.7, a, 0.4]
    [0.5, a, 0.4]
    [0.3, a, 0.4]
    [0.1, a, 0.4]
  ].map((lab) ->
    "<span class=\"cell\" style=\"background-color:#{ chroma.lab(lab).hex() };\">.</span>"
  ).join("")
  result

testLAB2 = (c) ->
  TAU = 6.283185307179586476925287
  result = [
    1.0
    0.9
    0.8
    0.7
    0.6
    0.5
    0.4
    0.3
    0.2
    0.1
    0.0
  ].map((l) ->
    # via http://davidad.net/colorviz/
    L = l * 0.61 + 0.09
    angle = TAU / 6.0 - c * TAU
    r = l * 0.311 + 0.125
    a = Math.sin(angle) * r
    b = Math.cos(angle) * r
    "<span class=\"cell\" style=\"background-color:#{ chroma.lab(L, a, b).hex() };\">.</span>"
  ).join("")
  result


$ ->
  console.log "ready"
  title = "playing with chroma"
  $("title").text(title)
  $("h1").text(title)
  html = ""
  html += "<h2>HSL</h2>"
  html += testHSL(1.0)
  html += "<br />"
  html += testHSL(0.5)
  html += "<br />"
  html += testHSL(0.1)
  html += "<hr />"

  html += "<h2>LAB</h2>"
  html += testLAB(0.6)
  html += "<br />"
  html += testLAB(0.4)
  html += "<br />"
  html += testLAB(0.2)
  html += "<br />"
  html += testLAB(0.0)
  html += "<br />"
  html += testLAB(-0.2)
  html += "<br />"
  html += testLAB(-0.4)
  html += "<hr />"

  html += "<h2>LAB 2</h2>"
  html += testLAB2(1.0)
  html += "<br />"
  html += testLAB2(0.9)
  html += "<br />"
  html += testLAB2(0.8)
  html += "<br />"
  html += testLAB2(0.7)
  html += "<br />"
  html += testLAB2(0.6)
  html += "<br />"
  html += testLAB2(0.5)
  html += "<br />"
  html += testLAB2(0.4)
  html += "<br />"
  html += testLAB2(0.3)
  html += "<br />"
  html += testLAB2(0.2)
  html += "<br />"
  html += testLAB2(0.1)
  html += "<br />"

  $("#contents").html(html)
