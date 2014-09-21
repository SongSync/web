app = angular.module('songSync.controllers')

app.controller 'localUploadCtrl', ['$scope', 'ApiFactory', '$upload', 'AuthFactory', 'playlist', '$modalInstance', ($scope, ApiFactory, $upload, AuthFactory, playlist, $modalInstance)->
  $scope.messages = []
  $scope.songs = []
  $scope.counter = 0
  $scope.onFileSelect = ($files) ->
    _.each($files, (file, index) ->
      $scope.upload = $upload.upload({
        url: '/api/v1/songs'
        method: 'POST'
        data: {
          api_key: AuthFactory.currentUser().api_key
          song: { name: file.name }
          playlist_id: (playlist||{}).id
        }
        file: file
      }).success( (data) ->
        console.log("Success", data)
        $scope.progress = 100.0 * ($scope.counter+1)/$files.length
        if data.errors.length == 0
          $scope.messages.push("Successfully added: " + data.name)
          if playlist
            $scope.songs.push(data)
        else
          $scope.messages.push(data.errors.join(', '))
      ).error( (data) ->
        console.log("Error", data)
      ).then () ->
        $scope.counter += 1
        if $scope.counter == $files.length
          alert 'File upload complete!'
          $modalInstance.close($scope.songs)
    )
  $scope.cancel = () -> $modalInstance.dismiss()
]

app.controller 'AddToPlaylistCtrl',['$scope', 'AuthFactory', 'ApiFactory', 'songs', 'playlists', '$modalInstance', ($scope, AuthFactory, ApiFactory, songs, playlists, $modalInstance)->
  $scope.songs = songs
  $scope.playlists = playlists
  $scope.selected = { playlist: playlists[0] }
  $scope.cancel = () -> $modalInstance.dismiss()
  $scope.save = () ->
    ApiFactory.addToPlaylist(_.pluck(songs, 'id'), $scope.selected.playlist.id).then (playlist) ->
      $scope.selected.playlist = playlist
      $modalInstance.close()
]