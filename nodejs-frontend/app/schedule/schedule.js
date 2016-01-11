'use strict';

angular.module('myApp.schedule', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/schedule', {
    templateUrl: 'schedule/schedule.html',
    controller: 'ScheduleCtrl'
  });
}])

.controller('ScheduleCtrl', ['$scope', '$location', function($scope, $location) {

	$scope.mealsAll = $location.search().data;

}]);