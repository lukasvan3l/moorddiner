Router.route 'schedule',
  path: AdminDashboard.path('/:collection/:_id/schedule')
  controller: 'AdminController'
  onAfterAction: ->
    Session.set 'admin_title', 'Plan een moorddiner'