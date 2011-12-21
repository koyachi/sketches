// https://github.com/libgit2/node-gitteh/blob/master/examples/display-commit-tree.js
var gitteh = require("gitteh"),
  path = require("path"),
  fs = require("fs");

var repository = gitteh.openRepository(path.join(__dirname, "..", ".git"));
var headRef = repository.getReference("HEAD");
headRef = headRef.resolve();

var commit = repository.getCommit(headRef.target);

var displayTreeContents = function(treeId, tabs) {
  var tree = repository.getTree(treeId);

  var tabStr = "";
  for (var i = 0; i < tabs; i++)
    tabStr += "  ";

  for (var i = 0, len = tree.entries.length; i < len; i++) {
    var entry = tree.entries[i];
    var line = tabStr;
    line += entry.name;

    if (entry.attributes == 16384) {
      line += "/";
      console.log(line);
      displayTreeContents(entry.id, tabs + 1);
    } else {
      console.log(line);
    }
  }

};

displayTreeContents(commit.tree, 1);
