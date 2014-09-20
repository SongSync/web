app = angular.module('songSync.controllers', ['restangular'])

app.controller 'LoginCtrl',['$scope', 'AuthFactory', ($scope, AuthFactory)->
  $scope.login = () ->
    AuthFactory.login($scope.credentials).then undefined, (obj) ->
      $scope.credentials.errors = obj
]