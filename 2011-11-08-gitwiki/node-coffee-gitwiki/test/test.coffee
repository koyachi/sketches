#!/usr/bin/env coffee
GitWiki = require '../lib/gitwiki'
REPO_PATH = '../examples/wiki'

console.log 'Opening wiki repository'
wiki = GitWiki.openSync REPO_PATH
console.log 'Wiki opened successfully'

console.log 'Page listing: '
console.log(wiki.listPagesSync())

console.log 'Load page contents (FAQ):'
console.log(wiki.loadPageSync('FAQ'))

console.log 'History of "Installation Guide" page (5 most recent changes): '
console.log(wiki.pageHistorySync('installation-guide', 5))

console.log 'Wiki History (5 most recent changes): '
console.log(wiki.historySync(5))

console.log 'Compare revisions (two last commits): '
console.log(wiki.compareRevisionsSync('3e59fb20f25dd4d3075628145355a2f0444f07a9',
  '98f922bf026b550eb0dc4794fde81694b281ea82',
  withContents: true))
