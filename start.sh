pause_for () {
  for (( c=1; c<=$1; c++ ))
  do
     sleep 1 && echo "."
  done
}

cd ..

PROJ_DIR=`pwd`
DOCKER_DIR="${PROJ_DIR}/docker"
DATA_DIR="${PROJ_DIR}/data"

# Shut down and remove any currently-running docker containers
cd $DOCKER_DIR
docker container ls --all
echo -e '\n\n===================== Killing old containers =====================\n\n'
docker kill $(docker ps -q)

echo -e '\n\n===================== Removing old containers =====================\n\n'
docker rm $(docker ps -a -q)
pause_for 3

# Start mysql
echo -e '\n\n===================== Starting scsb-mysql =====================\n\n'
cd scsb-mysql
docker build -t scsb-mysql . & PID_1_1=$! # Save the process ID
pause_for 3
docker run --name scsb-mysql -v $DATA_DIR/mysql-dev-data:/var/lib/mysql -p 3306:3306 -d scsb-mysql & PID_1_2=$! # Save the process ID
pause_for 3

# Start activemq
echo -e '\n\n===================== Starting scsb-activemq =====================\n\n'
cd ..
cd scsb-activemq
docker build -t scsb-activemq . & PID_2_1=$! # Save the process ID
pause_for 3
docker run --name scsb-activemq -v $DATA_DIR/activemq-dev-data:/opt/activemq/data -p 8161:8161 -p 61616:61616 -p 1099:1099 -e "DB_URL=jdbc:mysql://localhost:3306/recapactivemq?relaxAutoCommit=true" -e "DB_USERNAME=recap" -e "DB_PASSWORD=recap" -e "USERS=admin: admin, admin" -d scsb-activemq & PID_2_2=$! # Save the process ID
pause_for 3

# Start solr server
echo -e '\n\n===================== Starting scsb-solr-server =====================\n\n'
cd ..
cd scsb-solr-server
docker build -t scsb-solr-server . & PID_3_1=$! # Save the process ID
pause_for 3
docker run --name scsb-solr-server -v $DATA_DIR/solr-data:/var/data/solr -p 8983:8983 -d scsb-solr-server -e "ENV=-m 4g" & PID_3_2=$! # Save the process ID
pause_for 3

# Start solr client
echo -e '\n\n===================== Starting scsb-solr-client =====================\n\n'
cd ..
cd scsb-solr-client
docker build -t scsb-solr-client . & PID_4_1=$! # Save the process ID
pause_for 3
docker run --name scsb-solr-client --link scsb-mysql:scsb-mysql --link scsb-solr-server:scsb-solr-server --link scsb-activemq:scsb-activemq -v $DATA_DIR:/recap-vol -p 9090:9090 -e "ENV=-XX:+HeapDumpOnOutOfMemoryError -Dorg.apache.activemq.SERIALIZABLE_PACKAGES="" -Dspring.profiles.active=local-container -Dspring.config.location=/recap-vol/config/application.properties" -d scsb-solr-client & PID_4_2=$! # Save the process ID
pause_for 3

# Start scsb
echo -e '\n\n===================== Starting scsb =====================\n\n'
cd ..
cd scsb
docker build -t scsb-scsb . & PID_5_1=$! # Save the process ID
pause_for 3
docker run --name scsb --link scsb-mysql:scsb-mysql --link scsb-activemq:scsb-activemq --link scsb-solr-client:scsb-solr-client -v $DATA_DIR:/recap-vol -p 9093:9093 -e "ENV=-XX:+HeapDumpOnOutOfMemoryError -Dspring.profiles.active=local-container -Dspring.config.location=/recap-vol/config/application.properties -Djsse.enableSNIExtension=false -Dorg.apache.activemq.SERIALIZABLE_PACKAGES=""" -d scsb-scsb & PID_5_2=$! # Save the process ID
pause_for 3

# Start shiro
echo -e '\n\n===================== Starting scsb-shiro =====================\n\n'
cd ..
cd scsb-shiro
docker build -t scsb-shiro . & PID_6_1=$! # Save the process ID
pause_for 3
docker run --name scsb-shiro --link scsb-mysql:scsb-mysql --link scsb:scsb -v $DATA_DIR:/recap-vol -p 9092:9092 -e "ENV=-XX:+HeapDumpOnOutOfMemoryError -Dspring.profiles.active=local-container -Dspring.config.location=/recap-vol/config/application.properties" -d scsb-shiro & PID_6_2=$! # Save the process ID
pause_for 3

# Start the UI
echo -e '\n\n===================== Starting scsb-ui =====================\n\n'
cd ..
cd scsb-ui
docker build -t scsb-ui . & PID_7_1=$! # Save the process ID
pause_for 3
docker run --name scsb-ui --link scsb-mysql:scsb-mysql --link scsb:scsb --link scsb-shiro:scsb-shiro -v $DATA_DIR:/recap-vol -p 9091:9091 -e "ENV=-XX:+HeapDumpOnOutOfMemoryError -Dspring.profiles.active=local-container -Dspring.config.location=/recap-vol/config/application.properties" -d scsb-ui & PID_7_2=$! # Save the process ID
pause_for 3

docker container ls --all

wait $PID_1_1 $PID_1_2 $PID_2_1 $PID_2_2 $PID_3_1 $PID_3_2 $PID_4_1 $PID_4_2 $PID_5_1 $PID_5_2 $PID_6_1 $PID_6_2 $PID_7_1 $PID_7_2