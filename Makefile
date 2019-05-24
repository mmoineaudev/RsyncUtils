# Configuration : supprimez les valeurs des paramètres non souhaités

## Obligatoire
SOURCE:=/home/asus/Desktop/work/RsyncUtils/test # CheminAbsoluDuFSEmetteur
DESTINATION:=miagem1@192.168.43.192:/tmp # URIVersLaCible # user@server:/path
SH:=-e #--rsh=ksh # Permet de specifier le sh a utiliser chez la destination
##Facultatifs
TEST:=--dry-run # permet d'executer sans moifications
RECURSIVE:=--recursive #
RELATIVE:=--relative #
NOTEMPCOPY:=--inplace #
PROGRESS:=-P # implique --partial, --progress sinon
PROTOCOL:=ssh #
TEMP_DIR:=--temp-dir=/tmp/rsyncforbigfiles/ #a spécifier
COMPRESSION:=-z # on peut ajouter --compress-level=NUM (entre 0 et 9) 
CHECKSUM:=--checksum # Peut causer une grosse perte de perf. car impose la vérification bilaterale
DELETE:=--remove-source-files # ...chez le FS emetteur 
# ./metrics.sh rsyncforbigfiles.sh "--dry-run $(RECURSIVE) $(RELATIVE) $(SOURCE) $(DESTINATION)" metrics.log rsyncforbigfiles.out

#Default 
#make clean-test-env populate-test dryrun-full
#make populate-test dryrun-full

minimum-ssh:
	./metrics.sh rsyncforbigfiles.sh '-v $(SH)$(PROTOCOL)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)' rsync.metrics rsync.out

compression-ssh:
	./metrics.sh rsyncforbigfiles.sh '-v $(SH)$(PROTOCOL)$(COMPRESSION)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)' rsync.metrics rsync.out

compression-ssh-checksum:
	./metrics.sh rsyncforbigfiles.sh '-v $(SH)$(PROTOCOL)$(COMPRESSION)$(CHECKSUM)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)' rsync.metrics rsync.out

ssh-checksum:
	./metrics.sh rsyncforbigfiles.sh '-v $(SH)$(PROTOCOL)$(CHECKSUM)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)' rsync.metrics rsync.out

populate-test: 
	./createALotOfFiles.sh 1 2 3 4 5 6 7 8 9

clean:
	rm -rf ./test
	rm *.metrics
	rm *.out
