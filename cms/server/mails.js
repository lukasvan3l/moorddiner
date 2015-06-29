
SSR.compileTemplate('mailConfirmation', Assets.getText('mail-confirmation.html'));
SSR.compileTemplate('mailCustomer', Assets.getText('mail-customer.html'));
SSR.compileTemplate('mailDemo', Assets.getText('mail-demo.html'));

Events.after.insert(function(userId, doc) {
  var text = SSR.render("mailCustomer", {
    url: 'http://www.jouwmoorddinerthuis.nl/admin/Events/' + doc._id + '/edit'
  });

  Email.send({
    to: 'hester@jouwmoorddinerthuis.nl',
    from: 'lukas@jouwmoorddinerthuis.nl',
    subject: 'Moorddiner voor ' + doc.contact.name,
    html: text
  });
});


Events.after.insert(function(userId, doc) {
  var text = SSR.render("mailConfirmation", {
    recipient: doc.contact.name,
    price: (doc.amountOfParticipants * pricePerPerson).toFixed(2),
    ibanHester: ibanHester,
    date: moment(doc.date).format('D MMMM YYYY'),
    time: doc.time,
    address: doc.address
  });

  Email.send({
    to: doc.contact.email,
    from: 'hester@jouwmoorddinerthuis.nl',
    subject: 'Bevestiging Moorddiner \'Doel\'',
    html: text
  });
});

Meteor.methods({
  sendDemoMail: function(email, name) {
    var text = SSR.render("mailDemo", {
      speler: name
    });
    console.log('sending to', email, name);
    Email.send({
      to: email,
      cc: 'hester@jouwmoorddinerthuis.nl',
      from: 'hester@jouwmoorddinerthuis.nl',
      subject: 'Voorbeeld personage Moorddiner \'Doel\'',
      html: text
    });
  }
});
