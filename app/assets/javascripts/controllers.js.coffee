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

  $scope.playSong = (index) ->
    $scope.current_song = $scope.current_playlist.songs[index]
    $scope.current_song.src = $sce.trustAsResourceUrl($scope.current_song.file_url)
    $rootScope.$broadcast('audio.set', $scope.current_song.src, $scope.current_song, index + 1, $scope.current_playlist.songs.length)
    window.setTimeout () ->
      $rootScope.$broadcast('audio.play')
    , 0
]