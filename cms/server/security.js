
Events.allow({
  insert: function (userId, doc) {
    return true;
  }
});

Events.before.insert(function(userId, doc) {
  doc.createdDate = new Date();

  var story = Stories.findOne(doc.story);
  if (!doc.participants && doc.amountOfParticipants > 0) {
    doc.participants = [];
    for (var i = 1; i <= doc.amountOfParticipants; i++) {
      var character = Characters.findOne({story: story._id, number: i});
      doc.participants.push({
        email: '',
        character: character ? character._id : ""
      });
    }
  }
});

Events.after.insert(function(userId, doc) {

  var text = 'Ha Hester!\n\nJe hebt net een moorddiner verkocht :)\n\n';



  text += 'Zie ook http://moorddiner.3l.nl/admin/Events/' + this._id + '/edit';
  text += '\n\nGroet, \nMoi';

  Email.send({
    to: 'hester@3l.nl',
    from: 'moorddiner@3l.nl',
    subject: 'Moorddiner voor ' + doc.contact.name,
    text: text
  });
});

