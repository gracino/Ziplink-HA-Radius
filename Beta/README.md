## Beta Docker Based HA RADIUS Server for Sonar
We will improve the Alpha Docker solution providing a production usable system. This system should be able to:

 1. Scale to 10x the current traffic. 
 1. Handle (N-1) NAS-Network* MySQL DB failures. Where N is the total number MySQL servers.
 1. Handle (N-1) NGINX Frontend failures. Where N is the total number NGINX proxies.

*The NAS-Network MySQL servers refers to those needed to insure that NAS auth and accouting functions continue to
run, as opposed to the Sonar MySQL DB (that coould also be a cluster) that should not be required to be functional
for the NAS-Network to continue to operate.

### Quick Status
Started work on MySQL replication. 
 1. Adding MySQL Accounting and Authentication DB master server.
 1. Adding configuration for replication.

### Outline

 1. We will add the Sonar MySQL connection point. Ability to preload current production data is required.
 1. We will replicate the readonly table data to all MySQL servers. Single master that periodically loads data from
 the, external to cluster, Sonar MySQL DB.
 1. We will periodically aggregate the accounting data back into the Sonar MySQL database.
