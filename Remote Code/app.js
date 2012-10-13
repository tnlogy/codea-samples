var express = require('express')
var app = express()
var fs = require('fs')
var xml2js = require('xml2js')
var parser = new xml2js.Parser()

var codePath = "luaCode/"

app.get('/', function(req, res) {
  var infoPlist = fs.readFileSync(codePath + "Info.plist")

  parser.parseString(infoPlist, function (err, result) {
      var files = result.plist.dict[0].array.map(function (x) { return x.string; })[0];
      var code = "";
      files.forEach(function (file) {
        code += "\n-- " + file + ".lua\n"
        code += fs.readFileSync(codePath + file + ".lua", "utf8");        
      });

      res.set('Content-Type', 'text');
      res.send(code);
      console.log("Sending code")
  });

});

app.listen(3000);

var ip = require("os").networkInterfaces().en1[1].address;
console.log("Server running on " + ip + ":3000")