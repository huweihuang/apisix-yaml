#!/bin/bash
set -ex

# example:
# bash gen-apisix-yaml.sh -z <zone> -a <etcd_ip1> -b <etcd_ip2> -c <etcd_ip3>

ZONE=
ETCD_IP1=
ETCD_IP2=
ETCD_IP3=
APISIX_ADDR=

while getopts ":z:a:b:c:d:h" opt
do
    case $opt in
        z) ZONE=$OPTARG
        echo "ZONE value: $OPTARG"
        ;;
        a) ETCD_IP1=$OPTARG
        echo "ETCD_IP1 value: $OPTARG"
        ;;        
        b) ETCD_IP2=$OPTARG
        echo "ETCD_IP2 value: $OPTARG"
        ;;                    
        c) ETCD_IP3=$OPTARG
        echo "ETCD_IP3 value: $OPTARG"
        ;;
        h)
        echo "bash gen-apisix-yaml.sh -z <zone> -a <etcd_ip1> -b <etcd_ip2> -c <etcd_ip3>"
        ;;
        ?)
        echo "invalid arg"
        exit 1;;
    esac
done

# clean and copy
echo "Remove ${ZONE}"
rm -fr ${ZONE}
cp -fr template ${ZONE}

# update config
echo "Replace Args"
sed -i "s|_ZONE_|${ZONE}|;
s|_ETCD_IP1_|${ETCD_IP1}|;
s|_ETCD_IP2_|${ETCD_IP2}|;
s|_ETCD_IP3_|${ETCD_IP3}|" ./${ZONE}/*/*
