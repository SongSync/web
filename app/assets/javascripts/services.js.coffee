app = angular.module('songSync.services', ['restangular'])

app.factory 'ApiFactory', ['Restangular', (Restangular) ->
  {
    getPlaylists: () ->
      Restangular.all('playlists').getList()
    getPlaylist: (id) ->
      Restangular.one('playlists', id).get()
    deletePlaylist: (id) ->
      Restangular.one('playlists', id).customDELETE()
    getSongs: () ->
      Restangular.all('songs').getList()
    getSong: (id) ->
      Restangular.one('songs', id).get()
    uploadSong: (song) ->
      song = {
        name: song.name,
        file: song.file.src
      }
      Restangular.all('songs').customPOST({song: song})
    deleteSong: (song_id) ->
      Restangular.one('songs', song_id).customDELETE()
  }
]
app.factory 'AuthFactory', ['Restangular', '$window', '$q', (Restangular, $window, $q) ->
  {
    login: (credentials) ->
      deferred = $q.defer()
      response = Restangular.all('users/sign_in').customPOST({user_login: credentials}).then (val) ->
        if val.success
          this._isLoggedIn = true
          this.current_user = val.current_user
          Restangular.setDefaultRequestParams({api_key: this.current_user.api_key})
          $window.sessionStorage.setItem 'current_user', JSON.stringify(this.current_user)
          deferred.resolve(this.current_user)
        else
          this.errors = [val.message]
          deferred.reject(this.errors)
      return deferred.promise
    logout: () ->
      authf = this
      Restangular.all('users/sign_out').customDELETE('', {user_login: {}}).then (val) ->
        authf.current_user = undefined
        $window.sessionStorage.removeItem 'current_user'
        authf._isLoggedIn = false
    isLoggedIn: () ->
      this._isLoggedIn ||= $window.sessionStorage.getItem 'current_user'
    currentUser: () ->
      this.current_user ||= angular.fromJson($window.sessionStorage.getItem('current_user'))
      if this.current_user
        Restangular.setDefaultRequestParams({api_key: this.current_user.api_key})
  }
]

app.directive "fileread", () ->
  return {
    scope: {
        fileread: "="
    },
    link: (scope, element, attributes) ->
      element.bind("change", (changeEvent) ->
        reader = new FileReader();
        reader.onload = (loadEvent) ->
          scope.$apply( () ->
            scope.fileread = loadEvent.target.result
          )
        file = changeEvent.target.files[0]
        if file.size < 15000000 # 15MB max PDF size
          reader.readAsDataURL(file)
        else
          angular.element(changeEvent.target).val('')
          alert 'File is too large. Please pick one less than 15MB.'
      )
  }

app.directive 'errors' , ()->
  restrict: 'A',
  scope: {
    errors: '='
  }
  template: '<div class="row" ng-show="errors"><div class="col-xs-12"><div class="alert alert-danger">' +
            '<ul><li ng-repeat="err in errors"> {{err}} </li></ul></div></div></div>'