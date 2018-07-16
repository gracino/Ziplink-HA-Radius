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


INSERT INTO `radcheck` VALUES (34144,'Sonar_788099','Cleartext-Password',':=','x5QtlIAwB1');
INSERT INTO `radcheck` VALUES (34145,'Sonar_1087212','Cleartext-Password',':=','YGRQpMqK7I');
INSERT INTO `radcheck` VALUES (34146,'Sonar_1096241','Cleartext-Password',':=','x9oWNNlxuQ');
INSERT INTO `radcheck` VALUES (34147,'Sonar_837677','Cleartext-Password',':=','GlnKtEPnjt');
INSERT INTO `radcheck` VALUES (34148,'Sonar_783809','Cleartext-Password',':=','jmS38yQabw');
INSERT INTO `radcheck` VALUES (34149,'Sonar_1009916','Cleartext-Password',':=','lYrSTOI5al');
INSERT INTO `radcheck` VALUES (34150,'Sonar_785555','Cleartext-Password',':=','eu9ue3QVXB');
INSERT INTO `radcheck` VALUES (34151,'Sonar_1104683','Cleartext-Password',':=','UMCX4Q8wuN');
INSERT INTO `radcheck` VALUES (34152,'Sonar_935099','Cleartext-Password',':=','oKXkzVw2AQ');
INSERT INTO `radcheck` VALUES (34153,'Sonar_786989','Cleartext-Password',':=','Iv0Gy8DBJh');
INSERT INTO `radcheck` VALUES (34154,'Sonar_786038','Cleartext-Password',':=','mCSnhVQh5x');
INSERT INTO `radcheck` VALUES (34155,'Sonar_786014','Cleartext-Password',':=','UJ1H0IdH4F');
INSERT INTO `radcheck` VALUES (34156,'Sonar_888932','Cleartext-Password',':=','GZbtKlubTh');
INSERT INTO `radcheck` VALUES (34157,'Sonar_949916','Cleartext-Password',':=','OfZ9iP2Nwc');
INSERT INTO `radcheck` VALUES (34158,'Sonar_783509','Cleartext-Password',':=','eYqDDRSxe0');
INSERT INTO `radcheck` VALUES (34159,'Sonar_787001','Cleartext-Password',':=','cuRGzHqw44');
INSERT INTO `radcheck` VALUES (34160,'Sonar_849361','Cleartext-Password',':=','nom03qMTfl');
INSERT INTO `radcheck` VALUES (34161,'Sonar_788126','Cleartext-Password',':=','ikOuMi7Lpc');
INSERT INTO `radcheck` VALUES (34162,'Sonar_890909','Cleartext-Password',':=','LYNYMFvFAn');
INSERT INTO `radcheck` VALUES (34163,'Sonar_952301','Cleartext-Password',':=','HRWym86twO');
INSERT INTO `radcheck` VALUES (34164,'Sonar_971540','Cleartext-Password',':=','BbVtFPV4Jd');
INSERT INTO `radcheck` VALUES (34165,'Sonar_838433','Cleartext-Password',':=','p7FzQrkN4Z');
INSERT INTO `radcheck` VALUES (34166,'Sonar_915146','Cleartext-Password',':=','PjzMp96vmo');
INSERT INTO `radcheck` VALUES (34167,'Sonar_833402','Cleartext-Password',':=','oti8xvwikp');
INSERT INTO `radcheck` VALUES (34168,'Sonar_906545','Cleartext-Password',':=','2F7s2fiqVl');
INSERT INTO `radcheck` VALUES (34169,'Sonar_904796','Cleartext-Password',':=','q99DY16G5T');
INSERT INTO `radcheck` VALUES (34170,'Sonar_833387','Cleartext-Password',':=','7JHHdJGIld');
INSERT INTO `radcheck` VALUES (34171,'Sonar_855643','Cleartext-Password',':=','5Enn4QWAsG');
INSERT INTO `radcheck` VALUES (34172,'Sonar_955598','Cleartext-Password',':=','GVr35tcFub');
INSERT INTO `radcheck` VALUES (34173,'Sonar_786533','Cleartext-Password',':=','S1F55dRlGq');
INSERT INTO `radcheck` VALUES (34174,'Sonar_787742','Cleartext-Password',':=','6tdujEg9sL');
INSERT INTO `radcheck` VALUES (34175,'Sonar_902918','Cleartext-Password',':=','ZV7vqzBEFb');
INSERT INTO `radcheck` VALUES (34176,'Sonar_787010','Cleartext-Password',':=','5qfnge2hCh');
INSERT INTO `radcheck` VALUES (34177,'Sonar_883451','Cleartext-Password',':=','5eOSGyA291');
INSERT INTO `radcheck` VALUES (34178,'Sonar_859696','Cleartext-Password',':=','iEMra6SZLt');
INSERT INTO `radcheck` VALUES (34179,'Sonar_784742','Cleartext-Password',':=','d48PKFC7xl');
INSERT INTO `radcheck` VALUES (34180,'Sonar_877826','Cleartext-Password',':=','lU9gycucDS');
INSERT INTO `radcheck` VALUES (34181,'Sonar_862297','Cleartext-Password',':=','E3MJNfN82Z');
INSERT INTO `radcheck` VALUES (34182,'Sonar_885953','Cleartext-Password',':=','FuPclUqDu5');
INSERT INTO `radcheck` VALUES (34183,'Sonar_1017155','Cleartext-Password',':=','R6ZZkFGkxS');
INSERT INTO `radcheck` VALUES (34184,'Sonar_884636','Cleartext-Password',':=','hEfyyhprZf');
INSERT INTO `radcheck` VALUES (34185,'Sonar_1027571','Cleartext-Password',':=','3xpBCNOsgX');
INSERT INTO `radcheck` VALUES (34186,'Sonar_784262','Cleartext-Password',':=','RDmIJV4VlG');
INSERT INTO `radcheck` VALUES (34187,'Sonar_1024466','Cleartext-Password',':=','LPFh03wwP2');
INSERT INTO `radcheck` VALUES (34188,'Sonar_785912','Cleartext-Password',':=','adSH1lNCot');
INSERT INTO `radcheck` VALUES (34189,'Sonar_787262','Cleartext-Password',':=','wwFdgWSwQO');
INSERT INTO `radcheck` VALUES (34190,'Sonar_786386','Cleartext-Password',':=','8ESG6fwHJo');
INSERT INTO `radcheck` VALUES (34191,'Sonar_836855','Cleartext-Password',':=','Ju7yNhqr05');
INSERT INTO `radcheck` VALUES (34192,'Sonar_1107403','Cleartext-Password',':=','TlC6XDIXNI');
INSERT INTO `radcheck` VALUES (34193,'Sonar_784205','Cleartext-Password',':=','AmI7DK8XhP');
INSERT INTO `radcheck` VALUES (34194,'Sonar_854872','Cleartext-Password',':=','i8fRUlau4X');
INSERT INTO `radcheck` VALUES (34195,'Sonar_970349','Cleartext-Password',':=','MdpANFna1f');
INSERT INTO `radcheck` VALUES (34196,'Sonar_862840','Cleartext-Password',':=','sxn8n5w9kq');
INSERT INTO `radcheck` VALUES (34197,'Sonar_787157','Cleartext-Password',':=','G0xSAX5n9k');
INSERT INTO `radcheck` VALUES (34198,'Sonar_787325','Cleartext-Password',':=','rT5vMc6bZ7');
INSERT INTO `radcheck` VALUES (34199,'Sonar_1077804','Cleartext-Password',':=','KI2ChYTyYi');
INSERT INTO `radcheck` VALUES (34200,'Sonar_786866','Cleartext-Password',':=','huRGvqHypj');
INSERT INTO `radcheck` VALUES (34201,'Sonar_1120626','Cleartext-Password',':=','hWoW9voxIM');
INSERT INTO `radcheck` VALUES (34202,'Sonar_1018178','Cleartext-Password',':=','gAdL3q83pE');
INSERT INTO `radcheck` VALUES (34203,'Sonar_1104807','Cleartext-Password',':=','rxSJHIokbV');
INSERT INTO `radcheck` VALUES (34204,'Sonar_833426','Cleartext-Password',':=','nNGeRrU5If');
INSERT INTO `radcheck` VALUES (34205,'Sonar_996356','Cleartext-Password',':=','McqgdBwJqf');
INSERT INTO `radcheck` VALUES (34206,'Sonar_963227','Cleartext-Password',':=','jXgbMqhm3m');
INSERT INTO `radcheck` VALUES (34207,'Sonar_912176','Cleartext-Password',':=','5c2ihQYcX1');
INSERT INTO `radcheck` VALUES (34208,'Sonar_849775','Cleartext-Password',':=','eu2Eg1WZg5');
INSERT INTO `radcheck` VALUES (34209,'Sonar_784430','Cleartext-Password',':=','oFdW1DZ3t5');
INSERT INTO `radcheck` VALUES (34210,'Sonar_784880','Cleartext-Password',':=','u9gnGC9ad9');
INSERT INTO `radcheck` VALUES (34211,'Sonar_887735','Cleartext-Password',':=','0sD6vUcCDl');
INSERT INTO `radcheck` VALUES (34212,'Sonar_783779','Cleartext-Password',':=','hVoGXVXDjK');
INSERT INTO `radcheck` VALUES (34213,'Sonar_953765','Cleartext-Password',':=','eg4Dmp7EPe');
INSERT INTO `radcheck` VALUES (34214,'Sonar_1028117','Cleartext-Password',':=','fvnJn7NSzE');
