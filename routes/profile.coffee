model = require("../models/user.js")
staff = model.staff
TITLE = "Profile"

exports.get = (req, res) ->
  res.render "profile",
    title: TITLE