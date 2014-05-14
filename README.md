# DisqusRails

[![Build Status](https://travis-ci.org/sandric/disqus_rails.svg?branch=master)](http://travis-ci.org/sandric/disqus_rails)

DisqusRails is a gem for including [Disqus](http://disqus.com/) service into Ruby on Rails application.

## Installation

Add this line to your application's Gemfile:

  `gem 'disqus_rails'`

And then execute:

  `$ bundle`

Or install it yourself as:

  `$ gem install disqus_rails`

And add to your javascript manifest file:

  `//= require disqus_rails`

## Usage
### Getting started

Create new initializer, lets say 'disqus_rails.rb' in config/initializers directory with this:
```ruby
DisqusRails.setup do |config|
  config::SHORT_NAME = "your_short_name"
  config::SECRET_KEY = "your_secret_disqus_key" #leave blank if not used
  config::PUBLIC_KEY = "your public_disqus_key" #leave blank if not used
  config::ACCESS_TOKEN = "your_access_token" #you got it, right? ;-)
end
```
In your layout file place 'disqus_init' helper:
```erb
<%= disqus_init %>
```
In your view, where you want to display Disqus thread, place 'disqus_thread' helper:
```erb
<%= disqus_thread %>
```
And you are ready to go.

####additional params:

You can omit creating initializer if you want - you can pass all those params right into 'disqus_init' helper as hash:
```erb
<%= disqus_init :short_name => "short_name", :public_key => "public key", :secret_key => "secret_key", :access_token => "access_token" %>
```
also you can pass reset option to 'disqus_init' to invoke 'DISQUS.reset' function to be triggered on 'onReady' disqus event:
```erb
<%= disqus_init :reset => true %>
```
This is for ajax-heavy sites, read more [here](http://help.disqus.com/customer/portal/articles/472107-using-disqus-on-ajax-sites)

'disqus_thread' has two params - first is 'ident' identifier and the second is title:
```erb
<%= disqus_thread 1, "some title, that will preferred to document.title"  %>
```

###Api

####Api calls

'DisqusRails::Api' stands for [Disqus API](http://disqus.com/api/docs/) calls. Each entity of Disqus API (Posts, Users, Forums, etc...)
has its own class in 'DisqusRails::Api' module. Lets say you want to get all reactions for some forum with limit of 50 results, with desc order:
```ruby
DisqusRails::Api::Reactions.list(:forum => "forum_id", :limit => 50, :order => "desc")
```
or, for example to update some post:
```ruby
DisqusRails::Api::Posts.update(:post => post_id, :message => "some updated message")
```
Disqus return data as json, 'DisqusRails::Api' requests translates it to hash with symbolized keys.
All methods with required and optional params you can see in 'api.yml' file. If any of required params not passed - it will generate
exeption, so as if passed param neither required nor optional. Also, you have to initialize access_token for methods that has
'require authentication' option set to true.

####Models

For more flexibility and using Disqus entities as an ActiveRecord model there is 'DisqusRails::Model' class that is inherited by
'DisqusRails::Forum', 'DisqusRails::Category', 'DisqusRails::Thread', 'DisqusRails::Post' and 'DisqusRails::User'.
Lets take previous example and turn it into model's presentation:
```ruby
new_post = DisqusRails::Post.create(:message => "initial message")
new_post.update(:message => "updated message")
new_post.author.checkUsername("John Doe")
new_post.remove
new_post.restore
```
If Disqus entity has 'details' api method, than model has 'find' singleton method
```ruby
user = DisqusRails::User.find(:user => "user_id")
user_posts.follow()
```
Each 'DisqusRails::Model' has number of attributes that you can find in model's code. For example, here is Posts:
```ruby
class Post < Model
    attr_accessor :id,
                  :isJuliaFlagged,
                  :isFlagged,
                  :parent,
                  :media,
                  :isApproved,
                  :dislikes,
                  :raw_message,
                  :points,
                  :createdAt,
                  :isEdited,
                  :message,
                  :isHighlighted,
                  :ipAddress,
                  :isSpam,
                  :isDeleted,
                  :likes,

                  :author,
                  :thread,
                  :forum
```

####Collections

Collections, as you may guess, is a list of similar Models. Its inherited from Enumerable. There is similar to models
number of collection - 'DisqusRails::Forums', 'DisqusRails::Categories', 'DisqusRails::Threads', 'DisqusRails::Posts' and 'DisqusRails::Users'.
Here some examples:
```ruby
user = DisqusRails::User.find(:user => "user_id")
user.active_threads(:limit => 50)[15].posts.each do |post|
  post.update(:message => "my post is nothing comparing to #{user.username} writings...")
end
```
If there is 'list' method in Disqus entity - it transforms to 'where' singleton method of model that creates corresponding collection. For example:
```ruby
forum_categories = DisqusRails::Category.where(:forum => "forum_id")
```
Disqus API is designed in such way, that you can only get maximum 100 results for list query, and by default its 25. To get more
results you are given with 'cursor' object that have 'next' and 'prev' values, passing which into query you can walk through
results as if it was a list data structure. To define if there is more values to get, Disqus provides 'hasNext' and 'hasPrev' boolean
values. For example, to get first 225 posts you can use this code:
```ruby
posts = DisqusRails::Post.where(:limit => 75)
2.times do
  if posts.has_cursor_next?
    previous_items = posts.items
    posts.cursor_next!
    posts.items = previous_items + posts.items
  end
end
```
In future I, may be, will rewrite this to handle common cases for :limit attribute to be set to any number. As you saw, in
previous example were used 'cursor_next!' method. There is both 'cursor_next', 'cursor_next!' and 'cursor_prev', 'cursor_prev!' methods.
The difference is in returned values - method with bang in the end initializes new collection right in invoked instance,
when method without it - just returns new collection.
Also, each collection has singleton method 'find_all_#collection_class_name#!' that will get all results for query:
```ruby
threads = DisqusRails::Thread.where(:forum => "forum_name", :limit => 100).find_all_threads!
```

###Connection to ActiveRecord models

####acts_as_disqusable and disqus_thread

Lets say you have a 'Content' ActiveRecord model that implements logic for displaying some content information, and you add to that displaying
Disqus thread. Then you may want to match threads info with different Content model instances. For example you may want to know
how many comments and what is the last comment for each model instance.
For this you need to wright 'acts_as_disqusable' in models definition:
```ruby
class Content < ActiveRecord::Base
  acts_as_disqusable
  ...
end
```
And then all your model instances will be populated with 'disqus_thread' method that will return 'DisqusRails::Thread' instance
that is found by Disqus 'ident' identifier which you can pass to 'disqus_thread' helper in your view. Here is full example:

Your model:
```ruby
class Content < ActiveRecord::Base
  acts_as_disqusable
  ...
end
```
Your model's details view
```erb
<%= disqus_thread @content.id %>

```
And now, when you run this
```ruby
disqus_thread = Content.first.disqus_thread #It will be thanslated to DisqusRails::Thread.find(:'thread:ident' => Content.first.id)
disqus_thread.posts_count #number of posts
disqus_thread.posts(:limit => 1).createdAt #last comment date
```
This work also in opposite direction - after you include 'acts_as_disqusable' in your model definition, all 'DisqusRails::Thread'
instances you will have method 'disqusable' what will return your model instance that is linked to Disqus thread via 'ident' identificator.
As an example lets say that we want to get all threads from Disqus service and update comments_count attribute in Content model:
```ruby
DisqusRails::Thread.where().find_all_threads!.each do |thread|
  thread.disqusable.comments_count = thread.posts_count
  thread.disqusable.save()
end
```

####acts_as_disquser and Single Sign On

Disqus provides [SSO service](http://help.disqus.com/customer/portal/articles/236206-integrating-single-sign-on) which gives
ability to link your local users info to Disqus users, read more in Disqus tutorial. To do this, as and for linking model to
Disqus thread - you have to add 'acts_as_disquser' line in your users model. You need pass there four attributes:
'id', 'username', 'email' and 'avatar'(avatar is an optional field, so you can omit this). Here is example:
```ruby
class User < ActiveRecord::Base
  acts_as_disquser :username => :full_name, :email => :email, :avatar => Proc.new{ avatar.url }
  ...
end
```
As you see, you can pass there or symbols, or procs. First will try to get instance variable with such name from model's instance,
second will evaluate code inside Proc with context of model's instance. Important - only Proc are available for second way of
defining attribute, no lambdas.
Also, you may not implicitly pass `acts_as_disquser :id => :id` - it will try to get id automatically if it is not defined.
Next, you need to specify in disqus_init helper attributes 'disquser' with current user instance, and 'sso' as
boolean to enable or disable SSO.
```erb
<%= disqus_init :disquser => current_user, :sso => true %>
```
After this is done, when users will post comments via Disqus, their username, email and avatar will be taken from your site.

###Javascript events

Disqus provides developer with set of events which could be used to implement some logic that depends on it. The problem is
that instead of triggering events we have to append function definitions in array for each of this events - for example look
at [this article](http://help.disqus.com/customer/portal/articles/466258-how-can-i-capture-disqus-commenting-activity-in-my-own-analytics-tool-).
I found that it might be a little bit more useful to set event listener for this, so I defined separate event for every Disqus event
that developer can implicitly create listener:
```coffeescript
@callbacks.afterRender = [->
  $(document).trigger "disqus:after_render"
]
@callbacks.onInit = [->
  $(document).trigger "disqus:on_init"
]
@callbacks.onNewComment = [->
  $(document).trigger "disqus:on_new_comment"
]
@callbacks.onPaginate = [->
  $(document).trigger "disqus:on_paginate"
]
@callbacks.onReady = [->
  $(document).trigger "disqus:on_ready"
]
@callbacks.preData = [->
  $(document).trigger "disqus:pre_data"
]
@callbacks.preInit = [->
  $(document).trigger "disqus:pre_init"
]
@callbacks.preReset = [->
  $(document).trigger "disqus:pre_reset"
]
```
For more information about coffeescript global class 'DisqusRails' look into 'disqus_rails.js.coffee' file.

### Keeping data up to date
It is equally little hard to do that with Disqus for now, as for me. The problem is that you can not set some callback for user
actions - all you can is to set event listener for 'disqus:on_new_comment', but that will not be valid for all circumstances.
Lets say user deleted or created new post from his users admin page in Disqus site. Disqus does not provide any callback for setting url
where should query go, or some other futuristic way like web socket channel (sarcasm tag). So we should create some cron task for keeping data
that we need up to date. For example, lets go back to problem of getting comments count and last comment for each Disqus thread.
Here is example of such rake task that could be scheduled with whenever (or any else) gem:

```ruby
require 'resque/tasks'

namespace :disqus do
  desc "Refreshing local data about remote disqus comments"
  task :refresh => :environment do
    threads = DisqusRails::Thread.where(:forum => "forum_name", :limit => 100).find_all_threads!
    threads.each do |thread|
      if thread.disqusable_id && Content.find_by_id(thread.disqusable_id)
        content = thread.disqusable
        if (content.comments_count != thread.posts_count) || (thread.posts_count > 0 && thread.posts(:limit => 1).first.createdAt != content.last_comment_at)
          content.comments_count = thread.posts_count
          if thread.posts_count > 0
            content.last_comment_at = DateTime.parse(thread.posts(:limit => 1).first.createdAt)
          else
            content.last_comment_at = nil
          end
          content.save
        end
      end
    end
  end
end

```
