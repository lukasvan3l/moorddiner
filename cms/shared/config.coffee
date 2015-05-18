@pricePerPerson = 8.50;
@ibanHester = 'NL43ABNA0572899149';

@AdminConfig =
  name: 'Moorddiner'
  nonAdminRedirectRoute: 'login'
  collections:
    Stories:
      label: 'Verhalen'
      color: 'green'
      icon: 'book'
      tableColumns: [
        { label: 'Naam', name: 'name' }
        { label: 'Minimaal', name: 'minpeople' }
        { label: 'Maximaal', name: 'maxpeople' }
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

Characters.helpers
  storyname: ->
    Stories.findOne(@story).name;
Events.helpers
  storyname: ->
    Stories.findOne(@story).name;
  createddateFormat: ->
    return moment(@createdDate).format('D MMM YYYY') if @createdDate
    ""
  dateFormat: ->
    moment(@date).format('D MMM YYYY');
