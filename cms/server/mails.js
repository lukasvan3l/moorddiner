
Events.after.insert(function(userId, doc) {
  var text = 'Ha Hester!\n\nGefeliciteerd, je hebt net een moorddiner verkocht :)\n\n';
  text += 'Zie http://moorddiner.3l.nl/admin/Events/' + this._id + '/edit';
  text += '\n\nGroet,\nMoi';

  Email.send({
    to: 'hester@3l.nl',
    from: 'moorddiner@3l.nl',
    subject: 'Moorddiner voor ' + doc.contact.name,
    text: text
  });
});


Events.after.insert(function(userId, doc) {
  var text = 'Beste ' + doc.contact.name + ',';
  text += '\n\nGefeliciteerd, jij gaat binnenkort een Moorddiner beleven! En wel op ' + moment(doc.date).format('D MMM YYYY') + ' om ' + doc.time + ', ' + doc.address + '.';
  text += '\n\nIndien je dit nog niet gedaan hebt, maak a.u.b. &euro; ' + (doc.amountOfParticipants * pricePerPerson).toFixed(2) + ' over naar rekening ' + ibanHester + ' t.n.v. Hester van Deutekom.';
  text += ' Pas dan is de reservering definitief.';
  text += '\n\nKlopt er iets niet of heb je vragen? Neem dan contact met mij op.';
  text += '\n\nGroet,\nHester van Deutekom\n\nhester@3l.nl | 06-15053990';

  Email.send({
    to: doc.contact.email,
    from: 'moorddiner@3l.nl',
    subject: 'Bevestiging Moorddiner \'Doel\'',
    text: text
  });
});

