app = angular.module('songSync.controllers')

app.controller 'localUploadCtrl', ['$scope', 'ApiFactory', '$upload', 'AuthFactory', 'playlist', ($scope, ApiFactory, $upload, AuthFactory, playlist)->
  $scope.onFileSelect = ($files) ->
    _.each($files, (file) ->
      $scope.upload = $upload.upload({
        url: '/api/v1/songs'
        method: 'POST'
        data: {
          api_key: AuthFactory.currentUser().api_key,
          song: { name: file.name }
        }
        file: file
      }).progress( (e) ->
        console.log('percent: ' + parseInt(100.0 * e.loaded / e.total))
      ).success( (data) ->
        console.log("Success", data)
        playlist.songs.push(data)
      ).error( (data) ->
        console.log("Error", data)
      )
    )
]