'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'myApp.info',
  'myApp.schedule',
  'angularSpinner'
])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/info'});
}])

.controller('RootCtrl', ['$location', '$scope', '$http', '$routeParams', 'usSpinnerService', function($location, $scope, $http, $routeParams, usSpinnerService) {

	var activit_level=null;
	var purpose=null;
	$scope.currentDay = 0;
	
	var res = [];
	$scope.mealsNumber=null;
	$scope.beastify = function beastify() {

		if($scope.mealsNumber == null || $scope.mealsNumber == "" || $scope.weight==null || $scope.weight == "" || $scope.fatPerc == null || $scope.fatPerc == ""
			|| purpose == null || activit_level == null || !($("input:checkbox[id='Bulking']")[0].checked || $("input:checkbox[id='Losing']")[0].checked)) {
			console.log($scope.mealsNumber);
			console.log($scope.weight);
			console.log($scope.fatPerc);
			console.log(activit_level);
			alert("all fields must be filled");
			return;
		}

		usSpinnerService.spin('spinner-1');
		$scope.loading = true;
		var activit_num;
		if(activit_level == "ALone") {
			activit_num = "1.3"
		}else if(activit_level == "ALtwo") {
			activit_num = "1.5"
		}else if(activit_level == "ALthree") {
			activit_num = "1.6"
		}else if(activit_level == "ALfour") {
			activit_num = "1.8"
		}else if(activit_level == "ALfive") {
			activit_num = "1.9"
		}
		var data = {
			al: activit_num,
			weight: $scope.weight,
			fat: $scope.fatPerc,
			bulking: $("input:checkbox[id='Bulking']")[0].checked,
			meals: $scope.mealsNumber
		}

		callMe(5, data);
		var allData = []
		var failedAttempts=0;
		function callMe(Days, data) {

			console.log('calling day: ' + Days);
			console.debug(data);
			if(Days == 0) {
	        	usSpinnerService.stop('spinner-1');
	        	$scope.loading = false;
				console.log('all data');
				console.debug( allData);
				for(var day of allData) {
					for(var meal of day) {
						meal[0] = Math.round(meal[0] / 100000);
						meal[1] = Math.round(meal[1] / 100000);
						meal[2] = Math.round(meal[2] / 100000);
						meal[3] = Math.round(meal[3] / 100000);
					}
				}
				$location.search({ data: allData});
				$location.path('/schedule');
				return;
			}
			$scope.currentDay = (6 - Days);
			$http({
	            url: '/submit-info',
	            method: "POST",
	            data: data,
	        }).then(function (response) {
	        	console.debug(response.data);
	        	if(response.data == undefined || response.data.indexOf("Error") > -1 || response.data.indexOf("Time limit") > -1) {
		        	failedAttempts += 1;
		        	if(failedAttempts > 3) {
		        		callMe(Days-1, data);
		        	}else {
		        		callMe(Days, data);
		        	}
	        		// alert(response.data);
	        	}else {
	        		failedAttempts = 0;
	        		allData.push(response.data);
	        		callMe(Days-1, data);
	        	}
	        }, function (response) {
			console.log('failed :((');
			console.debug(response);
	            // onFailureFunction(response)
	        });
		}
	};




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
