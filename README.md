# Using the HDFS Storage Plugin with gpbackup and gprestore
The HDFS plugin lets you use Hadoop Districbuted File System (HDFS) to store and retrieve backups when you run gpbackup and gprestore.

To use the HDFS plugin, you specify the location of the plugin. When you run gpbackup or gprestore, you specify the configuration file with the option --plugin-config.

If you perform a backup operation with the gpbackup option --plugin-config, you must also specify the --plugin-config option when you restore the backup with gprestore.


## Pre-Requisites
- Hadoop HDFS client installed on the greenplum cluster (coorindator and segments).
- Make sure you modify the `executablepath` in the `hdfs_plugin_config.yaml` file based on the absolute path of the `hdfs_plugin.bash` script.


## Backup
Below command backups database `testdb` from gpdb to HDFS.
```
gpbackup --dbname testdb --plugin-config hdfs_plugin_config.yaml
```

## Restore
Below command restores data from HDFS into gpdb database `restoredb`
```
gprestore --timestamp <YOUR_BACKUP_TIMESTAMP> --plugin-config hdfs_plugin_config.yaml --redirect-db restoredb --create-db
```
