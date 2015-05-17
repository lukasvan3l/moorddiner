@AdminConfig =
  name: 'Moorddiner'
  nonAdminRedirectRoute: 'login'
  # adminEmails: ['lukas@3l.nl','hester@3l.nl','lukas@q42.nl']
  collections:
    Stories:
      color: 'green'
      icon: 'book'
      tableColumns: [
        { label: 'Naam', name: 'name' }
        { label: 'Minimaal', name: 'minpeople' }
        { label: 'Maximaal', name: 'maxpeople' }
      ]
    Characters:
      color: 'purple'
      icon: 'user-secret'
      auxCollections: ['Stories']
      extraFields: ['story']
      tableColumns: [
        { label: 'Naam', name: 'name' }
        { label: 'Nummer', name: 'number' }
        { label: 'Verhaal', template: 'cmsCharacterStory' }
      ]

