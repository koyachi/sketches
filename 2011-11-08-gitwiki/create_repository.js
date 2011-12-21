var gitteh = require("gitteh")
  , path = require("path")
  , fs = require("fs");

var createRepository = function(repositoryName) {
  var destination = path.join("/tmp", "notit_test__" + repositoryName);
  console.log(destination);
  fs.mkdirSync(destination, "777");
// - 新規作成時はopenRepositoryでなくinitRepository
// - 第二引数trueにすると.gitの中身だけ(== git repository)が指定パスに作成される。指定しないと普通にgitコマンドで生成したみたいな感じに。
//  var repo = gitteh.initRepository(destination, true);
  var repo = gitteh.initRepository(destination);
  return repo;
};

createRepository("foo");
