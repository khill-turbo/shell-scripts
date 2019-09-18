##  This script finds inactive projects (optionally also list all active NodeJS projects)

##  REQUIRED: Inject environment variables to the build process
# example:
# URL=https://SERVER.com/job/
# BASE_DIR=builds or BASE_DIR=jobs
# SYMLINKS_DIR= or SYMLINKS_DIR=builds/

##  REQUIRED for generating a list of active NodeJS projects
# example:
# NODE_ACTIVE_LIST=true or NODE_ACTIVE_LIST=


echo "****  Creating a file of disabled projects  ****"
##  Running the find command in jobs directory to keep path out of list
cd ${JENKINS_HOME}/jobs
find . -name 'config.xml' -type f -exec grep -i '<disabled>true</disabled>' {} \; -print > ${WORKSPACE}/disabled_jobs_edit1

cd ${WORKSPACE}
##  Remove all lines with diabled
sed '/disabled/d' ${WORKSPACE}/disabled_jobs_edit1 > ${WORKSPACE}/disabled_jobs_edit2

##  Remove all instances of config.xml
sed 's/config.xml//g' ${WORKSPACE}/disabled_jobs_edit2 > ${WORKSPACE}/disabled_jobs_edit3

##  Remove all instances of ./ (at beginning of directory)
sed 's/\.\///g' ${WORKSPACE}/disabled_jobs_edit3 > ${WORKSPACE}/disabled_jobs
rm ${WORKSPACE}/disabled_jobs_edit*

##  Put in alphabetical order for comparision step
sort ${WORKSPACE}/disabled_jobs -o ${WORKSPACE}/disabled_jobs



echo "****  Creating a file of all projects  ****"
##  Run the find command in "jobs" directory to keep path out of file
cd ${JENKINS_HOME}/jobs
ls -d */ > ${WORKSPACE}/all_jobs

cd ${WORKSPACE}
##  Put in alphabetical order for comparision step
sort ${WORKSPACE}/all_jobs -o ${WORKSPACE}/all_jobs


echo "****  Creating file of all enabled projects  ****"
grep -F -x -v -f ${WORKSPACE}/disabled_jobs ${WORKSPACE}/all_jobs > ${WORKSPACE}/enabled_jobs

echo "****  Find all inactive projects  ****"
ENABLED_JOBS=$(<${WORKSPACE}/enabled_jobs)
##  Convert string to array
arr=(${ENABLED_JOBS})
##  Need to be in specific directory for BUILDS_RUN find command
cd ${JENKINS_HOME}/${BASE_DIR}
##  Loop through all of the directories
for i in "${arr[@]}"
do
    INACTIVTY_COUNTER=0
    ##  Get the number of builds run
    BUILDS_RUN=`find ${i}${SYMLINKS_DIR} -maxdepth 1 -type d | wc -l`
    ##  The "builds" directory always has "legacyIds" in it, so set gt 1
    if [ "${BUILDS_RUN}" -gt 1 ]; then

        # test if link exists
        if [ -L "${i}${SYMLINKS_DIR}lastSuccessfulBuild" ]; then
            # test if link is older than 6 months, then increment inactivity counter
            if [[ $(find "${i}${SYMLINKS_DIR}lastSuccessfulBuild" -mtime +182 -print) ]]; then
                ((INACTIVTY_COUNTER=INACTIVTY_COUNTER+1))
            fi
        fi

        if [ -L "${i}${SYMLINKS_DIR}lastFailedBuild" ]; then
            if [[ $(find "${i}${SYMLINKS_DIR}lastFailedBuild" -mtime +182 -print) ]]; then
                ((INACTIVTY_COUNTER=INACTIVTY_COUNTER+1))
            fi
        fi

        if [ -L "${i}${SYMLINKS_DIR}lastUnstableBuild" ]; then
            if [[ $(find "${i}${SYMLINKS_DIR}lastUnstableBuild" -mtime +182 -print) ]]; then
                ((INACTIVTY_COUNTER=INACTIVTY_COUNTER+1))
            fi
        fi

        ## If all 3 links are older than 6 months then add that project to the inactive list
        if [ "${INACTIVTY_COUNTER}" -gt 2 ]; then
            ##  Add to inactive list
            INACTIVE+=(${URL}${i})
            INACTIVE_JOBS+=(${i})
        fi

    else
        ##  If no builds run then save the list but skip having to check links
        NOBUILDS+=(${URL}${i})
        NOBUILDS_JOBS+=(${i})
    fi
