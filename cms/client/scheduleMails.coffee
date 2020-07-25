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

    # calculate amount of mails that are sent before the event
    amountOfMails = _.filter(mails, (m2) -> m2.sendOffset >= 0).length;

    # sort by sendOffset
    mails = _.sortBy mails, (m) ->
      -m.sendOffset

    # replace variables
    _.each mails, (m) ->
      m.body = m.body.replace('{{speler}}', participant.name)
        .replace('{{datum}}', moment.utc(ev.date).format('D MMMM YYYY') + " om " + ev.time)
        .replace('{{adres}}', ev.address)
        .replace('{{aantalmails}}', amountOfMails - 1) # this variable is used in the first email, so minus that one.

    # add date
    counter = 0
    _.each mails, (m) ->
      counter++;

      # if the event is sooner than the offset, then send 1 mail every coming day
      wantedDate = moment.utc(ev.date).startOf('day').subtract(m.sendOffset, 'days');
      today = moment.utc().startOf('day').add(counter-1, 'days');
      if (wantedDate.isBefore(today))
        wantedDate = today;
      eventDate = moment.utc(ev.date).startOf('day');
      if (wantedDate.isAfter(eventDate) || wantedDate.isSame(eventDate, 'day'))
        wantedDate = eventDate.subtract(1, 'days');
      m.date = wantedDate;

      if (amountOfMails >= counter)
        m.subject = "Moorddiner spookdorp Doel - mail " + counter + " van " + amountOfMails
      else
        m.subject = "Hoe vond je moorddiner Spookdorp Doel gisteren?"

    mails

Template.schedule.events
  'click #scheduleMails': ->
    $('#scheduleMails').attr('disabled','disabled').text('Bezig met agenderen...')
    $('.scheduleMailForm').each (index, form) ->
      $form = $(form)
      mail =
        scheduledDate: moment.utc($('.mail-field-scheduledDate', $form).text(), 'D MMMM YYYY').toDate()
        recipient: $('.mail-field-recipient', $form).text()
        subject: $('.mail-field-subject', $form).text()
        body: $('.mail-field-body', $form).html()
      console.log 'scheduling', mail.scheduledDate, mail.subject, mail.recipient
      Outbox.insert(mail);
    Meteor.call('setEventScheduled', Iron.controller().getParams()._id);

Template.afMarkdown.events
  'keyup textarea': (evt) ->
    evt.target.style.overflow = 'hidden';
    evt.target.style.height = 0;
    evt.target.style.height = evt.target.scrollHeight + 'px';
  'click textarea': (evt) ->
    evt.target.style.overflow = 'hidden';
    evt.target.style.height = 0;
    evt.target.style.height = evt.target.scrollHeight + 'px';

