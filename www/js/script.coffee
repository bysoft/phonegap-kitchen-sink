glob = []
glob.triggerHash = ->
  console.log 'triggerHash'
  wlh = window.location.hash.replace('#','')
  id = wlh
  url = 'http://by.subsonic.org/rest/getMusicDirectory.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&id=' + id
  $.ajax
    url:url
    dataType:'jsonp'
    success: (d) ->
      #console.log d['subsonic-response']['directory']['child']
      $(d['subsonic-response']['directory']['child']).each ->
        #console.log this.title
        $('#tracks').append('<li><a href=#' + this.id + ' >' + this.title + '</a></li>').listview('refresh')
      glob.lastLevel = 1 if d['subsonic-response']['directory']['child']

glob.showFullDetail = ->
  #alert 'show full'
  $('#img-wrap').prepend '<b>foo</b>'


$('body').on 'click', '#tracks a,.musicFolder', (e) ->
  id = $(e.target).attr('id')
  url = 'http://by.subsonic.org/rest/getIndexes.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?&musicFolderId=' + id
  #console.log e.target.hash
  #console.log e.target.hash.length
  window.location.hash = e.target.hash
  glob.triggerHash() if e.target.hash.length > 3
  glob.showFullDetail() if glob.lastLevel

  $('#tracks').empty()

  # create listing for cat or track
  $.ajax
    url: url
    dataType:'jsonp'
    success: (d) ->
      $(d['subsonic-response']['indexes']['index']).each ->
        $('#tracks').append '<li><a data-recId=' + this.artist.id + ' href=#' + this.artist.id + ' >' + this.artist.name + '</a></li>' if this.artist.name != undefined
        #console.log d['subsonic-response']['indexes']['index']
        #console.log this.artist
        #console.log this
        #console.log this.artist.name if this.artist.name != undefined
        $('#tracks').listview 'refresh'


$(document).delegate 'body', 'pageinit', ->
  url = 'http://by.subsonic.org/rest/getMusicFolders.view?u=brian&p=home&v=1.1.0&c=myapp&f=jsonp&callback=?'
  $.ajax
    url:url
    dataType:'jsonp'
    success: (d) ->
      $(d['subsonic-response']['musicFolders']['musicFolder']).each ->
        #console.log this
        $('#tracks').append('<li><a id=' + this.id + ' class=musicFolder href=#' + this.id + ' >' + this.name + '</a></li>').listview('refresh')
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



