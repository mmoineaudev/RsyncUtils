#!/bin/bash 

for aFile in {1..100} 
do
	echo "${aFile} contenu de test" > "./test/${aFile}"
done 
echo 'done'
exit 0
