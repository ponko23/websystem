TITLE = "Reimbursable"

model = require("../models/reimbursable.js")
Reimbursable = model.reimbursable

exports.get = (req, res) ->
  res.render 'reimbursable',
    title: TITLE
