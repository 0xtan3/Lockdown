#TODO: setup a cronjob that would dump the sql data and take a backup of the encrypted image file in a monthly basis

DUMP="$2"

# export data

sqlite3 <location of the file>
.output ./backup.sql
.dump
.exit

# import data

sqlite3 <location of the file>
.read ./backup.sql
.exit