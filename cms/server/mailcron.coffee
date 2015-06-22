SyncedCron.add
  name: 'Send mails'
  schedule: (parser) ->
    parser.recur().on(10).hour()
  job: ->
    sendMails()

# Router.route('/testmails', {
#   action: ->
#     sendMails()
#     @response.write('ok')
#     @response.end()
#   where: 'server'
# });

# Router.route('/resetmails', {
#   action: ->
#     Outbox.remove({})
#     Events.update {scheduled:true}, {$set:{scheduled:false}}, (err) ->
#       if err then console.error err

#     @response.write('ok')
#     @response.end()
#   where: 'server'
# });

SyncedCron.start()

sendMails = ->
  outbox = Outbox.find({ sentDate: { $exists: false }, scheduledDate: { $lte: new Date() } }).fetch();
  console.log 'about to send', outbox.length, 'mails'
  _.each outbox, (mail) ->
    mailFields = {
      to: mail.recipient,
      from: 'hester@jouwmoorddinerthuis.nl',
      subject: mail.subject,
      html: mail.body
    }
    Email.send(mailFields);
    console.log('sending mail', mailFields.subject, 'to', mailFields.to);
    Outbox.update(mail._id, {$set: {sentDate: new Date()}})
