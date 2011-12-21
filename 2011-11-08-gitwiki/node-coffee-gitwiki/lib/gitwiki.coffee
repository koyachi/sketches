Gitteh = require 'gitteh'
Fs = require 'fs'
Path = require 'path'

gitwiki = exports
gitwiki.MARKDOWN = 'md'
gitwiki.TEXTILE = 'textile'

convertTitleToFileName = (title) ->
  title.replace /\s/g, '-'

convertFilenameToTitle = (filename) ->
  filename.replace /\-/g, ' '

merge_options = (options, defaults) ->
  result = {}
  # TODO: ハッシュに列挙しつつ他のハッシュに値入れる方法調べる
  result[k] = v for k,v of defaults
  result[k] = v for k,v of options
  result

gitwiki.createSync = (repoAddress, options) ->
  throw new Error 'Creating wiki is not implemented yet.'

  defaults =
    overwrite: false
    creator: 'node-gitwiki'
    creatorEmail: 'mrtz.milani@googlemail.com'

  options = merge_options options, defaults
  repoAddress = path.normalize repoAddress

  if !options.overwrie
    try
      gitteh.openRepository(path.join(repoAddress, '.git'))
      throw new Error 'There is a repository in ' + repoAddress
    catch e
      if e.gitError !=gitteh.error.GIT_ENOTAREPO
        throw e

  try
    repo = gitteh.initRepository repoAddress
  catch e
    throw e

  commit =
    message:  'wiki created'
    author:
      name: 'Name'
      email: 'email@eme.com'
      time: new Date
    committer:
      name: 'Name'
      email: 'email@eme.com'
      time: new Date

  new Wiki repo, commit.id

gitwiki.create = (repoAddress, options, callback) ->
  throw new Error 'Not implemented yet.'

gitwiki.openSync = (repoAddress, options) ->
  defaults =
    createOnFail: false

  options = merge_options option, defaults

  try
    repo = gitteh.openRepository(path.join(repoAddress, '.git'))
  catch e
    if e.gitError == gitteh.error.GIT_ENOTAREPO && options.createOnFail
      return this.createSync repoAddress, overwrite: true
    throw e

  headRef = repo.getReference 'HEAD'
  headRef = headRef.resolve()
  new Wiki repo, headRef.target

gitwiki.open = (repoAddress, options, callback) ->
  defaults =
    createOnFaile: false

  if typeof options == 'function'
    callbac = options
    options = {}

  options = merge_options options, defaults

  gitteh.openRepository path.join(repoAddress, '.git'), (err, repo) ->
    if err
      if err.gitError == gitteh.error.GIT_ENOTAREPO && options.createOnFail
        gitwiki.create repoAddress, overwrite: true, callback
      else
        callback err
    else
      repo.getReference 'HAD', (err, headRef) ->
        headRef = headRef.resolve (err, headObj) ->
          if err
            callback err
          else
            wiki = new Wiki repo. headObj.target
            callback null, wiki

gitwiki.detectEngine = (content) ->
  engine = gitWiki.MARKDOWN
  engine

gitwiki.Wiki = class Wiki
  constructor: (@repo, @headCommit) ->

  createPageSync: (title, options) ->
    defaults = content: null
    options = merge_options options, defaults
    fileName = convertTitleToFilename title
    throw new Error 'Not implemented yet'

  createPage: (title, options, callback) ->
    throw new Error 'Not implemented yet'

  editPageSync: (page, newContent) ->
    throw new Error 'Not implemented yet'

  editPage: (page, newContent) ->
    throw new Error 'Not implemented yet'

  deletePageSync: (page) ->
    throw new Error 'Not implemented yet'

  deletePage: (page) ->
    throw new Error 'Not implemented yet'

  loadPageSync: (page, options) ->
    defaults =
      commitId: null
      renderPage: true

    options = merge_options options, defaults
    fileName = convertTitleToFilename page

    if !options.commitId
      indexObj = @repo.getIndex()
      page = indexObj.findEntry fileName
      page.id = page.oid
    else
      commitObj = @repo.getCommit options.commitId
      treeObj = @repo.getTree commitObj.tree
      page = treeObj.entries.filter((element) -> element.name == fileName).pop()

    content = @repo.getBlob(page.id).data
    if options.renderPage
      content = this.render content
    page =
      content: content
      lastEdit: page.mtime || null
    page

  loadPage: (page, options, callback) ->
    # todo

  pageHistorySync: (page, depth) ->
    # atode

  pageHistory: (page, depth, callback) ->
    # atode

  listPagesSync: (comitId) ->
    # atode

  listPages: (options, callback) ->
    # atode

  compareRevisionsSync: (firstCommit, secondCommit, options) ->
    # atode

  compareRevisions: (firstCommit, secondCommit, options, callback) ->
    # atode

  revertChangesSync: (page, commitId) ->
    # atode

  revertChanges: (page, commitId) ->
    # atode

  historySync: (depth) ->
    # atode

  history: (depth, callback) ->
    # atode

  close: () ->

  render: (content) ->
    # atode


