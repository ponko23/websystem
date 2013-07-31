model = require("../models/user.js")
TITLE = "Login"

exports.get = (req, res) ->
  if req.session.user
    res.redirect '/'
  else
    res.render "login",
      title: TITLE

exports.post = (req,res) ->
  console.log req.body
  email = req.body.email
  userId = ''
  query =
    email: email
  staff = model.staff
#  staff1 = new staff
#  staff1.userId = "ENG0002"
#  staff1.email = "def@com"
#  staff1.save (err) ->
  staff.findOne query, (err, data) ->
    console.log err if err
    userId = data.userId if data && data.userId
  password = req.body.password
  crypto = require 'crypto'
  md5 = (str) ->
    crypto.createHash('md5').update(str + 'ponko23').digest("Hex")
  passHash = md5 userId + password
  console.log passHash
  query =
    passHash: passHash
  auth = model.auth
  auth.findOne query, (err, data) ->
    console.log err if err
    console.log data
    if data
      req.session.user = userId #userが更新される前にappのredirectが呼ばれている？
      console.log 'true'
      res.redirect "/"
    else
      console.log 'false'

      res.render "login",
        title: TITLE

exports.logout = (req, res) ->
  console.log req.session
  req.session.destroy()

  res.redirect "/login"