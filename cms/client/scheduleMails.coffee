Router.route 'schedule',
  path: AdminDashboard.path('/:collection/:_id/schedule')
  controller: 'AdminController'
  onAfterAction: ->
    Session.set 'admin_title', 'Plan een moorddiner'

Template.schedule.helpers
  'event': ->
    Events.findOne(Iron.controller().getParams()._id)

Template.participantMail.helpers
  characterName: (character) ->
    Characters.findOne(character).name

Template.participant.helpers
  mails: (ev) ->
    participant = this
    mails = Characters.findOne(participant.character).emails

    # remove the ones only meant for other amounts of people
    mails = _.filter mails, (m) ->
      return true if m.onlyForAmountPeople == ev.amountOfParticipants
      return true if not m.onlyForAmountPeople
      return false

    # calculate amount of mails - after filtering
    amountOfMails = _.filter(mails, (m2) -> m2.sendOffset >= 0).length;

    # sort by sendOffset
    mails = _.sortBy mails, (m) ->
      -m.sendOffset

    # replace variables
    _.each mails, (m) ->
      m.body = m.body.replace('{{speler}}', participant.name)
        .replace('{{datum}}', moment(ev.date).format('D MMMM YYYY') + " om " + ev.time)
        .replace('{{adres}}', ev.address)
        .replace('{{aantalmails}}', amountOfMails - 1)

    # add date
    counter = 0
    _.each mails, (m) ->
      counter++
      m.date = moment(ev.date).subtract(m.sendOffset, 'days')
      m.subject = "Moorddiner Doel - mail " + counter + " van " + amountOfMails

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

