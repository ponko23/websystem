domain = (if (process.env.NODE_ENV is "production") then "192.168.23.1" else "localhost")
mongoose = require("mongoose")
url = "mongodb://" + domain + "/timesheet"
db = mongoose.createConnection(url, (err) ->
  if err
    console.log "Error connected: " + url + " - " + err
  else
    console.log "Success connected: " + url
)

# Modelの定義
TimeSheetSchema = new mongoose.Schema(
  user : String
  contract : String
  yearMonth : String
  day : Number
  attendance : String
  opening : String
  closing : String
  breakTime : String
  nightBreak : String
  note : String
  author : String
  date : Date
,
  collection: 'timesheets'
)

TimeSheetSchema.pre 'save', (next) ->
  @date = new Date()
  next()

exports.timesheet = db.model("TimeSheet", TimeSheetSchema)