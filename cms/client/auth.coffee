
Router.route '/login', ->
  @redirect '/admin' if Meteor.user() and 'admin' in Meteor.user().roles
  @render 'loginButtons'
