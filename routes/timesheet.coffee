model = require("../models/timesheet.js")
TITLE = "TimeSheet"
TimeSheet = model.timesheet

exports.get = (req, res) ->
  res.render 'timesheet',
    title: TITLE

exports.findThisMonth = (req, res) ->
  query =
    user: req.session.user
    yearMonth: (req.params.yearMonth.replace /-/, "/")
  TimeSheet.find(query).sort('day').execFind (err, result) ->
    if err
      res.send 'err': err
    else
      res.json result

exports.post = (req, res) ->
  console.log req.body
  date = req.body.day.split '/'
  query =
    user: req.session.user
    yearMonth : date[0] + '/' + date[1]
    day: date[2]

  TimeSheet.findOne query, (err, result) ->
    if result
      if result.author #承認済みの場合は中断（本来は通らないはず）
        res.redirect '/timesheet'
        return
      console.log result
      id = result._id
      TimeSheet.remove _id: id, (err) ->

    if req.body.delet is 'true'
      console.log 'delet!!'
      return
    else
      timesheet =
        "user" : req.session.user
        "yearMonth" : date[0] + '/' + date[1]
        "day" : date[2]
        "attendance" : req.body.attendance
      if id
        timesheet["_id"] = id
      if req.body.opening
        timesheet["opening"] = req.body.opening
      if req.body.closing
        timesheet["closing"] = req.body.closing
      if req.body.breakTime
        timesheet["breakTime"] = req.body.breakTime
      if req.body.nightBreak
        timesheet["nightBreak"] = req.body.nightBreak
      if req.body.note
        timesheet["note"] = req.body.note


      addTimesheet = new TimeSheet timesheet
      addTimesheet.save (err) ->
        if err
          console.log err
          res.redirect 'back'
        else
          console.log 'data save success!'
          #res.redirect '/timesheet/'# + date[0] + '-' + date[1]
          return