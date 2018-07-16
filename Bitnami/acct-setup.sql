#CREATE DATABASE radius;

USE radius;


###########################################################################
# $Id: ca5ac77aa03dbb86ef714d1a1af647f7e63fda00 $                 #
#                                                                         #
#  schema.sql                       rlm_sql - FreeRADIUS SQL Module       #
#                                                                         #
#     Database schema for MySQL rlm_sql module                            #
#                                                                         #
#     To load:                                                            #
#         mysql -uroot -prootpass radius < schema.sql                     #
#                                                                         #
#                                   Mike Machado <mike@innercite.com>     #
###########################################################################
#
# Table structure for table 'radacct'
#

CREATE TABLE radacct (
  radacctid bigint(21) NOT NULL auto_increment,
  acctsessionid varchar(64) NOT NULL default '',
  acctuniqueid varchar(32) NOT NULL default '',
  username varchar(64) NOT NULL default '',
  groupname varchar(64) NOT NULL default '',
  realm varchar(64) default '',
  nasipaddress varchar(15) NOT NULL default '',
  nasportid varchar(15) default NULL,
  nasporttype varchar(32) default NULL,
  acctstarttime datetime NULL default NULL,
  acctupdatetime datetime NULL default NULL,
  acctstoptime datetime NULL default NULL,
  acctinterval int(12) default NULL,
  acctsessiontime int(12) unsigned default NULL,
  acctauthentic varchar(32) default NULL,
  connectinfo_start varchar(50) default NULL,
  connectinfo_stop varchar(50) default NULL,
  acctinputoctets bigint(20) default NULL,
  acctoutputoctets bigint(20) default NULL,
  calledstationid varchar(50) NOT NULL default '',
  callingstationid varchar(50) NOT NULL default '',
  acctterminatecause varchar(32) NOT NULL default '',
  servicetype varchar(32) default NULL,
  framedprotocol varchar(32) default NULL,
  framedipaddress varchar(15) NOT NULL default '',
  PRIMARY KEY (radacctid),
  UNIQUE KEY acctuniqueid (acctuniqueid),
  KEY username (username),
  KEY framedipaddress (framedipaddress),
  KEY acctsessionid (acctsessionid),
  KEY acctsessiontime (acctsessiontime),
  KEY acctstarttime (acctstarttime),
  KEY acctinterval (acctinterval),
  KEY acctstoptime (acctstoptime),
  KEY nasipaddress (nasipaddress)
) ENGINE = INNODB;

#
# Table structure for table 'radcheck'
#

CREATE TABLE radcheck (
  id int(11) unsigned NOT NULL auto_increment,
  username varchar(64) NOT NULL default '',
  attribute varchar(64)  NOT NULL default '',
  op char(2) NOT NULL DEFAULT '==',
  value varchar(253) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY username (username(32))
);

#
# Table structure for table 'radgroupcheck'
#

CREATE TABLE radgroupcheck (
  id int(11) unsigned NOT NULL auto_increment,
  groupname varchar(64) NOT NULL default '',
  attribute varchar(64)  NOT NULL default '',
  op char(2) NOT NULL DEFAULT '==',
  value varchar(253)  NOT NULL default '',
  PRIMARY KEY  (id),
  KEY groupname (groupname(32))
);

#
# Table structure for table 'radgroupreply'
#

CREATE TABLE radgroupreply (
  id int(11) unsigned NOT NULL auto_increment,
  groupname varchar(64) NOT NULL default '',
  attribute varchar(64)  NOT NULL default '',
  op char(2) NOT NULL DEFAULT '=',
  value varchar(253)  NOT NULL default '',
  PRIMARY KEY  (id),
  KEY groupname (groupname(32))
);

#
# Table structure for table 'radreply'
#

CREATE TABLE radreply (
  id int(11) unsigned NOT NULL auto_increment,
  username varchar(64) NOT NULL default '',
  attribute varchar(64) NOT NULL default '',
  op char(2) NOT NULL DEFAULT '=',
  value varchar(253) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY username (username(32))
);


#
# Table structure for table 'radusergroup'
#

CREATE TABLE radusergroup (
  username varchar(64) NOT NULL default '',
  groupname varchar(64) NOT NULL default '',
  priority int(11) NOT NULL default '1',
  KEY username (username(32))
);

#
# Table structure for table 'radpostauth'
#
CREATE TABLE radpostauth (
  id int(11) NOT NULL auto_increment,
  username varchar(64) NOT NULL default '',
  pass varchar(64) NOT NULL default '',
  reply varchar(32) NOT NULL default '',
  authdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (id)
) ENGINE = INNODB;

#
# Table structure for table 'nas'
#
CREATE TABLE nas (
  id int(10) NOT NULL auto_increment,
  nasname varchar(128) NOT NULL,
  shortname varchar(32),
  type varchar(30) DEFAULT 'other',
  ports int(5),
  secret varchar(60) DEFAULT 'secret' NOT NULL,
  server varchar(64),
  community varchar(50),
  description varchar(200) DEFAULT 'RADIUS Client',
  PRIMARY KEY (id),
  KEY nasname (nasname)
);

INSERT INTO `nas` VALUES (1,'71.42.155.65','HAS','other',NULL,'j2qksrv0hsiwnm6v',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (2,'67.79.11.167','AlconOffice','other',NULL,'eyr1u3gowkgfn60g',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (3,'104.218.76.65','SDWT','other',NULL,'kcesnjdmllzndx0s',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (4,'38.103.213.193','PICOSA','other',NULL,'z22k53nd9m3cdv5f',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (5,'104.218.77.161','CCR181','other',NULL,'5fm0ubmb82a0jhws',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (6,'71.40.111.65','SLAV','other',NULL,'ijb0k4fnhke4wwef',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (9,'71.40.111.145','WYNN','other',NULL,'9u1fgljb1qi8pj1s',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (11,'71.42.155.97','OHWT','other',NULL,'x54u090de2th0qym',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (12,'38.103.213.225','BeckmanMP','other',NULL,'kg3j4c4ri8wd5v02',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (13,'148.59.236.129','Trailcrest','other',NULL,'by358k7wn4zoju4c',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (15,'71.40.111.177','Bynum','other',NULL,'54ykrjzc9w9mjfyx',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (16,'71.40.111.217','POTH','other',NULL,'g9wvvp5uhnszs6ir',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (17,'71.40.111.241','SBA','other',NULL,'gx1ulbvseumwyoes',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (18,'71.40.111.97','Ksat','other',NULL,'9dh11yxa399rehg0',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (19,'71.40.111.161','RUMC','other',NULL,'819dh05g3g4q2smr',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (20,'71.40.111.33','GRAMS','other',NULL,'rcpwv0ckc4c08w8d',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');
INSERT INTO `nas` VALUES (21,'71.40.111.1','FVtwr','other',NULL,'l4lilowurr63zuvm',NULL,NULL,'Added via the Sonar FreeRADIUS Genie tool');

#this is required for start.sh
INSERT INTO `radreply` VALUES (2,'Sonar_1170712','Framed-IP-Address','=','10.9.15.185');
