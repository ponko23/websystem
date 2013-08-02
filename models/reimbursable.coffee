domain = (if (process.env.NODE_ENV is "production") then "192.168.23.1" else "localhost")
mongoose = require("mongoose")
url = "mongodb://" + domain + "/reimbursable"
db = mongoose.createConnection(url, (err) ->
  if err
    console.log "Error connected: " + url + " - " + err
  else
    console.log "Success connected: " + url
)

# Modelの定義
ReimbursableSchema = new mongoose.Schema(
  user : String
,
  collection: 'reimbursable'
)