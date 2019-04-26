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

# We Use Docker-Compose
* Install docker following this guide:  https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
* Install docker-compose following this guide: https://docs.docker.com/compose/install/
* on linux after installed docker-compose, I had to "chmod 666 /var/run/docker.sock" 


# Create some (less than ideal) directories in Root. :-(
FIXME:  In order for some of the configration files we inherited from HTC to work correctly, we found we have to create symbolic links from `/recap-vol` and `/data` to the data directory:
```bash
cd ..
pwd
[PROJ_DIR]/data
sudo ln -s [PROJ_DIR]/data /recap-vol
sudo ln -s [PROJ_DIR]/data data
```
(we plan to fix this at some point)

# Build the containers via `docker-compose`
```bash
docker-compose build
```

# Start up the docker containers
```bash
docker-compose up
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


# DEVELOPMENT

## Docker for Development
Many of the micro-service code bases in SCSB have required dependencies that must be  running in order for the micro-service to event start up.   So if you want the app running in your IDE while you do development, code changes, debugging,etc... then, at a minimum, you will want to use Docker-compose to start:

  * scsb-sftp
  * scsb-mysql
  * scsb-activemq
  * scsb-solr-server

(We should likely have a separate docker-compose for this setup)

## Set up your IDE

### IntelliJ
If you don't Java, you can get 30 day trail of the commercial addition, which will save you a ton of time getting things up.

Make sure you have the Spring Boot plugin installed and enabled. Navigate to `Preferences... > Plugins > Installed` to verify that Spring Boot support is listed and checked.

[Follow these instructions](https://www.jetbrains.com/help/idea/gradle.html#gradle_import) to import the `scsb` repo project from its `gradle.build` file.

## Development Configuration
You will need to use a custom configuration file (application.properties) )to talk to the docker containers we've set up.  Each project will need a different configuration file, and you can specify that in the Run/Debug configuration.

### Solr-Client
Everything seems to need to SCSB Solr-Client.  After importing this project into IntelliJ, you should have a "Run Configuration" called "Main".  In the menu go to "Run" -> "Edit Configurations", select "Main", and place the following (with corrected paths) into the Environment section in the "VM Options" text field.

IMPORTANT:  Edit the location to spring.config.location to point to this repository

```
-Dspring.profiles.active=local-container -Dspring.config.location=[THIS-REPO-CHECKOUT]/data/config/solr_client.application.properties -Djsse.enableSNIExtension=false -Dorg.apache.activemq.SERIALIZABLE_PACKAGES=''"
```

## Permission Problems
I've run into permission problems with things getting set to root ownership on the volume shares.  If something doesn't fire up correctly you might need to chown the whole data directory. 


## Running unit tests
### Configuring IntelliJ to run tests
Click the `Run` menu and then `Edit Configurations...`. You should have a Gradle build listed, with `BaseTestCase` and `BaseControllerUT` listed beneath. If not, click the `+` button to add a new Gradle configuration.

### Running unit tests
Click the `Run` menu and then `Run 'BaseTestCase'`. If everything is configured correctly, the test should all run successfully.
