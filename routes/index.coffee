TITLE = "My Page"

#model = require("../models/user.js")
#User = model.User
###
  画面表示処理
  ただ開くだけ～
###
exports.index = (req, res) ->
  res.render "index",
    title: TITLE