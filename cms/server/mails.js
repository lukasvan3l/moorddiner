
SSR.compileTemplate('mailConfirmation', Assets.getText('mail-confirmation.html'));
SSR.compileTemplate('mailCustomer', Assets.getText('mail-customer.html'));

Events.after.insert(function(userId, doc) {
  var text = SSR.render("mailCustomer", {
    url: 'http://moorddiner.3l.nl/admin/Events/' + doc._id + '/edit'
  });

  Email.send({
    to: 'hester@3l.nl',
    from: 'moorddiner@3l.nl',
    subject: 'Moorddiner voor ' + doc.contact.name,
    text: text
  });
});


Events.after.insert(function(userId, doc) {
  var text = SSR.render("mailConfirmation", {
    recipient: doc.contact.name,
    price: (doc.amountOfParticipants * pricePerPerson).toFixed(2),
    ibanHester: ibanHester,
    date: moment(doc.date).format('D MMM YYYY'),
    time: doc.time,
    address: doc.address
  });

  Email.send({
    to: doc.contact.email,
    from: 'moorddiner@3l.nl',
    subject: 'Bevestiging Moorddiner \'Doel\'',
    text: text
  });
});

