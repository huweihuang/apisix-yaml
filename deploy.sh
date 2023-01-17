#!/bin/bash
set -ex

zone=$1
cd ${zone}
ls |xargs -I {} kubectl create -f {}
