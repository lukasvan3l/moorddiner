@pricePerPerson = 7.50;
@ibanHester = 'NL43ABNA0572899149';

@AdminConfig =
  name: 'Moorddiner'
  nonAdminRedirectRoute: 'login'
  collections:
    Outbox:
      label: 'Outbox'
      color: 'purple'
      icon: 'envelope-o'
      extraFields: ['scheduledDate','sentDate']
      tableColumns: [
        { label: 'Ontvanger', name: 'recipient' }
        { label: 'Onderwerp', name: 'subject' }
        { label: 'Wordt verzonden op', name: 'scheduledDateFormat()' }
        { label: 'Is verzonden op', name: 'sentDateFormat()' }
      ]
    Events:
      label: 'Evenementen'
      color: 'purple'
      icon: 'calendar'
      extraFields: ['story','date','createdDate','participants','scheduled']
      omitFields: ['scheduled']
      tableColumns: [
        { label: 'Klant', name: 'contact.name' }
        { label: 'Besteld op', name: 'createddateFormat()' }
        { label: 'Datum', name: 'dateFormat()' }
        { label: 'Verhaal', name: 'storyname()' }
        { label: 'Volgende stap', template: 'eventStatus' }
      ]
    Characters:
      label: 'Personages'
      color: 'green'
      icon: 'user-secret'
      extraFields: ['story']
      tableColumns: [
        { label: 'Naam', name: 'name' }
        { label: 'Nummer', name: 'number' }
        { label: 'Verhaal', name: 'storyname()' }
      ]
    Stories:
      label: 'Verhalen'
      color: 'green'
      icon: 'book'
      tableColumns: [
        { label: 'Naam', name: 'name' }
        { label: 'Minimaal', name: 'minpeople' }
        { label: 'Maximaal', name: 'maxpeople' }
      ]

Characters.helpers
  storyname: ->
    Stories.findOne(@story).name;
Events.helpers
  storyname: ->
    Stories.findOne(@story).name;
  createddateFormat: ->
    return "" unless @createdDate
    moment(@createdDate).format('D MMMM YYYY')
  dateFormat: ->
    return "" unless @date
    moment(@date).format('D MMMM YYYY');
Outbox.helpers
  scheduledDateFormat: ->
    return "" unless @scheduledDate
    moment(@scheduledDate).format('D MMMM YYYY');
  sentDateFormat: ->
    return "" unless @sentDate
    moment(@sentDate).format('D MMMM YYYY');
