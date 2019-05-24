# !/bin/ksh 

#################################################################################
##  rsyncforbigfiles construit la ligne de paramètres de rsync
##   et l'appelle
##   --dry-run permet d'éviter les actions destructives pour le test
##  
##  
#################################################################################
# Declaration de variables
PARAMS=''


for param in $@
do
 PARAMS="$PARAMS $param"
done
echo $PARAMS


# Execution 
echo $(rsync $PARAMS)
echo 'Script done'
exit 0;