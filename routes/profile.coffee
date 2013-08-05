TITLE = "Profile"

model = require("../models/user.js")
staff = model.staff

exports.get = (req, res) ->
  query =
    userId: req.session.user
  staff.findOne query, (err, result) ->
    console.log err if err
    if result
      res.render "profile",
        title: TITLE
        info:
          userId: result.userId
          name: result.name
          phonetic: result.phonetic
          birthDay: result.birthDay
          zip: result.zip
          address: result.address
          phone: result.phone
          email: result.email
          url: result.url
          note: result.note
        career:[
          company: 'A社'
          start: '2000/01/01'
          end: '2005/12/31'
        ]

        skill:[
          name: 'java'
          old: 5
        ]

        license:[
          name: 'it'
          get: '2010/01/01'
        ]


exports.infoUpdata = (req, res) ->
  query =
    userId: req.userId

  res.redirect 'back'