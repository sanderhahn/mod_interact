Purpose:
=========

Forward several types of messages as post requests to an arbitrary url.

mod\_offline\_post forwards messages that are sent to offline users through a post request to a configurable url
mod\_available\_post sends a post request with information about a user that has become available
mod\_unavailable\_post sends a post request with information about a user that has gone offline

Installing:
==========

* Run the build.sh script to build *.beam files
* Copy the *.beam files from the ebin directory to the location where the other modules are for your server
* Add the configuration shown below to your ejabberd.cfg file, providing the correct values for auth\_token, and post\_url

Example Configuration:
=====================

     {mod_offline_post, [
        {auth_token, "your-secret-token-here"},
        {post_url, "http://localhost:3000/your/custom/url"}
     ]}
     {mod_available_post, [
        {auth_token, "your-secret-token-here"},
        {post_url, "http://localhost:3000/your/custom/url"}
     ]}
     {mod_unavailable_post, [
        {auth_token, "your-secret-token-here"},
        {post_url, "http://localhost:3000/your/custom/url"}
     ]}

Results:
========

The application running at the post_url will receive a post http request with the following form parameters.

    mod_offline_post
    "to"=>"adam2@localhost"
    "from"=>"adam1"
    "body"=>"Does it still work?"
    "access_token"=>"your-secret-token-here"

    mod_available_post
    "jabber_id"=>"adam2"
    "access_token"=>"your-secret-token-here"

    mod_unavailable_post
    "jabber_id"=>"adam2"
    "access_token"=>"your-secret-token-here"

License
========
The modules herein are almost entirely based on mod\_offline\_prowl written by Robert George <rgeorge@midnightweb.net>
They retain the original author's license.

The original post about mod\_offline\_prowl can be found [here](http://www.unsleeping.com/2010/07/31/prowl-module-for-ejabberd/)