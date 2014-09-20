app = angular.module('songSync.controllers', ['restangular'])

app.controller 'LoginCtrl',['$scope', 'AuthFactory', '$location', ($scope, AuthFactory, $location)->
  if AuthFactory.currentUser()
    $location.path('/player')
  $scope.login = () ->
    AuthFactory.login($scope.credentials).then ()->
      $location.path('/player')
    , (errors) ->
      $scope.credentials.errors = errors
]

app.controller 'NavCtrl',['$scope', 'AuthFactory', '$location', ($scope, AuthFactory, $location)->
  $scope.current_user = AuthFactory.currentUser()
  $scope.$watch () ->
    AuthFactory.currentUser()
  , () ->
    $scope.current_user = AuthFactory.currentUser()
  $scope.signOut = () ->
    AuthFactory.logout().then () ->
      $location.path('/home')

]

app.controller 'PlayerCtrl',['$scope', 'AuthFactory', 'ApiFactory', '$sce', '$rootScope', '$modal', '$q', ($scope, AuthFactory, ApiFactory, $sce, $rootScope, $modal, $q)->
  AuthFactory.currentUser()
  $scope.all_songs = {name: 'All Songs', id: '-1'}
  $scope.playing = false
  $scope.current_playlist = $scope.all_songs
  $scope.last_clicked_song = {id: -1}
  $scope.$on 'audio.time', (r, data) ->
    $scope.currentTime = data.currentTime
  $scope.$on 'audio.play', () -> $scope.playing = true
  $scope.$on 'audio.pause', () -> $scope.playing = false
  window.setInterval( () ->
    ApiFactory.updatePlayback($scope.current_song.id, $scope.current_playlist.id, $scope.currentTime) if $scope.playing
  , 5000)
  pp = ApiFactory.getPlayback().then (playback) ->
    $scope.playback = playback
  plp = ApiFactory.getPlaylists().then (playlists) ->
    $scope.playlists = playlists
    window.fixDisplay()

  sp = ApiFactory.getSongs().then (songs) ->
    $scope.all_songs.songs = songs
    window.fixDisplay()

  $q.all([pp, plp, sp]).then () ->
    playback = $scope.playback || {}
    if playback.current_playlist_id
      if playback.current_playlist_id != -1
        $scope.current_playlist = _.find $scope.playlists, (p) -> p.id == playback.current_playlist_id
      if playback.current_song_id
        $scope.current_song = _.find $scope.current_playlist.songs, (s)-> s.id == playback.current_song_id
        $scope.current_song.selected = true
        $scope.last_clicked_song = $scope.current_song
        if playback.current_timestamp
          $scope.currentTime = playback.current_timestamp
        song = $scope.current_song
        playlist = $scope.current_playlist
        $rootScope.$broadcast 'audio.set', $sce.trustAsResourceUrl(song.file_url), song, _.indexOf(playlist.songs, song)+1, playlist.songs.length, $scope.currentTime
        window.setTimeout () ->
          $rootScope.$broadcast 'audio.play'
        , 2000

  $scope.selectPlaylist = (playlist) ->
    if !playlist
      $scope.current_playlist = $scope.all_songs
    else
      $scope.current_playlist = playlist
  $scope.removePlaylist = (playlist) ->
    ApiFactory.deletePlaylist(playlist.id).then (val) ->
        if $scope.current_playlist.id == playlist.id
          $scope.current_playlist = $scope.all_songs
        $scope.playlists = _.without($scope.playlists, playlist)
  $scope.createPlaylist = (playlist) ->
    ApiFactory.createPlaylist(playlist).then (val) ->
      if val.errors.length == 0
        $scope.playlists.push val
        playlist.name = ''
      else
        alert val.errors.join(', ')

  $scope.clickSong = (song) ->
    if $scope.last_clicked_song.id == song.id
      $scope.playSong(_.indexOf($scope.current_playlist.songs, song))
    else
      $scope.last_clicked_song.selected = false
      $scope.last_clicked_song = song
      song.selected = true

  $scope.playSong = (index) ->
    $scope.current_song = $scope.current_playlist.songs[index]
    $scope.last_clicked_song.selected = false
    $scope.current_song.selected = true
    $scope.last_clicked_song = $scope.current_song
    $scope.current_song.src = $sce.trustAsResourceUrl($scope.current_song.file_url)
    $rootScope.$broadcast('audio.set', $scope.current_song.src, $scope.current_song, index + 1, $scope.current_playlist.songs.length)
    window.setTimeout () ->
      $rootScope.$broadcast('audio.play')
    , 0

  $scope.openAddToPlaylistModal = () ->

  $scope.rename = () ->
  $scope.remove = (song) ->
    song_id = song.id
    if $scope.current_playlist.id == 'all'
      ApiFactory.deleteSong(song_id)
      _.each $scope.playlists, (playlist) ->
        playlist.songs = _.reject playlist.songs, (song) -> song.id == song_id
      $scope.current_playlist.songs = _.without($scope.current_playlist.songs, song)

  $scope.localUpload = (playlist) ->
    modalInstance = $modal.open({
      templateUrl: '/partial/modal/local_upload'
      controller: 'localUploadCtrl'
      resolve: {
        playlist: () -> playlist
      }
    })
    modalInstance.result.then (result) ->
      console.log result
]