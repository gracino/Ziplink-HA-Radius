## Accounting Aggregation Subsystem

We need to periodically gather accounting data from all accounting DBs into the single master DB.

### Roadmap

 1. Create an Alpine Linux container with MySQL client tools.
 1. Create BASH or SH scripts that will gather data and transfer to master DB.
 
### Details/Notes

 1. Alpine Linux container will require cron.
 1. Will require MySQL client tools.
 1. Can we get BASH installed in Alpine?.
