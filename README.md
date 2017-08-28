# Gravenstein: a simple survey tool.

* **Requirements:**
  - A user should be able to create any number of surveys.
  - A survey consists of one question represented as a single string. The answer to the question is always Yes or No.
  - The home screen of our app should show a list of surveys and a button to create a new one.
  - You don't need to worry about user authentication but you may stub this out if you wish.
  - A user can respond to a survey by clicking into it from the list discussed above.
  - A survey can be answered multiple times with a yes/no response.
  - You should keep track of when each of the survey responses are saved.
  - You should display the results of the survey on the home screen with the percentage of yes and no responses.
  - You should make sure that your app can be run by other developers.
  - Make sure all of your dependencies are listed in your Gemfile and instructions are provided for setup if needed.
  - You should use SQLite to store your data.

* **Ruby version:** 2.4.1

* **System dependencies:** cf. Gemfile
  - Authentification with AuthLogic (https://github.com/binarylogic/authlogic).
  - Designs with Bootstrap v4 (https://github.com/twbs/bootstrap-rubygem, https://github.com/bokmann/font-awesome-rails).
  - Graphics with ChartKick (https://github.com/ankane/chartkick).
  - Data generation with Faker (# https://github.com/stympy/faker).

* **Configuration/Installation**
  - install ruby v2.4.1
  - install rails v5.1.3
  - bundle install

* **Database creation**
  - rake db:migrate

* **Database initialization**
  - rake db:seed (optional).

* **Test suite**
  - rake test

* **Services**
  - rake survey:denormalize (to denormalize the closed surveys).

* **Documentation**
  - rdoc (directory ./doc/).

* **general TODOs**
  - some datetime formatting needed when displayed.
  - add users management / roles.
  - change polling with WebSockets (leveraging ActionCable with Redis PubSub).
  - use a NoSQL database to scale (saving answers in Redis, as well as some incremental values (answers count, yes/no count, ...)).
  - use a Resque task or use a Cron task to denormalize survey(s).  
  - more user attributes? (geolocalisation, gender, ...).
  - more answer possibilities? (list of values for a given answer?).
  - more statistical analysis on closed surveys? (group surveys by theme?, etc...).
  - more testing? (Security?, Selenium?, Load testing?).
