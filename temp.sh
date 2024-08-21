#!/bin/bash

COUNT=$(helm list -A --filter argocd  |wc -l |sed 's/ //g')
echo $COUNT

if [ $COUNT == 2 ];then
echo equal
else
echo not equal
fi
