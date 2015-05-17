@AdminConfig =
  name: 'Moorddiner'
  nonAdminRedirectRoute: 'login'
  # adminEmails: ['lukas@3l.nl','hester@3l.nl','lukas@q42.nl']
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
        { label: 'Verhaal', template: 'cmsCharacterStory' }
      ]
    Events:
      label: 'Evenementen'
      color: 'purple'
      icon: 'calendar'
      extraFields: ['story']
      tableColumns: [
        { label: 'Klant', name: 'contact.name' }
        { label: 'Datum', name: 'date' }
        { label: 'Adres', name: 'address' }
        { label: 'Verhaal', template: 'cmsCharacterStory' }
      ]


