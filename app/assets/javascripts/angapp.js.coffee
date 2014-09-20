app = angular.module('songSync', ['songSync.controllers',
  'songSync.services', 'restangular', 'ui.bootstrap', 'ngRoute'])

window.updateActive = (path) ->
  $('.nav > li').each (i, e) ->
    route = $(this).attr 'route'
    if path.match(route) && route
      $(this).addClass 'active'
    else
      $(this).removeClass 'active'

app.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/login', {templateUrl: '/angular/partial?name=dashboard.html', controller: 'LoginCtrl' }
  $routeProvider.when '/player', {templateUrl: '/angular/partial?name=profile.html', controller: 'PlayerCtrl' }
  $routeProvider.otherwise {redirectTo: '/login'}
]).
config(['RestangularProvider', '$httpProvider', (RestangularProvider, $httpProvider) ->
  RestangularProvider.setBaseUrl('/api/v1')
]).
run(['$rootScope', '$location', 'AuthFactory'
  ($rootScope, $location, AuthFactory) ->
    routesThatDontRequireAuth = ['/login'];

    routeClean = (route) ->
      return _.find(routesThatDontRequireAuth,
        (noAuthRoute) ->
          return _.str.startsWith(route, noAuthRoute);
        )

    $rootScope.$on '$routeChangeStart',
      (event, next, current) ->
        if (!routeClean($location.url()) && !AuthFactory.isLoggedIn())
          AuthFactory.friendlyRedirect = $location.path()
          $location.path('/login');
        window.updateActive $location.path()
        $rootScope.flash = undefined
]).
run(['Restangular', (Restangular) ->
  Restangular.extendModel('orders', (model) ->
    model.mySave = () ->
      items = _.map(this.order_items, (item, index) ->
        item = _.pick(item, ['id', 'quantity', 'options', 'client_price', 'notes',
                             'shipping_location', 'artworks', 'product', 'deleted'])
        item.product_id = item.product.id
        item.artworks = _.pluck(item.artworks, 'id')
        item.appearance_id = index
        _.omit(item, ['product'])
      )
      this.client ||= {}
      this.billing ||= {}
      params = {
        order: {
          name: this.name
          client_id: this.client.id
        },
        new_items: _.filter(items, (item) -> item.id == 'new'),
        deleted_items: _.pluck(_.filter(items, (item) -> item.deleted ), 'id'),
        existing_items: _.filter(items, (item) -> item.id != 'new' && item.deleted != true)
      }
      if this.signed_sales_order
        params.order.signed_sales_order = this.signed_sales_order.src
      return this.customPUT(params)
    return model
  )

  Restangular.extendModel 'organizations', (model) ->
    model.mySave = () ->
      params = _.pick this, ['name', 'address_1', 'address_2', 'city', 'province', 'postal', 'primary_phone', 'contact_name', 'contact_email', 'website']
      if (this.logo || {}).src
        params.logo = this.logo.src
      return this.customPUT(organization: params)
    return model

  Restangular.extendModel('order_items', (model) ->
    model.net_total_price = () ->
      this.quantity * this.net_price
    model.client_total_price = () ->
      this.quantity * this.client_price
    return model
  )
]);
