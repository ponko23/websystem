TITLE = "Login"

model = require("../models/user.js")

###
  画面表示処理
  login済で開こうとするとホーム画面に移動する
###
exports.get = (req, res) ->
  if req.session.user
    res.redirect '/'
  else
    res.render "login",
      title: TITLE

###
  login処理
  mailaddressとpasswordからhasshを作成してデータベースにあるかを確認
  あればホーム画面を表示する
###
exports.post = (req,res) ->
  userId = ''
  query = email : req.body.email

  staff = model.staff
  staff.findOne query, (err, data) ->
    console.log err if err

    userId = data.userId if data && data.userId
    crypto = require 'crypto'

    md5 = (str) ->
      keyword = 'ponko23' #ハッシュ作成用の追加文字列
      crypto.createHash('md5').update(str + keyword).digest("Hex")
    #query = passHash : md5 userId + req.body.password #ハッシュ確認用
    console.log md5 userId + req.body.password
    authInfo = model.authInfo
    authInfo.findOne query, (err, data) ->
      console.log err if err

      if data
        req.session.user = userId
        res.redirect "/"
      else
        res.render "login",
          title: TITLE

###
  logout処理
  セッション破棄してログイン画面に戻る
###
exports.logout = (req, res) ->
  req.session.destroy()
  res.redirect "/login"

# 一旦完成 2013/8/1