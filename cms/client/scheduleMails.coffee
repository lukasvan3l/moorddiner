Router.route 'schedule',
  path: AdminDashboard.path('/:collection/:_id/schedule')
  controller: 'AdminController'
  onAfterAction: ->
    Session.set 'admin_title', 'Plan een moorddiner'

Template.schedule.helpers
  'event': ->
    Events.findOne(Iron.controller().getParams()._id)

Template.participant.helpers
  mails: (ev) ->
    participant = this
    mails = Characters.findOne(participant.character).emails

    # remove the ones only meant for other amounts of people
    mails = _.filter mails, (m) ->
      return true if m.onlyForAmountPeople == ev.amountOfParticipants
      return true if not m.onlyForAmountPeople
      return false

    # sort by sendOffset
    mails = _.sortBy mails, (m) ->
      -m.sendOffset

    # replace variables
    _.each mails, (m) ->
      m.body = m.body.replace('{{speler}}', participant.email.split('@')[0])
        .replace('{{datum}}', moment(ev.date).format('D MMM YYYY') + " om " + ev.time)
        .replace('{{adres}}', ev.address)
        .replace('{{aantalmails}}', _.filter(mails, (m2) -> m2.sendOffset >= 0).length - 1)

    # add date
    _.each mails, (m) ->
      m.date = moment(ev.date).subtract(m.sendOffset, 'days')

    mails


Template.afMarkdown.events
  'keyup textarea': (evt) ->
    evt.target.style.overflow = 'hidden';
    evt.target.style.height = 0;
    evt.target.style.height = evt.target.scrollHeight + 'px';
  'click textarea': (evt) ->
    evt.target.style.overflow = 'hidden';
    evt.target.style.height = 0;
    evt.target.style.height = evt.target.scrollHeight + 'px';

