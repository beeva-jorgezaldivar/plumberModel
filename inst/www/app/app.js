 angular.module(
    'plumberModelApp',
    ['ngMaterial', 'ngMessages', 'md.data.table', 'ngRoute', 'ngMessages']
  )

  .config(function($mdThemingProvider) {
    $mdThemingProvider.theme('default')
      .primaryPalette('grey')
      .accentPalette('indigo');
  })

  .config(function($routeProvider){
    $routeProvider
      .when("/", {
        templateUrl: "app/templates/model_summary.htm"
      })
      .when("/model_summary", {
        templateUrl: "app/templates/model_summary.htm"
      })
      .when("/model_predictions", {
        templateUrl: "app/templates/model_predictions.htm"
      });
  })

  /**
   *
   */
  .component("infoList", {
    templateUrl: "app/templates/model_summary/info_list.htm",
    bindings: {
      icon: '<',
      title: '<',
      list: '<'
    }
  })

  .controller('plumberModelCtrl', function($scope, $http){

    $scope.sections = {
      "Model summary": "/model_summary",
      "Try api": "/model_predictions"
    }

    // Peticiones de información básica
    $http({method:'GET', url: '/modelInfo'}).then(function(resp){
      var response = resp.data;
      $scope.modelInfo = {};
      $scope.hyperParameters = {};
      for (var key in response) {
        if (response.hasOwnProperty(key)) {
          if(key == "hyperParameters") $scope.hyperParameters = response[key][0]
          else $scope.modelInfo[key] = response[key][0]
        }
      }
    });

    $http({method:'GET', url: '/inputFeatures'}).then(function(response){
      $scope.inputFeatures = response.data;
      $scope.predictionRequestData = JSON.parse(JSON.stringify($scope.inputFeatures));
    });

    $http({method:'GET', url: '/trainResults'}).then(function(resp){
      $scope.trainResults = {};
      var response = resp.data;
      for(var i = 0; i < response.length; i++){
        $scope.trainResults[response[i]['Metric']] = response[i]['Value'];
      }
    });

    $scope.firstIfExists = function(obj){
      return (obj == null)? "Unknown": obj[0];
    };

    $scope.submitPrediction = function(){
      console.log($scope.predictionRequestData);
    }

  });

