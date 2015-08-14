ck = require "coffeekup"
express = require 'express'
WebServer = express()

bodyParser = require "body-parser"
urlencodedParser = bodyParser.urlencoded({ extended: true })

port=3456

shows = require "./opc_controllers/shows.coffee"

lightshow = null

WebServer.listen port, ->
  console.log "listening at #{port}"
  WebServer.get '/' , (req,res)->
    res.send indexHtml

  WebServer.post '/startshow', urlencodedParser, (req,res)->
    if lightshow? then clearInterval lightshow
    switch req.body.show
      when "Rainbow Rows"
        lightshow = shows.rainbowShow req.body.colorArray, .4, 1000
      when "Rave Lights"
        lightshow = shows.flashShow req.body.colorArray, .44, 600
    res.send "dance party"


indexTemplate = ->
  div class:"container",->
    link rel:"stylesheet",href:"bundle.css"
    h1 "DECENTRAL"
    h1 "VANCOUVER"
    h1 "SIDEWALK CONTROLLER"
    div class:'Color_Picker', ->
        div class:"colors", ->
          span class:'colorPick'
        div class:"picker", ->
          button class:"clearcolor btn btn-default btn-md","Reset"
    div class:'submitButtons', ->
      button class:'btn btn-primary btn-lg col-xs-6', "Rainbow Rows"
      button class:'btn btn-primary btn-lg col-xs-6', "Rave Lights"
    script src:"bundle.js"

indexHtml = ck.render indexTemplate

WebServer.use(express.static 'public')
