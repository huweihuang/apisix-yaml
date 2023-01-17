#!/bin/bash
set -e


ZONE=
ETCD_IP1=
ETCD_IP2=
ETCD_IP3=

function usage(){
	shellname="`echo ${0##*/}`"

	echo -e "usage:
	-h                显示帮助
	-z [zone]         部署区域
	-a [etcd_ip1]     Etcd节点1的IP
	-b [etcd_ip2]     Etcd节点2的IP
	-c [etcd_ip3]     Etcd节点3的IP
"

	echo "example:

bash gen-apisix-yaml.sh -z <zone> -a <etcd_ip1> -b <etcd_ip2> -c <etcd_ip3>
"
	exit
}


while getopts ":z:a:b:c:h" opt
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
       	h) usage;;
        *) usage;;
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
