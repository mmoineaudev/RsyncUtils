# Configuration : supprimez les valeurs des paramètres non souhaités

# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
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
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #


# ## ## ## ## ## ## ## ##CONFIGURATIONS ENVISAGEES## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
MINIMUMSSH:=-v $(SH)$(PROTOCOL)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)
COMPRESSIONSSH:=-v $(SH)$(PROTOCOL)$(COMPRESSION)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)
COMPRESSIONSSHCHECKSUM:=-v $(SH)$(PROTOCOL)$(COMPRESSION)$(CHECKSUM)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)
SSHCHECKSUM:=-v $(SH)$(PROTOCOL)$(CHECKSUM)$(RECURSIVE)$(PROGRESS)$(SOURCE)$(DESTINATION)
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #

# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
# Règles sans emission de metrics
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #


minimum-ssh:
	rsync $(MINIMUMSSH)

compression-ssh:
	rsync $(COMPRESSIONSSH)

compression-ssh-checksum:
	rsync $(COMPRESSIONSSHCHECKSUM)

ssh-checksum:
	rsync $(SSHCHECKSUM)

# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
# Règles sans emission de metrics, sans écriture/supression (pour le test)
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #


minimum-ssh-dryrun:
	rsync --dry-run $(MINIMUMSSH)

compression-ssh-dryrun:
	rsync --dry-run $(COMPRESSIONSSH)

compression-ssh-checksum-dryrun:
	rsync --dry-run $(COMPRESSIONSSHCHECKSUM)

ssh-checksum-dryrun:
	rsync --dry-run $(SSHCHECKSUM)


# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
# Règles avec les metrics pour le benchmarck 
# (/!\incertitude relative au temps pour taper le password importante pour les petits transferts)
# Negligeable pour plusieurs gO
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #

minimum-ssh-benchmark:
	./metrics.sh rsyncforbigfiles.sh '$(MINIMUMSSH)' rsync.metrics rsync.out

compression-ssh-benchmark:
	./metrics.sh rsyncforbigfiles.sh '$(COMPRESSIONSSH)' rsync.metrics rsync.out

compression-ssh-checksum-benchmark:
	./metrics.sh rsyncforbigfiles.sh '$(COMPRESSIONSSHCHECKSUM)' rsync.metrics rsync.out

ssh-checksum-benchmark:
	./metrics.sh rsyncforbigfiles.sh '$(SSHCHECKSUM)' rsync.metrics rsync.out

# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
# Règles utilitaires pour le benchmark
# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #

populate-test: 
	./createALotOfFiles.sh 1 2 3 4 5 6 7 8 9

clean:
	rm -rf ./test
	rm *.metrics
	rm *.out
