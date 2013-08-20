TITLE = "TimeSheet"

model = require("../models/timesheet.js")
TimeSheet = model.timesheet

###
  画面表示処理
  ただ開くだけ～
###
exports.get = (req, res) ->
  res.render 'timesheet',
    title: TITLE

###
  タイムシートテーブル用のJSONデータ作成処理
  指定された「年/月」と「ユーザーID」に該当するものをデータベースから引っ張ってきて日付順にソートして渡す
###
exports.findThisMonth = (req, res) ->
  query =
    user: req.session.user
    yearMonth: (req.params.yearMonth.replace /-/, "/")
  TimeSheet.find(query).sort('day').execFind (err, result) ->
    if err
      res.send 'err': err
    else
      res.json result

###
  タイムシート更新処理
  1日分の勤怠データか削除フラグが飛んでくるので、データベースを更新する
###
exports.post = (req, res) ->
  date = req.body.day.split '/'
  query =
    user: req.session.user
    yearMonth : date[0] + '/' + date[1]
    day: date[2]

  TimeSheet.findOne query, (err, result) ->
    console.log err if err
    if result
      if result.author #承認済みの場合は中断（本来は通らないはず）
        res.redirect 'back'
        return

      id = result._id

      TimeSheet.remove _id: id, ->

      if req.body.delFlag #削除フラグが立っていればデータの追加は行わない
        res.redirect 'back'
        return
    addQuery = req.body
    addQuery['_id'] = id if id
    addQuery['user'] = req.session.user
    addQuery['yearMonth'] = date[0] + '/' + date[1]
    addQuery['day'] = date[2]

    addTimesheet = new TimeSheet addQuery
    addTimesheet.save (err) ->
      console.log err if err
      res.redirect 'back'

###
  2013/8/2 一旦完成
  現状レコード更新時の動作が
  ブラウザ        サーバ     DB
          ①post→
                        ②更新→
          ←res③
          ④get→
                        ⑤抽出→
          ←json⑥

  となっているので、
  ②→⑤→⑥としてしまいたい
###