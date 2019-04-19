# ReCAP SCSB DevOps Tools

## Prepare your environment for local development
Clone each of the SCSB repositories, along with this one, to a single parent directory, so your directory looks like this:
```bash
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-circ.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-ui.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-etl.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-solr-client.git
git clone git@github.com:ResearchCollectionsAndPreservation/cucumber-automation.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-shiro.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-cas.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-batch-scheduler.git
git clone git@github.com:ResearchCollectionsAndPreservation/performance-test.git
git clone git@github.com:ResearchCollectionsAndPreservation/scsb-solr.git
git clone https://github.com/sartography/recap-scsb-devops.git
```	      

Then add another directory called `data`, where all the database and configuration files will go:
```bash
mkdir data
```

Navigate to the `data` directory and create a `config` directory:
```bash
cd data
mkdir config
```

Navigate to the `config` directory and copy the following files to it:
```bash
cd config
cp ../../scsb/src/main/resources/application.properties .
cp ../../docker/scsb-log4j/* .
```

Then navigate up to the `data` directory and create a symbolic link from `/recap-vol` to the data directory:
```bash
cd ..
pwd
[PROJ_DIR]/data
sudo ln -s [PROJ_DIR]/data /recap-vol
```

## Start the docker containers
Navigate up to the project directory, then to the directory for this repository. Then run the `start.sh` script to start up all the docker containers needed for SCSB.
```bash
cd ..
pwd
[PROJ_DIR]
cd recap-scsb-devops
sudo ./start.sh
```

If all the containers are running properly, you should be able to run the following command and see all the containers running with no errors or "Exited" statuses:
```bash
docker container ls --all
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                      NAMES
900d5ba8c2b3        scsb-ui             "/bin/sh -c 'java -j…"   4 seconds ago       Up 1 second         0.0.0.0:9091->9091/tcp                                                     scsb-ui
be6ef8daf4dd        scsb-shiro          "/bin/sh -c 'java -j…"   14 seconds ago      Up 12 seconds       0.0.0.0:9092->9092/tcp                                                     scsb-shiro
aadcf6d67e23        scsb-scsb           "/bin/sh -c 'java -j…"   23 seconds ago      Up 20 seconds       0.0.0.0:9093->9093/tcp                                                     scsb
b93f286475bf        scsb-solr-client    "/bin/sh -c 'java -j…"   29 seconds ago      Up 27 seconds       0.0.0.0:9090->9090/tcp                                                     scsb-solr-client
720f38b60bc4        scsb-solr-server    "/opt/startup.sh -e …"   35 seconds ago      Up 33 seconds       0.0.0.0:8983->8983/tcp                                                     scsb-solr-server
e890b575e08f        scsb-activemq       "/opt/startup.sh"        42 seconds ago      Up 39 seconds       0.0.0.0:1099->1099/tcp, 0.0.0.0:8161->8161/tcp, 0.0.0.0:61616->61616/tcp   scsb-activemq
75f41ba3d8fb        scsb-mysql          "/opt/startup.sh"        48 seconds ago      Up 46 seconds       0.0.0.0:3306->3306/tcp                                                     scsb-mysql
```

If a container has an exited status after a few seconds, it's likely that your configuration is incorrect.
(TODO: Need guidance from HTC on troubleshooting this.)

## Set up your IDE
### IntelliJ
[Follow these instructions](https://www.jetbrains.com/help/idea/gradle.html#gradle_import) to import the `scsb` repo project from its `gradle.build` file.

## Running unit tests
### Configuring IntelliJ to run tests
Click the `Run` menu and then `Edit Configurations...`. You should have a Gradle build listed, with `BaseTestCase` and `BaseControllerUT` listed beneath. If not, click the `+` button to add a new Gradle configuration.

### Running unit tests
Click the `Run` menu and then `Run 'BaseTestCase'`. If everything is configured correctly, the test should all run successfully.

(TODO: Need guidance from HTC on whether this is the correct configuration.)
