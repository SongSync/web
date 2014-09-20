app = angular.module('songSync.controllers', ['restangular'])

app.controller 'LoginCtrl',['$scope', ($scope)->
  $scope.hi = 'Hello'
]