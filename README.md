# Ziplink-HA-Radius
Ziplink high availability RADIUS project.

## Summary System Description From Job Messages

 1. Sonar is used as source of all customer authentication. 3k customers.
 2. Some NAS RADIUS requests time out, customer is disconnected. (Investigate: Change NAS settings to not go offline until RADIUS answers?)
 3. New RADIUS server exists. Not finished. 
 4. HA setup should be architected.
 5. Sonar "talks" to only one RADIUS server. (Does it? Or does it talk to MySQL?)
 6. Sonar has a "genie" that helps with initial setup. It is out of date with current FreeRADIUS.

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

Some comments regarding ? from #2 and #5:

We did increase NAS timeout in the Radius config from 300ms to 600ms. Sounds reasonable. But we should aim for 200ms max transaction time.

I suspect Sonar talks to MySQL as that is the db that holds the custome info. Yes that is clear now. Thx!

The NAS also reports PPPoE address assigned to CPE and data using that traverses the PPPoE tunnel. That goes back into Sonar.
