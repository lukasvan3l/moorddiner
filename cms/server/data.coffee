Meteor.publish 'data', ->
  return [
      Stories.find(),
      Characters.find()
    ];