CloudFiles Backup
=================

Backs up single-file backups to Rackspace CloudFiles. Useful for storing things
like database dumps and similar after backing them up locally.

At the moment, this stores the files totally unencrypted within the container,
which is probably unsafe regardless of its it a private container or not.

Configuration
=============

It looks for a file called cloudfiles-backup.conf within the root of the
application directory. If it can't find it, it will look for
/etc/cloudfiles-backup.conf instead.
