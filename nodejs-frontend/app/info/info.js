'use strict';

angular.module('myApp.info', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/info', {
    templateUrl: 'info/info.html',
    controller: 'RootCtrl'
  });
}])

.controller('InfoCtrl', ['$location', '$scope', '$http', function($location, $scope, $http) {


	$scope.beastify = function beastify() {
		console.log("hi");
		$location.path('/schedule');
	}


	var activit_level;
	var purpose;

	$("input:checkbox").on('click', function() {
	  var $box = $(this);
	  if ($box.is(":checked")) {
	    if($box.attr('name') == "AL") {
	    	activit_level = $box.attr('id');
	    }else {
	    	purpose = $box.attr('id');
	    }
	    console.log(activit_level + " " + purpose);
	    var group = "input:checkbox[name='" + $box.attr("name") + "']";
	  	console.log(group);
	    $(group).prop("checked", false);
	    $box.prop("checked", true);
	  } else {
	  	if($box.attr('name') == "AL") {
	    	activit_level = null;
	    }else {
	    	purpose = null;
	    }
	    $box.prop("checked", false);
	  }
	});

}]);