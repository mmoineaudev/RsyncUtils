#!/bin/bash 
$(mkdir test)
for aFile in {1..10000} 
do
	echo "${aFile} contenu de test" > "./test/${aFile}"
done 
echo 'done'
exit 0
