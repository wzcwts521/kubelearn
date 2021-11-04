#! /bin/bash
namespace=pso-show-uns
direcotry=$(mktemp -d /tmp/foo.XXXXX)
bkfile=$(mktemp ${direcotry}/${namespace}.XXXXXX)
echo "Script location is: " $direcotry
kubectl -n pso-show-uns get ing -o jsonpath='{range .items[*]}{.metadata.name}{","}{.spec.rules[*].host}{","}{.spec.rules[*].http.paths[*].backend.serviceName}{"\n"}{end}' > ${bkfile}

for h in $(cat ${bkfile} )
do 
    ingressname=$(echo $h| cut -d "," -f 1)
    ingresshost=$(echo $h | cut -d "," -f 2)
    service=$(echo $h | cut -d "," -f 3)

    echo kubectl -n ${namespace} patch ing ${ingressname} --type='json' -p=\'[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"${ingresshost}\"}]\' >> ${direcotry}/rollback_command.sh
    echo kubectl -n ${namespace} patch ing ${ingressname} --type='json' -p=\'[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"${ingresshost}-bk\"}]\' >> ${direcotry}/update_command.sh

done

ls -tlr ${direcotry}/*
echo "Please run update.sh script."