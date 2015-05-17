@Stories = new Meteor.Collection('stories');
@Characters = new Meteor.Collection('characters');

StorySchema = new SimpleSchema
  name:
    type: String
    label: 'Naam'
  minpeople:
    type: Number
    label: 'Minimaal aantal personen'
  maxpeople:
    type: Number
    label: 'Maximaal aantal personen'

EmailSchema = new SimpleSchema
  body:
    type: String
    label: 'Tekst'
    autoform:
      type: 'markdown'
  # amount of days before the event itself to send this mail
  sendOffset:
    type: Number
    label: 'Aantal dagen vooraf dat het verstuurd wordt'
  onlyForAmountPeople:
    type: Number
    optional: true
    label: 'Alleen versturen als dit het aantal personen is'

CharacterSchema = new SimpleSchema
  story:
    type : String
    label: 'Verhaal'
    regEx: SimpleSchema.RegEx.Id
    autoform:
      options : () ->
        Stories.find().map (b) ->
          label : b.name, value : b._id
  number:
    type: Number
    min: 1
    max: 100
    label: 'Nummer van personage'
  name:
    type: String
    label: 'Naam'
  emails:
    type: [EmailSchema]
    label: 'E-mail berichten'

Stories.attachSchema(StorySchema)
Characters.attachSchema(CharacterSchema)
