glob = []


glob.longId = -># {{{
  # take long id and get album or folder info?

  console.log 'glob.longId'

# triggered on click when passed long id
glob.triggerHash = ->
  glob.idVal = window.location.hash.replace('#','')

  url = 'http://by.subsonic.org/rest/getMusicDirectory.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&id=' + glob.idVal
  $.ajax
    url:url
    dataType:'jsonp'
    success: (d) ->
      #console.log d['subsonic-response']['directory']['child']
      $(d['subsonic-response']['directory']['child']).each ->
        #console.log this.title
        console.log this
        $('#tracks').append('<li><a data-cover=' + this.coverArt + ' href=#' + this.id + ' >' + this.title + '</a></li>').listview('refresh')
      console.log 'd obj'
      console.log d
      #glob.lastLevel = 1 if d['subsonic-response']['directory']['child']

      # triggered if subsonic directory child is true or triggerHash() is fired
glob.showFullDetail = (id) ->
  query = 'getMusicDirectory'
  url = 'http://by.subsonic.org/rest/'+query+'.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&id=' + id
  $.ajax
    url:url
    dataType:'jsonp'
    success: (e) ->
      console.log 'watch'
      console.log e
      # api response rcvd change v1.2 - 1.8
      coverArtId = e['subsonic-response']['directory']['child'][0]['coverArt']
      songId = e['subsonic-response']['directory']['id']
      getSongCover = ->
        query = 'getSong'
        $.ajax
          url:url
          dataType:'jsonp'
          success: (d) ->
            console.log d
# }}}

      # get coverart id from data response of first item and create img with src
      $('#img-wrap').prepend('<img width=100% src=http://by.subsonic.org/rest/getCoverArt.view?u=brian&p=home&v=1.1&c=myapp&size=350&id=' + coverArtId + ' />')

$('body').on 'click', '#tracks a.sec', (e) ->
  trackId = e.target.hash
  window.location.hash = trackId
  $('#tracks').empty()

  glob.queryMethod = 'getMusicDirectory'
  glob.musicDirectoryId = window.location.hash.replace('#','')
  glob.url = 'http://by.subsonic.org/rest/' + glob.queryMethod + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&id=' + glob.musicDirectoryId
  $.ajax
    url: glob.url
    dataType:'jsonp'
    success: (d) ->
      console.log 'last'
      showFinal = (data) ->
        console.log 'show final'
        console.log data.id
        glob.queryMethod2 = 'stream'
        glob.url = 'http://by.subsonic.org/rest/' + glob.queryMethod2 + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&id=' + glob.musicDirectoryId
        streamUrl = glob.url
        $('#tracks').append('<a href=' + streamUrl + ' >play</a>')

      showFinal(d['subsonic-response']['directory']) if !d['subsonic-response']['directory']['child']
      thisName = d['subsonic-response']['directory'].name
      $('.ui-title').text(thisName)
      #$(d['subsonic-response']['indexes']['index']).each ->
      $(d['subsonic-response']['directory']['child']).each ->
        $('#tracks').append('<li><a class=sec href=#' + this.id + ' >' + this.title + '</a></li>').listview('refresh')

# {{{

#$('body').on 'click', '#tracks a,.musicFolder', (e) ->
  #console.log e.target
  #glob.musicFolderId = $(e.target).attr('id')
  #glob.queryMethod = 'getIndexes'
  #glob.url = 'http://by.subsonic.org/rest/' + glob.queryMethod + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&musicFolderId=' + glob.musicFolderId
  ## set page hash val to reflect new data id
  #window.location.hash = e.target.hash
  #glob.longId(glob.musicFolderId) if e.target.hash.length
  ##glob.longId(musicFolderId) if e.target.hash.length > 3
  ##glob.triggerHash() if e.target.hash.length > 3
  #assignedId = e.target.hash.replace('#','')
  ##glob.showFullDetail(assignedId) if glob.lastLevel
  #$('#tracks').empty()

  ## create listing for cat or track
  #$.ajax
    #url: glob.url
    #dataType:'jsonp'
    #success: (d) ->
      #$(d['subsonic-response']['indexes']['index']).each ->
        #$('#tracks').append '<li><a data-recId=' + this.artist.id + ' href=#' + this.artist.id + ' >' + this.artist.name + '</a></li>' if this.artist.name != undefined
        #$('#tracks').listview 'refresh'# }}}


        # load music folders on init
