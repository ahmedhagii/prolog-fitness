'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'myApp.info',
  'myApp.schedule',
  'myApp.version',
  'angularSpinner'
])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/info'});
}])

.controller('RootCtrl', ['$location', '$scope', '$http', 'usSpinnerService', function($location, $scope, $http, usSpinnerService) {

	var activit_level;
	var purpose;

	// $scope.meals = [{number:1, name:'mealone'}, {number:2, items:[{name:'chicken', number:50}, {name:'beef', number:50}]},{number:3, items:[{name:'beef'}]}]
	var res = []

	$scope.beastify = function beastify() {

		usSpinnerService.spin('spinner-1');
		var activit_num;
		if(activit_level == "ALone") {
			activit_num = "1.2"
		}else if(activit_level == "ALtwo") {
			activit_num = "1.3"
		}else if(activit_level == "ALthree") {
			activit_num = "1.5"
		}else if(activit_level == "ALfour") {
			activit_num = "1.7"
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
		function callMe(Days, data) {
			if(Days == 0) {
	        	usSpinnerService.stop('spinner-1');
				$location.search({ data: allData});
				$location.path('/schedule');
				return;
			}
			$http({
	            url: '/submit-info',
	            method: "POST",
	            data: data,
	        }).then(function (response) {
	        	console.log(response.data);

	        	if(response.data.indexOf("Error") > -1 || response.data.indexOf("Time limit") > -1) {
	        		callMe(Days, data);
	        		alert(response.data);
	        	}else {
	        		callMe(Days-1, data);
	        		allData.push(response.data);
	        	}
	        }, function (response) {
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