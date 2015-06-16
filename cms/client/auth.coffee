
Router.route '/login', ->
  @redirect '/admin' if 'admin' in Meteor.user().roles
  @render 'loginButtons'
