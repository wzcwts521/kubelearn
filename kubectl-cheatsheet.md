kubectl 
```
 kk get pods -A -o jsonpath='{range .items[*]}{.spec.containers[*].name}{"\t"}{.spec.containers[*].image}{"\n"}{end}'| sort |uniq |egrep "${registry_name}"
 ```