#!/bin/bash
HADOOP="/Users/pivotal/workspace/singlecluster/bin/hdfs dfs"
LOGFILE="/tmp/gpbackup_hdfs_plugin.log"
touch $LOGFILE 2>&1


setup_plugin_for_backup(){
  echo "setup_plugin_for_backup $1 $2 $3 $4" >> /tmp/plugin_out.txt
  if [ "$3" = "master" ]
    then echo "setup_plugin_for_backup was called for scope = master" >> /tmp/plugin_out.txt
  elif [ "$3" = "segment_host" ]
    then echo "setup_plugin_for_backup was called for scope = segment_host" >> /tmp/plugin_out.txt
  elif [ "$3" = "segment" ]
    then echo "setup_plugin_for_backup was called for scope = segment" >> /tmp/plugin_out.txt
  fi
  timestamp_dir=`basename "$2"`
  timestamp_day_dir=${timestamp_dir%??????}
  $HADOOP -mkdir -p /gphack/$timestamp_day_dir/$timestamp_dir >> $LOGFILE 2>&1
}

setup_plugin_for_restore(){
  echo "setup_plugin_for_restore $1 $2 $3 $4" >> $LOGFILE 2>&1
  if [ "$3" = "master" ]
    then echo "setup_plugin_for_restore was called for scope = master" >> $LOGFILE 2>&1
  elif [ "$3" = "segment_host" ]
    then echo "setup_plugin_for_restore was called for scope = segment_host" >> $LOGFILE 2>&1
  elif [ "$3" = "segment" ]
    then echo "setup_plugin_for_restore was called for scope = segment" >> $LOGFILE 2>&1
  fi
}

cleanup_plugin_for_backup(){
  :
}

cleanup_plugin_for_restore(){
  :
}

restore_file() {
  echo "restore_file $1 $2" >> $LOGFILE 2>&1
  filename=`basename "$2"`
  timestamp_dir=`basename $(dirname "$2")`
  timestamp_day_dir=${timestamp_dir%??????}
	$HADOOP -get /gphack/$timestamp_day_dir/$timestamp_dir/$filename $2 >> $LOGFILE 2>&1
  exit $?
}

backup_file() {
  echo "backup_file $1 $2" >> $LOGFILE 2>&1
  filename=`basename "$2"`
  timestamp_dir=`basename $(dirname "$2")`
  timestamp_day_dir=${timestamp_dir%??????}
	$HADOOP -put $2 /gphack/$timestamp_day_dir/$timestamp_dir/$filename >> $LOGFILE 2>&1
  exit $?
}

backup_data() {
  echo "backup_data $1 $2" >> $LOGFILE 2>&1
  filename=`basename "$2"`
  timestamp_dir=`basename $(dirname "$2")`
  timestamp_day_dir=${timestamp_dir%??????}
	$HADOOP -put - /gphack/$timestamp_day_dir/$timestamp_dir/$filename >> $LOGFILE 2>&1
  exit $?
}

restore_data() {
  echo "restore_data $1 $2" >> $LOGFILE 2>&1
  filename=`basename "$2"`
  timestamp_dir=`basename $(dirname "$2")`
  timestamp_day_dir=${timestamp_dir%??????}
	$HADOOP -cat /gphack/$timestamp_day_dir/$timestamp_dir/$filename
  exit $?
}

delete_backup() {
  echo "delete_backup $1 $2" >> $LOGFILE 2>&1
  timestamp_day_dir=${2%??????}
  $HADOOP -rm -r /gphack/$timestamp_day_dir/$2 >> $LOGFILE 2>&1
  if [ -z "$(ls -A /gphack/$timestamp_day_dir/)" ] ; then
    $HADOOP -rm -r /gphack/$timestamp_day_dir >> $LOGFILE 2>&1
  fi
  exit $?
}

plugin_api_version(){
  echo "1.0.0"
  echo "1.0.0" >> $LOGFILE 2>&1
}

--version(){
  echo "gpbackup_hdfs_plugin version 1.0.0"
  echo "gpbackup_hdfs_plugin version 1.0.0" >> $LOGFILE 2>&1
}

"$@"
