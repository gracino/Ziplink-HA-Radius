# Ziplink-HA-Radius
Ziplink high availability RADIUS project.

## Summary System Description From Job Messages

 1. Sonar is used as source of all customer authentication. 3k customers.
 1. Some NAS RADIUS requests time out, customer is disconnected. (Investigate: Change NAS settings to not go offline until RADIUS answers?)
 1. New RADIUS server exists. Not finished. 
 1. HA setup should be architected.
 1. Sonar "talks" to only one RADIUS server. (Does it? Or does it talk to MySQL?)
 1. Sonar has a "genie" that helps with initial setup. It is out of date with current FreeRADIUS.

### References

 1. https://sonar.software/resources
 1. https://github.com/SonarSoftware/freeradius_genie
 1. https://github.com/FreeRADIUS

## Summary Roadmap
 1. Survey current system. 
 1. Document current system.
 1. Meeting with stakeholders.
 1. Work on proposal.
 1. Review proposal.
 1. Approve proposal.
 1. Work on alpha version.
 1. Work on beta version.

