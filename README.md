# Jackrabbit-clone-scripts

Two scripts for helping adding new instances to a Jackrabbit cluster: 

1. To make a consistent backup of a jackrabbit instance (it has to be shut down, so it's preferably an instance in a cluster) 
2. To start a new instance in a jackrabbit cluster with the backup made in the first script

See also this blog-post for more details:
http://blog.liip.ch/archive/2011/05/10/add-new-instances-to-your-jackrabbit-cluster-the-non-time-consuming-way.html

## Prerequisites

It needs xsltproc to adjust repository.xml (I don't like using regex for manipulating XML files)

It also needs the mysql client binary and rsync for doing a fast backup (when you do this daily and always backup in the same directory, this should help in cloning the indexes fast)

Both are easily replaceable by your preferred way of talking to the DB or copying whole directories.

## Before first time use

Copy config.sh-dist to config.sh and adjust your preferences. Important options are

### REPOLOCATION

this is the directory where your repository.xml is and all the workspace directory (like indexes)

### JRCLUSTERID_NEW

This is the name of your new cluster node. Make sure, this is unique (but the script will complain, if it exists already in the databas)

## Actually doing the clone and start

First make a backup of your current running repository with 

    bash cloneRepo.sh

Then copy the directory $REPOLOCATION.bkup to the server you want to start a new instance (or if you want to use it just for backup purposes, move it away to some secure location)

The scripts writes the current revision ID into a file called current_revision_id.dat. This is needed later for starting a new clone.

Then on the new server, call

    bash startNewRepo.sh

and you're done.

## Final Notes

The scripts are not really tested in production (yet) and handle one specific setup (you use MySQL as Persistent Store for example), but it should be easy to adjust it to your needs.

It has some tests for avoiding mistakes and the scripts stops then, but I'm sure I missed some not-so-obvious ones
