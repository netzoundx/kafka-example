# Enable cdc on SQL database
1. คำสั่ง enable database ==>  exec sys.sp_cdc_enable_db
2. คำสั่ง enable table
            EXEC sys.sp_cdc_enable_table  
            @source_schema = N'dbo',  
           @source_name   = N'TB_VSMS_Paymen,  
           @role_name     = NULL

3. คำสั่ง disable database ==> exec sys.sp_cdc_disable_db 
4. คำสั่ง disable table
EXECUTE sys.sp_cdc_disable_table   
    @source_schema = N'dbo',   
    @source_name = N'TB_VSMS_Payment',  
    @capture_instance = N'dbo_TB_VSMS_Payment'; 
    
# Kafka Useful command
kubectl exec -ti kafka-cluster-uat-kafka-0 -n kafka -- bash
/bin/kafka-console-consumer.sh --bootstrap-server 10.7.38.202:9094 --topic ptp-rptdb-bp2p-buzpartner demo-topic --from-beginning --consumer.config /tmp/ptp-user.properties
/bin/kafka-consumer-groups.sh --bootstrap-server 10.7.39.202:9094 --describe --group ptp-crossbuy-materialmanagement-materialgroup --command-config /tmp/crossbuy.properties
bash kafka-consumer-groups.sh --bootstrap-server 10.7.37.202:9094 --describe --group materialmanagement-ptp-purchasemanagement-purchasegroup --command-config /tmp/materialmanagement.properties
/bin/kafka-console-consumer.sh --bootstrap-server 10.7.38.202:9094 --topic ptp-rptdb-bp2p-buzpartner --from-beginning --consumer.config /tmp/ptp-rptdb.properties
/bin/kafka-consumer-groups.sh --bootstrap-server 10.7.38.202:9094 --describe --group rptdb-ptp-serviceptpreporting-ptp-rptdb-bp2p-buzpartner --command-config /tmp/ptp-user.properties
kafka-consumer-groups.sh --bootstrap-server 10.7.39.202:9094 --describe --group ptp-crossbuy-materialmanagement-material --command-config /tmp/crossbuy.properties
kafka-console-consumer.sh --bootstrap-server 10.7.37.202:9094 --topic materialmanagement-material --consumer.config /tmp/materialmanagement.properties
kafka-console-producer.sh --bootstrap-server 10.7.37.202:9094 --topic kafka-otc-test --producer.config /tmp/otc/rptdb.properties
bin/kafka-console-consumer.sh --bootstrap-server 10.7.38.202:9094 --topic topic-name-1 --consumer.config /tmp/producer.properties --group testgroup01 --from-beginning
kafka-consumer-groups.sh --bootstrap-server 10.7.37.202:9094 --group mdm-materialmanagement-material --command-config /tmp/mdm-mm.properties --describe
bash kafka-consumer-groups.sh --bootstrap-server 10.7.35.202:9094 --group ptp-rptdb-finance-company --reset-offsets --command-config /tmp/ptp-rptdb.properties --to-datetime 2022-04-01T00:00:00.000 --topic finance-company --execute
bash kafka-consumer-groups.sh --bootstrap-server 10.7.35.202:9094 --group ptp-rptdb-finance-plant --reset-offsets --command-config /tmp/ptp-rptdb.properties --to-earliest --topic finance-plant --execute

# KCTR useful cmd
Usage
curl -X PUT http://localhost:8083/connectors/connector-otc-vsms-cdctestdb-fruit/pause
curl -X GET http://localhost:8083/connectors/connector-otc-vsms-cdctestdb-fruit/status | grep state
curl -X POST http://localhost:8083/connectors/connector-otc-vsms-cdctestdb-fruit/restart
curl -X POST http://localhost:8083/connectors/connector-otc-vsms-cdctestdb-fruit/tasks/0/restart
curl -X PUT http://localhost:8083/connectors/connector-otc-vsms-cdctestdb-fruit/resume


    

