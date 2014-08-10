from google.appengine.api import users
from google.appengine.ext import ndb
from google.appengine.ext import blobstore
from google.appengine.api import images
from google.appengine.ext.webapp import blobstore_handlers
from google.appengine.api import urlfetch

import os, jinja2, logging, webapp2, datetime, urllib, locale, random

ADMIN_USERS = ['lukas@q42.nl', 'lukas@3l.nl', 'hester@3l.nl']

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

class Game(ndb.Model):
	title 			= ndb.StringProperty()
	character_count = ndb.IntegerProperty()
	added_date 		= ndb.DateTimeProperty()

class Character(ndb.Model):
	game 			= ndb.KeyProperty(kind="Game")
	name 			= ndb.StringProperty(indexed=False)
	mail1			= ndb.StringProperty(indexed=False)
	mail2			= ndb.StringProperty(indexed=False)
	mail3			= ndb.StringProperty(indexed=False)
	mail4			= ndb.StringProperty(indexed=False)
	mail5			= ndb.StringProperty(indexed=False)

class Dinner(ndb.Model):
	game 			= ndb.KeyProperty(kind="Game")
	requested_date 	= ndb.DateTimeProperty()
	contact_name 	= ndb.StringProperty(indexed=False)
	contact_email 	= ndb.StringProperty(indexed=False)
	contact_telephone = ndb.StringProperty(indexed=False)
	game_date 		= ndb.DateTimeProperty()
	game_address 	= ndb.StringProperty(indexed=False)

class Participant(ndb.Model):
	dinner 			= ndb.KeyProperty(kind="Dinner")
	contact_name 	= ndb.StringProperty(indexed=False)
	contact_email 	= ndb.StringProperty(indexed=False)
	character 		= ndb.KeyProperty(kind="Character")


class BaseHandler(webapp2.RequestHandler):
	def dispatch(self):
		user = self.current_user

		if not user:
			logging.info("unknown user")
			self.redirect(users.create_login_url(self.request.uri))
		elif not user.email() in ADMIN_USERS:
			logging.error('invalid user %s requested %s', user.nickname(), self.request.uri)
			self.response.write('<h2>Alleen voor beheerders!</h2><p>Je bent nu ingelogd als ' + user.email() + '<br /><a href=\'' + users.create_logout_url(self.request.uri) + '\'>Log in als beheerder...</a>')
		else:
			logging.info("Logged in as " + user.email())
		
			webapp2.RequestHandler.dispatch(self)

	@webapp2.cached_property
	def current_user(self):
		return users.get_current_user()

	def render_template(self, filename, **kwargs):
		# set or overwrite special vars for jinja templates
		kwargs.update({
			'username': self.current_user.nickname(),
			'email': self.current_user.email(),
			'url': self.request.url,
			'path': self.request.path,
			'logout_url': users.create_logout_url(self.request.url)
		})

		self.response.headers.add_header('X-UA-Compatible', 'IE=Edge,chrome=1')
		template = JINJA_ENVIRONMENT.get_template('templates/' + filename)
		self.response.write(template.render(kwargs))

class MainHandler(BaseHandler):
    def get(self):
		template_values = {
			'games': Game.query().order(-Game.title).fetch()
		}
		self.render_template('index.html', **template_values)

class CreateGameHandler(BaseHandler):
	def post(self):
		title = self.request.POST['title']
		character_count = int(self.request.POST['character_count'])

		game = Game(
			title = title,
			character_count = character_count,
			added_date = datetime.datetime.now()
			)
		game.put()

		for i in range(0, character_count):
			character = Character(
				game = game.key,
				name = 'Persoon ' + str(i),
				mail1 = '',
				mail2 = '',
				mail3 = '',
				mail4 = '',
				mail5 = ''
				)
			character.put()


		self.redirect('/spel/' + str(game.key.id()))

class GameHandler(BaseHandler):
	def get(self, game_id):
		game_id_int = int(game_id)

		template_values = {
			'game': Game.get_by_id(game_id_int),
			'characters': Character.query(Character.game == ndb.Key(Game, game_id_int))
		}
		self.render_template('game.html', **template_values)

class CharacterHandler(BaseHandler):
	def get(self, game_id, character_id):
		user = users.get_current_user()
		logging.info("Logged in as " + user.email() + ', requesting ' + game_id)
		game_id_int = int(game_id)

		template_values = {
			'game': Game.get_by_id(game_id_int),
			'character': Character.get_by_id(int(character_id))
		}

		self.render_template('character.html', **template_values)

	def post(self, game_id, character_id):
		character = Character.get_by_id(int(character_id))

		character.name = self.request.POST['name']
		character.mail1 = self.request.POST['mail1']
		character.mail2 = self.request.POST['mail2']
		character.mail3 = self.request.POST['mail3']
		character.mail4 = self.request.POST['mail4']
		character.mail5 = self.request.POST['mail5']
		
		character.put()

		self.redirect('/spel/' + game_id)

class CreateDinnerHandler(BaseHandler):
	def get(self, game_id):
		game_id_int = int(game_id)
		template_values = {
			'game': Game.get_by_id(game_id_int),
			'characters': Character.query(Character.game == ndb.Key(Game, game_id_int))
		}

		self.render_template('createdinner.html', **template_values)

	def post(self, game_id):
		game = Game.get_by_id(int(game_id))
		dinner = Dinner(
			game 			= game.key,
			requested_date 	= datetime.datetime.now(),
			contact_name 	= self.request.POST['contact_name'],
			contact_email 	= self.request.POST['contact_email'],
			contact_telephone = self.request.POST['contact_telephone'],
			game_date 		= self.request.POST['game_date'],
			game_address 	= self.request.POST['game_address'],
			)
		dinner.put()

		self.redirect('/spel/' + game_id + "/d/" + dinner.key.id())

class DinnerHandler(BaseHandler):
	def get(self):
		self.render_template('newdinner.html')

app = webapp2.WSGIApplication([
	('/', MainHandler),
	('/create', CreateGameHandler),
	('/spel/(\d+)/c/(\d+)', CharacterHandler),
	('/spel/(\d+)/d/(\d+)', DinnerHandler),
	('/spel/(\d+)/d', CreateDinnerHandler),
	('/spel/(\d+)', GameHandler)
], debug=True)
