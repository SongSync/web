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

app.controller 'PlayerCtrl',['$scope', 'AuthFactory', 'ApiFactory', '$sce', '$rootScope', ($scope, AuthFactory, ApiFactory, $sce, $rootScope)->
  AuthFactory.currentUser()
  $scope.all_songs = {name: 'All Songs', id: 'all'}
  $scope.current_playlist = $scope.all_songs
  ApiFactory.getPlaylists().then (playlists) ->
    $scope.playlists = playlists
    window.fixDisplay()

  ApiFactory.getSongs().then (songs) ->
    $scope.all_songs.songs = songs
    window.fixDisplay()

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
      else
        alert val.errors.join(', ')

  $scope.playSong = (index) ->
    $scope.current_song = $scope.current_playlist.songs[index]
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
]