// Generated by CoffeeScript 1.6.3
var ReimbursableSchema, db, domain, mongoose, url;

domain = (process.env.NODE_ENV === "production" ? "192.168.23.1" : "localhost");

mongoose = require("mongoose");

url = "mongodb://" + domain + "/reimbursable";

db = mongoose.createConnection(url, function(err) {
  if (err) {
    return console.log("Error connected: " + url + " - " + err);
  } else {
    return console.log("Success connected: " + url);
  }
});

ReimbursableSchema = new mongoose.Schema({
  user: String
}, {
  collection: 'reimbursable'
});