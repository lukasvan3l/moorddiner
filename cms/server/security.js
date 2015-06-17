
Events.allow({
  insert: function (userId, doc) {
    return true;
  }
});

Outbox.allow({
  insert: function (userId, doc) {
    var user = Meteor.users.findOne(userId);
    return user && user.roles.indexOf('admin') >= 0;
  }
});

Meteor.methods({
  setEventScheduled: function(eventId) {
    console.log('Done scheduling', eventId);
    Events.update(eventId, {$set:{scheduled:true}}, function(err) {
      if (err) console.error(err);
    });
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
