model = require("../models/user.js")
staff = model.staff
TITLE = "Profile"

exports.get = (req, res) ->
  res.render "profile",
    title: TITLE
    userId: 'ENG001'
    name: 'テスト太郎'
    phonetic: 'てすとたろう'
    birthDay: '1990/1/1'
    zip: '061111'
    address: '大阪府のどこか'
    phone: '09012345678'
    email: 'abc@com'
    url: 'https://github.com'
    note: 'テストプロフィールです'