done



echo "****  Process files  ****"
cd ${WORKSPACE}
##  Echo arrary contents into files
echo ${INACTIVE[@]} | sed 's/ /\n/g' > ${WORKSPACE}/inactive_urls
echo ${NOBUILDS[@]} | sed 's/ /\n/g' > ${WORKSPACE}/no_builds_urls
echo ${INACTIVE_JOBS[@]} | sed 's/ /\n/g' > ${WORKSPACE}/inactive_jobs
echo ${NOBUILDS_JOBS[@]} | sed 's/ /\n/g' > ${WORKSPACE}/no_builds_jobs

##  Combine lists to know which projects don't need to be maintained
cat ${WORKSPACE}/inactive_jobs ${WORKSPACE}/no_builds_jobs > ${WORKSPACE}/all_inactive_jobs

##  Put in alphabetical order for comparision step and display
sort ${WORKSPACE}/inactive_urls -o ${WORKSPACE}/inactive_urls
sort ${WORKSPACE}/no_builds_urls -o ${WORKSPACE}/no_builds_urls
sort ${WORKSPACE}/all_inactive_jobs -o ${WORKSPACE}/all_inactive_jobs



echo "****  Display lists created  ****"
echo ""
sed -i '1s/^/Inactive projects: no builds in 6 months or longer. \n/' ${WORKSPACE}/inactive_urls
cat ${WORKSPACE}/inactive_urls

echo ""
sed -i '1s/^/Never run projects. \n/' ${WORKSPACE}/no_builds_urls
cat ${WORKSPACE}/no_builds_urls
echo ""



if [ "${NODE_ACTIVE_LIST}" == "true" ]; then
    
    echo "****  Creating a file of projects using NodeJS plugin  ****"
    ##  Running the find command in jobs directory to keep path out of list
    cd ${JENKINS_HOME}/jobs
    find . -name 'config.xml' -type f -exec grep -i 'nodeJSInstallationName' {} \; -print > ${WORKSPACE}/nodejs_jobs_edit1

    cd ${WORKSPACE}
    ##  Remove all instances of nodejs
    sed '/nodeJSInstallationName/d' ${WORKSPACE}/nodejs_jobs_edit1 > ${WORKSPACE}/nodejs_jobs_edit2

    ##  Remove all instances of config.xml
    sed 's/config.xml//g' ${WORKSPACE}/nodejs_jobs_edit2 > ${WORKSPACE}/nodejs_jobs_edit3

    ##  Remove ./ at beginning of directory
    sed 's/\.\///g' ${WORKSPACE}/nodejs_jobs_edit3 > ${WORKSPACE}/nodejs_jobs
    rm ${WORKSPACE}/nodejs_jobs_edit*

    ##  Put in alphabetical order for comparision step
    sort ${WORKSPACE}/nodejs_jobs -o ${WORKSPACE}/nodejs_jobs


    echo "****  Process files  ****"
    echo "****  Creating a file of all enabled nodejs projects  ****"
    ##  Creates a file of nodejs directories minus the deactivated ones
    grep -F -x -v -f ${WORKSPACE}/disabled_jobs ${WORKSPACE}/nodejs_jobs > ${WORKSPACE}/nodejs_enabled_jobs

    echo "****  Creating a file of active nodejs projects  ****"
    grep -F -x -v -f ${WORKSPACE}/all_inactive_jobs ${WORKSPACE}/nodejs_enabled_jobs > ${WORKSPACE}/active_nodejs_jobs

    ##  Convert list of projects to list of URLs
    NODEJSLIST=$(<${WORKSPACE}/active_nodejs_jobs)
    arr=(${NODEJSLIST})
    for i in "${arr[@]}"
    do
        ARRAY+=(${URL}${i})
    done
    echo ${ARRAY[@]} | sed 's/ /\n/g' > ${WORKSPACE}/active_nodejs_urls



    echo "****  Display lists created  ****"
    echo ""
    sed -i '1s/^/Projects using NodeJS. \n/' ${WORKSPACE}/active_nodejs_urls
    cat ${WORKSPACE}/active_nodejs_urls
    echo ""

fi
