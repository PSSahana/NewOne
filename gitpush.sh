#!/bin/bash
git status|tee log.txt >> /dev/null 2>&1
git add .|tee -a log.txt >> /dev/null 2>&1
echo Hello, Pls enter commit message
read varname
git commit -m "$varname"|tee -a log.txt >> /dev/null 2>&1
git push|tee -a log.txt >> /dev/null 2>&1
retVal=$?
if [ $retVal -ne 0 ]
then
    echo "Error"
else
    echo "Success"
fi
exit $retVal