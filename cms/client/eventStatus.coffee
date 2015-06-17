Template.eventStatus.helpers
  isExpired: ->
    moment(@doc.date).isBefore(moment())
  isAssigned: ->
    return false if not @doc.participants
    notassigned = _.find(@doc.participants, (p) ->
      not p.email or p.email is "" or not p.character or p.character is "" or not p.name or p.name is ""
    )
    if notassigned then false else true
