Purpose:
=========

Send post request to an arbitrary url when an ejabberd user is offline and receives a message.

Installing:
==========

* Run the build.sh script to build mod\_offline\_post.beam file
* Copy the mod\_offline\_post.beam file to the location where the other modules are for your server
* Add the configuration shown below to your ejabberd.cfg file, providing the correct values for auth\_token, and post\_url

Example Configuration:
=====================

     {mod_offline_post, [
        {auth_token, "your-secret-token-here"},
        {post_url, "http://localhost:3000/notifications/notify"}
     ]}

Results:
========

The application running at the post_url will receive a post http request with the following form parameters.

    "to"=>"adam2@localhost"
    "from"=>"adam1"
    "body"=>"Does it still work?"
    "access_token"=>"your-secret-token-here"

License
========
mod\_offline\_post is almost entirely based on mod\_offline\_prowl written by Robert George <rgeorge@midnightweb.net>
It retains the original authors license.

The original post about mod\_offline\_prowl can be found [here](http://www.unsleeping.com/2010/07/31/prowl-module-for-ejabberd/)