$(document).delegate 'body', 'pageinit', ->
  console.log 'get music folders'
  glob.queryMethod = 'getIndexes'
  glob.url = 'http://by.subsonic.org/rest/' + glob.queryMethod + '.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?'
  $.ajax
    url:glob.url
    dataType:'jsonp'
    success: (d) ->
      console.log 'page init'
      console.log d
      $(d['subsonic-response']['indexes']['index']).each ->
        #console.log "this['artist']"
        #console.log this['artist'].length
        #console.log this['artist']
        $(this['artist']).each ->
          #console.log 'this name'
          #console.log this.name
          #console.log this
          $('#tracks').append('<li><a class=sec href=#' + this.id + ' >' + this.name + '</a></li>').listview('refresh')
        #console.log 'loop through' if this['artist'].length > 1
        #console.log this['artist'].name if this['artist'].name != undefined
        #console.log 'loop obj' if this['artist'].name == undefined
        #loopObj = (thisArtist) ->
          ##console.log 'begin loopObj()'
          ##console.log thisArtist.name
        #thisArtist = this['artist']
        #loopObj(thisArtist) if this['artist'].name != undefined
      #$(d['subsonic-response']['musicFolders']['musicFolder']).each ->
        #$('#tracks').append('<li><a id=' + this.id + ' class=musicFolder href=#' + this.id + ' >' + this.name + '</a></li>').listview('refresh')
        #$('#tracks').listview('refresh')



dbFetch = ->
  $.ajax
    url:'/'
    success: (data) ->
      console.log data.length
      $(data).each ->
        console.log this.project_title
        $('body').append('<li>' + this.project_title + '</li>')
#dbFetch()

fetchMusicFolders = ->
  url = '/getMusicFolders'
  $.ajax
      url:url
      success: (dat) ->
          #console.log $.parseJSON(dat)
          obj = $.parseJSON(dat)
          musicFolderId = $('#music-folder').text()
          url = '/getIndexes/' + musicFolderId
          #console.log 'ajax success'
          #console.log obj['subsonic-response']['musicFolders']['musicFolder']

          $(obj['subsonic-response']['musicFolders']['musicFolder']).each ->
            $('#album').append '<li><a class=foldername href=/allMusic/' + this.id + ' >' + this.name + '</a></li>'
          $.ajax
            url:url
            success: (dat) ->
              jsonData = $.parseJSON(dat)
              #console.log jsonData['subsonic-response']['indexes']['index']
              $(jsonData['subsonic-response']['indexes']['index']).each ->
                #console.log this.artist if this.artist.name == undefined
                #console.log this.artist.length if this.artist.name == undefined
                $(this.artist).each ->
                  $('#wrap').append '<li><em><a data-id=' + this.id + ' href=/singleView/' + this.id + ' >' + this.name + '</a></em></li>'

                $('#wrap').append '<li><a data-id=' + this.artist.id + '  href=/singleView/' + this.artist.id + ' >' + this.artist.name + '</a></li>' if this.artist.name != undefined

#fetchMusicFolders()

handleMusicId = ->
  winPath = window.location.pathname.split('/')[2]
  $('body').append('<ul class=item-list />')
  $.ajax
    url: '/getMusicDir/' + winPath
    success: (d) ->
        jsonData = $.parseJSON(d)
        console.log jsonData['subsonic-response']['directory']
        console.log jsonData['subsonic-response']['directory']['child'][0]['album']
        window.hasAlbum = window.hasAlbum | {}
        window.hasAlbum = 1 if jsonData['subsonic-response']['directory']['child'][0]['album']
        console.log hasAlbum

        $(jsonData['subsonic-response']['directory']['child']).each ->
           #console.log this.coverArt
           imgUrl = 'http://by.subsonic.org/rest/getCoverArt.view?u=brian&p=home&v=1.1&c=myapp&f=json&size=100&id=' + this.coverArt
           window.counter = window.counter | 0
           $('body').prepend('<a href=' + this.id + ' ><img style=max-height:320px height=100px width=100px src=' + imgUrl + ' /></a>' + this.artist) if window.counter == 0 && window.hasAlbum
           $('body').prepend('<a href=' + this.id + ' ><img style=max-height:320px height=100px width=100px src=' + imgUrl + ' /></a>') if !window.hasAlbum
           $('ul.item-list').append('<li><a href=' + this.id + ' >' + this.title + '</a></li>')
           window.counter = 1

           #$('ul.item-list').append('<h3><a href=' + this.id + ' >' + this.title + '<img height=100% width=100% src=' + imgUrl + ' /></h3></li>')
           #window.thumbSrc = $('img').eq(0).attr('src')


#handleMusicId()

$ ->
  $('body').on 'click', '.foldername', (e) ->
    #e.preventDefault()
    console.log 'foo'



