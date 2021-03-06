// Generated by CoffeeScript 1.6.3
var TITLE, TimeSheet, model;

TITLE = "TimeSheet";

model = require("../models/timesheet.js");

TimeSheet = model.timesheet;

/*
  画面表示処理
  ただ開くだけ～
*/


exports.get = function(req, res) {
  return res.render('timesheet', {
    title: TITLE
  });
};

/*
  タイムシートテーブル用のJSONデータ作成処理
  指定された「年/月」と「ユーザーID」に該当するものをデータベースから引っ張ってきて日付順にソートして渡す
*/


exports.findThisMonth = function(req, res) {
  var query;
  query = {
    user: req.session.user,
    yearMonth: req.params.yearMonth.replace(/-/, "/")
  };
  return TimeSheet.find(query).sort('day').execFind(function(err, result) {
    if (err) {
      return res.send({
        'err': err
      });
    } else {
      return res.json(result);
    }
  });
};

/*
  タイムシート更新処理
  1日分の勤怠データか削除フラグが飛んでくるので、データベースを更新する
*/


exports.post = function(req, res) {
  var date, query;
  date = req.body.day.split('/');
  query = {
    user: req.session.user,
    yearMonth: date[0] + '/' + date[1],
    day: date[2]
  };
  return TimeSheet.findOne(query, function(err, result) {
    var addQuery, addTimesheet, id;
    if (err) {
      console.log(err);
    }
    if (result) {
      if (result.author) {
        res.redirect('back');
        return;
      }
      id = result._id;
      TimeSheet.remove({
        _id: id
      }, function() {});
      if (req.body.delFlag) {
        res.redirect('back');
        return;
      }
    }
    addQuery = req.body;
    if (id) {
      addQuery['_id'] = id;
    }
    addQuery['user'] = req.session.user;
    addQuery['yearMonth'] = date[0] + '/' + date[1];
    addQuery['day'] = date[2];
    addTimesheet = new TimeSheet(addQuery);
    return addTimesheet.save(function(err) {
      if (err) {
        console.log(err);
      }
      return res.redirect('back');
    });
  });
};

/*
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
*/

