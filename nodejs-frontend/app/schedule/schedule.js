'use strict';

angular.module('myApp.schedule', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/schedule', {
    templateUrl: 'schedule/schedule.html',
    controller: 'ScheduleCtrl'
  });
}])

.controller('ScheduleCtrl', ['$scope', '$location', '$routeParams', function($scope, $location, $routeParams) {

	console.log('>>>>>>>> router params:', $routeParams);
	if($routeParams) $scope.mealsAll = $routeParams.data;
	else $scope.mealsAll = $location.search().data;

}]);