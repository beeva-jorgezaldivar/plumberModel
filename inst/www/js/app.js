 angular.module('thisApp', ['ngMaterial', 'ngMessages', 'md.data.table'])

  .config(function($mdThemingProvider) {
    $mdThemingProvider.theme('default')
      .primaryPalette('grey')
      .accentPalette('amber');
  })

  .controller('thisAppCtrl', function($scope, $http){

    // Peticiones de información básica
    $http({method:'GET', url: '/modelInfo'}).then(function(response){
      $scope.modelInfo = response.data;
    });
    $http({method:'GET', url: '/inputFeatures'}).then(function(response){
      $scope.inputFeatures = response.data;
    });
    $http({method:'GET', url: '/trainResults'}).then(function(response){
      $scope.trainResults = response.data;
    });

    $scope.firstIfExists = function(obj){
      return (obj == null)? "Unknown": obj[0];
    };
  });
