JOBID=5400

while /bin/true; do date;sstat -a  --format \
"jobid,MaxVMSize,MaxDiskRead,MaxDiskWrite" $JOBID; sleep 10; done
