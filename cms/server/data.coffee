Meteor.publish 'data', ->
  return [
      Stories.find({}, {sort: {name:1}}),
      Characters.find({}, {sort: {number:1}}),
      Events.find({}, {sort: {date:-1}})
    ];