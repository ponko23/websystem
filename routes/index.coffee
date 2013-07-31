model = require("../models/user.js")
User = model.User
TITLE = "My Page"

exports.index = (req, res) ->
  res.render "index",
    title: TITLE



