domain = (if (process.env.NODE_ENV is "production") then "192.168.23.1" else "localhost")
mongoose = require("mongoose")
url = "mongodb://" + domain + "/user"
db = mongoose.createConnection(url, (err) ->
  if err
    console.log "Error connected: " + url + " - " + err
  else
    console.log "Success connected: " + url
)

authSchema = new mongoose.Schema(
  passHash: String
,
  collection: 'authInfo'
)
exports.authInfo = db.model("authInfo", authSchema)

staffSchema = new mongoose.Schema(
  userId: String
  email: String
  name: String
  phonetic: String
  birthDay: String
  phone: String
  zip: String
  address: String
  url: String
  note: String
,
  collection: 'staff'
)
exports.staff = db.model("staff", staffSchema)
