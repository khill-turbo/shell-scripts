set +x

##  Set The SHORT_SHA1 From File Or Repository  ##
if [ -f "$SHA1_FILE" ]; then
    SHORT_SHA1=$(<${SHA1_FILE})
elif [ "$P4_CHANGELIST" != "" ]; then
    SHORT_SHA1=$P4_CHANGELIST
else
    SHORT_SHA1=${GIT_COMMIT:0:10}
fi

if [ "$SUBDIR" != "" ]; then
    FILE_PATH=$WORKSPACE/src
else
    FILE_PATH=$WORKSPACE
fi

##  This is required for 2.x projects with branch attached to JOB_NAME
if [ "$JOB_TOP_NAME" == "" ]; then
    JOB_TOP_NAME=$JOB_NAME
fi

##  Creates message that appears next to each build  ##
echo "BUILD DESCRIPTION IS $SHORT_SHA1<br>$SCA_VM_OPTS"

FORTIFY_BUILD_ID=$JOB_TOP_NAME-$BUILD_NUMBER-$SHORT_SHA1
echo FORTIFY_BUILD_ID is $FORTIFY_BUILD_ID

FORTIFY_TMPDIR=$FILE_PATH/FORTIFY_TMP
mkdir -pv $FORTIFY_TMPDIR
echo FORTIFY_TMPDIR is $FORTIFY_TMPDIR

##  For XYZ (or similiar project) use file:MOD_SCAN_DIR to modify SCAN_DIRS  ##
if [ "$MOD_SCAN_DIR" != "" ]; then
  VERSION_REPORT=$(<$MOD_SCAN_DIR)
  echo VERSION_REPORT is $VERSION_REPORT
  if [ "$VERSION_NAME" == "ABC:XYZ" ]; then
    SCAN_DIRS=$FILE_PATH/"v2"/$VERSION_REPORT
  else
    SCAN_DIRS=$FILE_PATH/$VERSION_REPORT
  fi
elif [ "$SCAN_DIRS" == "" ]; then
  SCAN_DIRS=$WORKSPACE
fi

echo SCAN_DIRS is $SCAN_DIRS

echo VERSION_NAME is $VERSION_NAME
if [ "$EXCLUDE" != "" ]; then echo EXCLUDE is $EXCLUDE; fi
if [ "$SKIP_UPLOAD" != "" ]; then echo SKIP_UPLOAD is $SKIP_UPLOAD; fi

echo "**  Fortify Scan  **"
sourceanalyzer \
  $SCA_VM_OPTS \
  -Dcom.fortify.sca.ProjectRoot=$FORTIFY_TMPDIR \
  $EXCLUDE \
  -exclude $FORTIFY_TMPDIR \
  -exclude "**/*.min.js" \
  -debug-verbose \
  -scan -f $FORTIFY_BUILD_ID.fpr \
  -logfile $FORTIFY_BUILD_ID.log \
  $SCAN_DIRS

##  Verify .fpr file was successfully created  ##
if [ ! -f $FILE_PATH/$FORTIFY_BUILD_ID.fpr ]; then echo "File not found!"; exit 1; fi

echo "**  Upload .fpr File to Foritfy Server  **"
if [ "$SKIP_UPLOAD" != "true" ]; then
    fortifyclient \
      -url $FORTIFY_SERVER \
      -authtoken $FORTIFY_AUTH_KEY \
      uploadFPR -file $FORTIFY_BUILD_ID.fpr \
      -project EXDG \
      -version $VERSION_NAME
fi

