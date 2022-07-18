#!/bin/bash
# This script was written by Jaturong.S

# Setting up ENV
DIR="/home/eaadmin/kafkamirror/user/"
DIRCRED="/home/eaadmin/kafkamirror/cred"
SOURCE_HOST="kafka-dc-01"
TARGET_HOST="kafka-dr-01"
SOURCE_CLUSTER="kafka-dc"
TARGET_CLUSTER="kafka-dr"
echo "Please input Kafkauser"
read kafka_user
KAFKA_USER=THAIBEV-KAFKAUSER-$(echo $kafka_user | tr [:lower:] [:upper:])
FILE="$KAFKA_USER.yml"
FILE_DR="$KAFKA_USER-DR.yml"

# Updating YML file and apply Kafka configuration local
if [ -e $DIR$FILE ]; then
	echo "<-- Applying Kafkauser to $SOURCE_HOST -->"
	kubectl -n kafka apply -f $DIR$FILE
	echo "-----------------------------------------------------------------------------"
	sleep 5 # waiting for secret ready to use
else 
	echo "[FAILED]: Please check $FILE is exist in $DIR"
	exit 1
fi

# Getting Kafkauser's secret information
ssh $TARGET_HOST kubectl -n kafka get secret $kafka_user  
if [ $? -eq 0 ]; then
	echo "[FAILED]: user $kafka_user has already exist on $TARGET_CLUSTER"
	exit 1
fi
KAFKA_PASSWORD=$(kubectl -n kafka get secret $kafka_user -o jsonpath='{.data.password}' | base64 -d | sed 's/$/\n/') 
KAFKA_SASL=$(kubectl -n kafka get secret $kafka_user -o "jsonpath={.data['sasl\.jaas\.config']}" | base64 -d | sed 's/$/\n/')

# Creating secret generic to TARGET_HOST
echo "Updating generic file to $TARGET_HOST ==>"
echo $KAFKA_PASSWORD > $DIRCRED/password.txt && echo $KAFKA_SASL > $DIRCRED/sasl.txt
scp $DIRCRED/* $TARGET_HOST:$DIRCRED/.
echo "-----------------------------------------------------------------------------"
sleep 2
echo "Create secret generic to $TARGET_HOST with Kafkauser $kafka_user ==>"
ssh $TARGET_HOST kubectl -n kafka create secret generic $kafka_user \
  --from-file=password=$DIRCRED/password.txt \
  --from-file=sasl.jaas.config=$DIRCRED/sasl.txt
echo "-----------------------------------------------------------------------------"
sleep 2

# Changing target cluster YML file with sed and apply user to target host
sed "s/$SOURCE_CLUSTER/$TARGET_CLUSTER/g" "$DIR$FILE" > $DIR$FILE_DR
sleep 2
echo "<-- Updating target YML file and applying kafkauser to $TARGET_HOST -->"
scp $DIR$FILE_DR $TARGET_HOST:$DIR.
sleep 1
ssh $TARGET_HOST kubectl -n kafka apply -f $DIR$FILE_DR
echo "-----------------------------------------------------------------------------"

# Cleaning up dr and generic cred files
rm -r $DIRCRED/* && rm -f $DIR$FILE_DR
sleep 1
echo "<-- Removing cred file on $TARGET_HOST -->"
ssh $TARGET_HOST rm -r $DIRCRED/*
if [ $? -eq 0 ]; then
	echo "[COMPLETED]: Kafkauser has been registered"
	exit 0
else
    echo "[FAILED]: Cannot create Kafkauser"
	exit 1
fi

