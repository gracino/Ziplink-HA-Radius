## Bitnami MariaDB Replication Cluster Testing

The idea here is to see if we can use this image to
startup a cluster with a prepopulated radius db.

### Initial Attempt

We will try to use a helper container to load the master after it
start up.

Then we can run tests to see if the data is available cluster wide.
