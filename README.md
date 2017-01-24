# docker-presto
[![](https://images.microbadger.com/badges/image/smizy/presto:0.164-alpine.svg)](http://microbadger.com/images/smizy/presto:0.164-alpine "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/smizy/presto:0.164-alpine.svg)](http://microbadger.com/images/smizy/presto:0.164-alpine "Get your own version badge on microbadger.com")
[![CircleCI](https://circleci.com/gh/smizy/docker-presto.svg?style=svg&circle-token=3d2c669370e5ba45f558a1a4c8c8fdbd4125ab7f)](https://circleci.com/gh/smizy/docker-presto)

Presto docker image based on alpine

```
# network 
docker network create vnet

# load docker env as needed
eval $(docker-machine env default)

# run containers
docker-compose up -d

$ docker-compose ps
    Name                 Command            State           Ports          
--------------------------------------------------------------------------
coordinator-1   entrypoint.sh coordinator   Up      0.0.0.0:8080->8080/tcp 
worker-1        entrypoint.sh worker        Up                             
worker-2        entrypoint.sh worker        Up

# Querying JMX
docker-compose exec worker-1 presto --server coordinator-1.vnet:8080 

presto> SHOW TABLES FROM jmx.current;
                                        Table
---------------------------------------------------------------------------------
 com.facebook.presto.execution.scheduler:name=nodescheduler                                                                                       
 com.facebook.presto.execution.scheduler:name=splitschedulerstats                                                                                 
 com.facebook.presto.execution:name=queryexecution
  :
  :

presto> SELECT node, vmname, vmversion FROM jmx.current."java.lang:type=runtime";
                 node                 |          vmname          | vmversion  
--------------------------------------+--------------------------+------------
 0cac4a52-5ce8-4962-90f9-56aa5dde23fc | OpenJDK 64-Bit Server VM | 25.111-b14 
 24cc4bf5-453d-48f6-8084-9c1e7af133fa | OpenJDK 64-Bit Server VM | 25.111-b14 
 fffa7505-a86d-4613-9f20-f5e779366fbd | OpenJDK 64-Bit Server VM | 25.111-b14 
(3 rows)

Query 20170105_045632_00017_ep8ih, FINISHED, 3 nodes
Splits: 4 total, 4 done (100.00%)
0:01 [3 rows, 210B] [4 rows/s, 342B/s]

presto> SELECT openfiledescriptorcount, maxfiledescriptorcount FROM jmx.current."java.lang:type=operatingsystem";
 openfiledescriptorcount | maxfiledescriptorcount 
-------------------------+------------------------
                     969 |                1048576 
                    1018 |                1048576 
                     967 |                1048576 
(3 rows)

Query 20170105_045816_00019_ep8ih, FINISHED, 3 nodes
Splits: 4 total, 4 done (100.00%)
0:01 [3 rows, 48B] [5 rows/s, 89B/s]

presto> exit

# CLUSTER OVERVIEW UI
open http://$(docker-machine ip default):8080

# cleanup
docker-compose stop
docker-compose rm -fv
```

