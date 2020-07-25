@Stories = new Meteor.Collection('stories');
@Characters = new Meteor.Collection('characters');
@Events = new Meteor.Collection('events');
@Outbox = new Meteor.Collection('outbox');

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
  # amount of days before the event itself to send this mail
  sendOffset:
    type: Number
    label: 'Aantal dagen vooraf dat het verstuurd wordt'
  onlyForAmountPeople:
    type: Number
    optional: true
    label: 'Alleen versturen als dit het aantal personen is'
  body:
    type: String
    label: 'Tekst'
    autoform:
      type: 'markdown'

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

ParticipantCharacter = new SimpleSchema
  name:
    type: String
    label: 'Naam'
    optional: true
  email:
    type: String
    label: 'E-mail adres'
    regEx: SimpleSchema.RegEx.Email
    optional: true
  character:
    type : String
    label: 'Personage'
    regEx: SimpleSchema.RegEx.Id
    autoform:
      options : () ->
        Characters.find().map (b) ->
          label : b.number + " - " + b.name, value : b._id

ContactDetails = new SimpleSchema
  name:
    type: String
    label: 'Naam'
  email:
    type: String
    label: 'E-mail adres'
    regEx: SimpleSchema.RegEx.Email

EventSchema = new SimpleSchema
  story:
    type : String
    label: 'Verhaal'
    regEx: SimpleSchema.RegEx.Id
    autoform:
      options : () ->
        Stories.find().map (b) ->
          label : b.name, value : b._id
  createdDate:
    type: Date
    label: 'Besteld op'
    autoValue: ->
      return new Date if @isInsert
      return $setOnInsert: new Date if @isUpsert
      @unset()
  scheduled:
    type: Boolean
    defaultValue: false
  date:
    type: Date
    label: 'Datum moorddiner'
    min: -> moment().toDate()
  time:
    type: String
    label: 'Tijdstip aanvang moorddiner'
  address:
    type: String
    label: 'Adres moorddiner'
  contact:
    type: ContactDetails
    label: 'Contactpersoon'
  comments:
    type: String
    optional: true
    label: 'Opmerkingen'
  amountOfParticipants:
    type: Number
    min: 8
    max: 12
    label: 'Aantal deelnemers'
  participants:
    type: [ParticipantCharacter]
    label: 'Deelnemers'
    optional: true

OutboxSchema = new SimpleSchema
  createdDate:
    type: Date
    label: 'Besteld op'
    autoValue: ->
      return new Date if @isInsert
      return $setOnInsert: new Date if @isUpsert
      @unset()
  scheduledDate:
    type: Date
    label: 'Wordt verzonden op'
  sentDate:
    type: Date
    label: 'Is verzonden op'
    optional: true
  recipient:
    type: String
    label: 'Ontvanger'
    regEx: SimpleSchema.RegEx.Email
  subject:
    type: String
    min: 10
    label: 'Onderwerp'
  body:
    type: String
    min: 10
    label: 'Inhoud'
    autoform:
      rows: 30


Stories.attachSchema(StorySchema)
Characters.attachSchema(CharacterSchema)
Events.attachSchema(EventSchema)
Outbox.attachSchema(OutboxSchema)
