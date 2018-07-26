#!/bin/bash

ssh radius2 "docker login docker0.unxs.io:5000 -p aksjdhaskdh -u 9384hfr"
ssh radius3 "docker login docker0.unxs.io:5000 -p aksjdhaskdh -u 9384hfr"

ssh radius2 "rm -rf /data";
scp -r /data radius2:/ ;
ssh radius3 "rm -rf /data";
scp -r /data radius3:/ ;
