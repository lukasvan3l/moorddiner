SyncedCron.add
  name: 'Send mails'
  schedule: (parser) ->
    parser.text 'at 10:00am every day'
  job: ->
    sendMails()

SyncedCron.start()

sendMails = ->
  outbox = Outbox.find({ sentDate: { $exists: false }, scheduledDate: { $lte: new Date() } }).fetch();
  console.log 'about to send', outbox.length, 'mails'
  _.each outbox, (i, mail) ->
    mailFields = {
      to: mail.recipient,
      from: 'hester@jouwmoorddinerthuis.nl',
      subject: mail.subject,
      html: mail.body
    }
    # Email.send(mailFields);
    console.log('sending mail:', mailFields);
    Outbox.update(mail._id, {$set: {sentDate: new Date()}})
