#!/bin/bash

ssh radius2 "rm -rf /data";
scp -r /data radius2:/ ;
ssh radius3 "rm -rf /data";
scp -r /data radius3:/ ;
