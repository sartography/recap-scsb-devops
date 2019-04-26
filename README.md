# ReCAP SCSB DevOps Tools

## Prepare your environment for local development
Clone each of the SCSB repositories, along with this one, to a single parent directory, so your directory looks like this:
```bash
git clone git@github.com:sartography/recap-scsb-circ.git
git clone git@github.com:sartography/recap-scsb-ui.git
git clone git@github.com:sartography/recap-scsb.git
git clone git@github.com:sartography/recap-scsb-etl.git
git clone git@github.com:sartography/recap-scsb-solr-client.git
git clone git@github.com:sartography/recap-cucumber-automation.git
git clone git@github.com:sartography/recap-scsb-shiro.git
git clone git@github.com:sartography/recap-scsb-cas.git
git clone git@github.com:sartography/recap-scsb-batch-scheduler.git
git clone git@github.com:sartography/recap-performance-test.git
git clone git@github.com:sartography/recap-scsb-solr.git
git clone git@github.com:sartography/recap-docker.git
```	      

## We Use Docker-Compose

* Install docker following this guide:  https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
* Install docker-compose following this guide: https://docs.docker.com/compose/install/
* on linux after installed docker-compose, I had to "chmod 666 /var/run/docker.sock" 

Then create symbolic links from `/recap-vol` and `/data` to the data directory:
```bash
sudo ln -s [PROJ_DIR]/recap-scsb-devops/data /recap-vol
sudo ln -s [PROJ_DIR]/recap-scsb-devops/data /data
```

# Build the containers via `docker-compose`
```bash
docker-compose build
```

# Start up the docker containers
```bash
docker-compose up
```

# Is it all up?
You can verify that the sftp server is responding with:
```bash
sftp -P 2222 recap@localhost
``` 

## Start the docker containers
Navigate up to the project directory, then to the directory for this repository. Then run the `start.sh` script to start up all the docker containers needed for SCSB.
```bash
cd [PROJ_DIR]/recap-scsb-devops
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

## Set up your IDE
### IntelliJ

#### Spring Boot
Make sure you have the Spring Boot plugin installed and enabled. Navigate to `Preferences... > Plugins > Installed` to verify that Spring Boot support is listed and checked.

[Follow these instructions](https://www.jetbrains.com/help/idea/gradle.html#gradle_import) to import the `scsb` repo project from its `gradle.build` file.

## Running unit tests
### Configuring IntelliJ to run tests
Click the `Run` menu and then `Edit Configurations...`. You should have a Gradle build listed, with `BaseTestCase` and `BaseControllerUT` listed beneath. If not, click the `+` button to add a new Gradle configuration.

### Running unit tests
Click the `Run` menu and then `Run 'BaseTestCase'`. If everything is configured correctly, the test should all run successfully.
