#!/bin/bash

echo radius.ziplinknet.com > /tmp/mail.disk.report.sh.log
ssh radius.ziplinknet.com df -h | grep vda1 >> /tmp/mail.disk.report.sh.log
echo radius-primary.ziplinknet.com >> /tmp/mail.disk.report.sh.log
ssh radius-primary.ziplinknet.com df -h | grep vda1 >> /tmp/mail.disk.report.sh.log
echo radius-secondary.ziplinknet.com >> /tmp/mail.disk.report.sh.log
ssh radius-secondary.ziplinknet.com df -h | grep vda1  >> /tmp/mail.disk.report.sh.log

mail -s disk.report -r root@radius.ziplinknet.com wgg1970@gmail.com,gary@unxs.io < /tmp/mail.disk.report.sh.log
