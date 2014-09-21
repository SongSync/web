app = angular.module('songSync.directives', [])

app.directive('audioPlayer', ($rootScope) ->
  {
    restrict: 'E',
    scope: {
      src: '='
    },
    controller: ($scope, $element) ->
      $scope.audio = angular.element('#theaudioplayer')[0]
      $scope.currentNum = 0;

      # tell others to give me my prev/next track (with audio.set message)
      $scope.next = ()-> $rootScope.$broadcast('audio.next')
      $scope.prev = ()-> $rootScope.$broadcast('audio.prev')

      # tell audio element to play/pause, you can also use $scope.audio.play() or $scope.audio.pause();
      $scope.playpause = ()->
        if $scope.audio.paused
          a = $scope.audio.play()
        else
          a = $scope.audio.pause()

      # listen for audio-element events, and broadcast stuff
      $scope.audio.addEventListener 'play', ()-> $rootScope.$broadcast('audio.play', this)
      $scope.audio.addEventListener 'pause', ()-> $rootScope.$broadcast('audio.pause', this)
      $scope.audio.addEventListener 'timeupdate', ()-> $rootScope.$broadcast('audio.time', this)
      $scope.audio.addEventListener 'ended', ()-> $rootScope.$broadcast('audio.ended', this); $scope.next()
      $scope.audio.addEventListener 'loadedmetadata', () ->
        if $scope.currentTime
          $scope.audio.currentTime = $scope.currentTime
          $scope.currentTime = undefined

      # set track & play it
      $rootScope.$on 'audio.set', (r, file, info, currentNum, totalNum, start_time) ->
          playing = !$scope.audio.paused
          $scope.audio.src = file
          $scope.audio.volume = 0.1
          $scope.currentTime = start_time
          if playing
            a =  $scope.audio.play()
          else
            a = $scope.audio.pause()
          $scope.info = info
          $scope.currentNum = currentNum
          $scope.totalNum = totalNum
      $rootScope.$on 'audio.play', () ->
        a = $scope.audio.play()
      $rootScope.$on 'audio.settime', (r, time) ->
        $scope.currentTime = time
        console.log("Set time:", time)

      # update display of things - makes time-scrub work
      setInterval ()->
        $scope.$apply()
      , 500
    templateUrl: '/partial/component.html'
  }
)