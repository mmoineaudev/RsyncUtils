# Configuration : supprimez les valeurs des paramètres non souhaités

## Obligatoire
SOURCE:=/path/path/path # CheminAbsoluDuFSEmetteur
DESTINATION:=user@server:/path # URIVersLaCible # user@server:/path
SH:=-e # --rsh=sh # Permet de specifier le sh a utiliser chez la destination
##Facultatifs
RECURSIVE:=--recursive
RELATIVE:=--relative
NOTEMPCOPY:=--inplace
PROGRESS:=-P # implique --partial, --progress sinon
PROTOCOL:=ssh
TEMP_DIR:=--temp-dir=/tmp/rsynforbigfiles/ #a spécifier
COMPRESSION:=-z # on peut ajouter --compress-level=NUM (entre 0 et 9) 
REQUEST_TYPE:=--ipv6 # ou --ipv4 
CHECKSUM:=--checksum # Peut causer une grosse perte de perf. car impose la vérification bilaterale
DELETE:=--remove-source-files # ...chez le FS emetteur 
# ./metrics.sh rsyncforbigfiles.sh "--dry-run $(RECURSIVE) $(RELATIVE) $(SOURCE) $(DESTINATION)" metrics.log rsyncforbigfiles.out

dryrun-full:
	./rsyncforbigfiles.sh --dry-run $(SOURCE) $(DESTINATION) $(SH) $(RECURSIVE) $(RELATIVE) $(NOTEMPCOPY) $(PROGRESS) $(PROTOCOL) $(TEMP_DIR) $(COMPRESSION) $(REQUEST_TYPE) $(CHECKSUM) $(DELETE)

populate-test: 
	./metrics.sh createALotOfFiles.sh '1 2 3 4 5 6 lol' metrics.metrics out.out
clean-test-env:
	rm -rf ./test
	rm metrics.metrics
	rm out.out
