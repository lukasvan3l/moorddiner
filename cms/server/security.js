
Events.allow({
  insert: function (userId, doc) {
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
    doc.createdDate = new Date();
    return true;
  }
});