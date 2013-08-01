# 宣言部
express = require 'express'
https = require 'https'
fs = require 'fs'
path = require 'path'
MongoStore = require('connect-mongo')(express)
options =
  pfx: fs.readFileSync 'server.pfx'
  requestCert: true

# 設定部
app = express()
domain = if(process.env.NODE_ENV is 'production') then '192.168.23.1' else 'localhost'
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.locals.pretty = true
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser() #req.body.userへのアクセスを実装
  app.use express.methodOverride() #req.bodyにhiddenmethodを含める事が可能になる（？
  app.use express.cookieParser()
  app.use express.session(
    secret: 'secret'
    store: new MongoStore(
      host: domain
      db: 'session'
      clear_interval: 60 * 60
    )
    cookie:
      httpOnly: false
      maxAge: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
  )

  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.set 'port', process.env.PORT or 3000
  app.use express.errorHandler()

app.configure 'production', ->
  app.set 'port', process.env.PORT or 8080
  app.use express.errorHandler()

# 共通関数部
loginCheck = (req, res, next) ->
  if req.session.user
    next()
  else
    res.redirect '/login'

# ルーティング部
routes = require './routes'
app.get '/', loginCheck, routes.index

login = require './routes/login'
app.get '/login', login.get
app.post '/login', login.post
app.get '/login/logout', loginCheck, login.logout

profile = require './routes/profile'
app.get '/profile', loginCheck, profile.get

timesheet = require './routes/timesheet'
app.get '/timesheet', loginCheck, timesheet.get
app.get '/timesheet/:yearMonth', loginCheck, timesheet.findThisMonth
app.post '/timesheet', loginCheck, timesheet.post


# サーバー起動
https.createServer(options, app).listen app.get('port'), ->
  console.log 'Express server listening on port' + app.get 'port'
