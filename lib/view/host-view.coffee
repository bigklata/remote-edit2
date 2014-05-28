{$$, SelectListView} = require 'atom'

FilesView = require './files-view'
SftpHost = require '../model/sftp-host'
FtpHost = require '../model/ftp-host'

module.exports =
  class HostView extends SelectListView

    initialize: (@listOfItems = []) ->
      super
      @addClass('overlay from-top')
      @setItems(@listOfItems)

    attach: ->
      atom.workspaceView.append(this)
      @focusFilterEditor()

    getFilterKey: ->
      return "hostname"

    viewForItem: (item) ->
      $$ ->
        @li class: 'two-lines', =>
          @div class: 'primary-line', "#{item.username}@#{item.hostname}:#{item.port}:#{item.directory}"
          if item instanceof SftpHost
            @div class: "secondary-line", "Type: SFTP, Open files: #{item.localFiles.length}, Auth: " +
              if item.usePassword
                "password"
              else if item.usePrivateKey
                "key"
              else if item.useAgent
                "agent"
              else
                "undefined"
          else if item instanceof FtpHost
            @div class: "secondary-line", "Type: FTP, Open files: #{item.localFiles.length}"
          else
            @div class: "secondary-line", "Type: UNDEFINED"

    confirmed: (item) ->
      filesView = new FilesView(item)
      filesView.attach()