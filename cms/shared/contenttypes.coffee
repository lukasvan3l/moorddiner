@Stories = new Meteor.Collection('stories');

StorySchema = new SimpleSchema
  name:
    type: String
  minpeople:
    type: Number
  maxpeople:
    type: Number

Stories.attachSchema(StorySchema)
