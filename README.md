Background Jobs in Rails 4 with Resque, Resque Scheduler and God
================================================================
This is an example application that shows how to create background jobs in Rails 4
using Reque, Resque Scheduler and God.

In [this post][1] I explain in detail how this works.

In order to run this application you first need to install Redis in your system.

###Redis Installation (Ubuntu)
*sudo apt-get install -y python-software-properties
*sudo add-apt-repository -y ppa:rwky/redis
*sudo apt-get update
*sudo apt-get install -y redis-server

[1]: http://localhost:4000/2015/02/07/rails_background_jobs.html