# Set up a collection to contain player information. On the server,
# it is backed by a MongoDB collection named "players".

Players = new Meteor.Collection("players")

if (Meteor.isClient)
  Template.leaderboard.helpers
    players: ->
      Players.find({}, sort: score: -1, name: 1)

    selected_name: ->
      Players.findOne(Session.get("selected_player"))?.name

  Template.player.selected = ->
    if Session.equals("selected_player", @_id) then "selected" else ''

  Template.leaderboard.events
    'click input.inc': ->
      Players.update(Session.get("selected_player"), $inc: score: 5)

  Template.player.events
    'click': ->
      Session.set("selected_player", @_id);

# On server startup, create some players if the database is empty.
if (Meteor.isServer)
  Meteor.startup ->
    if Players.find().count() == 0
      names = ["Ada Lovelace",
               "Grace Hopper",
               "Marie Curie",
               "Carl Friedrich Gauss",
               "Nikola Tesla",
               "Claude Shannon"];
      for name in names
        Players.insert(name: name, score: Math.floor(Random.fraction()*10)*5);
