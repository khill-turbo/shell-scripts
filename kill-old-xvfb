# list xvfb processes running
/bin/ps -aefw | grep xvfb

# if KILL_PID is set then kill that PID
if [ "${KILL_PID}" != "" ]; then
  echo "KILL_PID is set to: " ${KILL_PID}
#  kill ${KILL_PID}
fi

# gets list of all xvfb processes
# looks at the time of each xvfb process
# if older than 8 hours = 28800 secconds then kill it
for i in $(pgrep -f xvfb)
do
    TIME=$(ps --no-headers -o etimes $i)
    if [ "$TIME" -ge 288000 ] ; then
        echo ""
        echo "killing process: " $i
        echo ""
#        kill $i
    fi
done
