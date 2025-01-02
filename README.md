# Smarthome control and visualisation

Photovoltaic monitoring and smart control of consumers.

Key features:
- Control with Openhab
- Visualisation with Grafana
- Automated setup and maintenance of devices with ansible
- Remote control of v-zug devices

## Screenshots

### Overview
![image info](./Screenshot_overview.png)

### Long term overview
![image info](./Screenshot_longterm.png)

### Consumer monitoring
![image info](./Screenshot_consumer.png)

### Daily report
![image info](./Screenshot_day_overview.png)

## Installation with Ansible

### Prepare host system
sudo dnf install ansible
sudo dnf install ansible-collection-community-general

### Installation on target system

1) Installation of an OS on the target system. An ssh access must be given. Tested with Ubuntu server 22.04 and Ubuntu server 24.04.

2) Installation of all components with ansible. (Modify user and password in inventory file (ansible/inventory).

```sh
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --tags "all,never" --limit staging
or
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --tags "all,never" --limit productive

```

### Login Grafana
login: admin  
pw: admin  
```sh
http://<ip>:3000/
```

### Login Openhab
login: smarthome  
pw: smarthome  
```sh
http://<ip>:8080/
```

## Test and Debug

Openhab debug / list components:
```sh
openhab-cli showlogs
openhab-cli console -p habopen bundle:list
```

Openhab sitemaps
```sh
http://<ip>:8080/basicui/app?sitemap=control
http://<ip>:8080/basicui/app?sitemap=powerOverview
http://<ip>:8080/basicui/app?sitemap=energyOverview
http://<ip>:8080/basicui/app?sitemap=inverter
```

Promethious
```sh
http://<ip>:9090/
```

Promethious node exporter
```sh
http://<ip>:9100/metrics
http://<ip>:8080/rest/metrics/prometheus
```

Influxdb informations
```sh
influx -execute "SHOW DATABASES"
influx -execute "SHOW USERS"
```

## Hardware Setup

```mermaid
graph TD
Inverter1[Fronius Inverter 1]
Inverter2[Fronius Inverter 2]
SHELLYEM3PRO1[Shelly Pro EM3]

GRID[House Electricity Connection]
SHELLYEM3PRO2[Shelly Pro EM3]

DISTRIBUTION[Electricity distribution box]

SHELLY3PRO[Shelly Pro 3]
BOILER[Electric boiler]

MYSTROM[MyStrom]
DEHUMIDIFIER[Dehumidifier]

HEATPUMP[Heat pump]

WASHINGMACHINE[Washing machine]
TUMBLEDRYER[Tumble dryer]


MICROWAVE[Microwave]
COOKER[Electric cooker]
BAKING[Baking oven]
DISHWASHER[Dishwasher]
CAR[Car]

Inverter1 --> SHELLYEM3PRO1
Inverter2 --> SHELLYEM3PRO1
SHELLYEM3PRO1 --> DISTRIBUTION

GRID <--> SHELLYEM3PRO2
SHELLYEM3PRO2 <--> DISTRIBUTION

DISTRIBUTION --> SHELLY3PRO
DISTRIBUTION --> MYSTROM
DISTRIBUTION --> WASHINGMACHINE
DISTRIBUTION --> DISHWASHER

subgraph Smart Devices
    SHELLY3PRO --> BOILER
    MYSTROM --> DEHUMIDIFIER
    WASHINGMACHINE
    DISHWASHER
end

DISTRIBUTION --> HEATPUMP
DISTRIBUTION --> TUMBLEDRYER
DISTRIBUTION --> CAR

subgraph Future Smart Devices
    HEATPUMP
    TUMBLEDRYER
    DISHWASHER
    CAR
end

DISTRIBUTION --> MICROWAVE
DISTRIBUTION --> COOKER
DISTRIBUTION --> BAKING
subgraph Non-Smart Devices
    MICROWAVE
    COOKER
    BAKING
end
```

## Data flow

```mermaid
graph LR
Sensors[Sensors]
Openhab[Openhab]
InfluxDB[InfluxDB]
Prometheus[Prometheus]
OS[Operating System]
Grafana[Grafana]
LaMetric[LaMetric]

Sensors --> Openhab
Openhab --> LaMetric
Openhab --> InfluxDB
Openhab --> Prometheus
OS --> Prometheus
Prometheus --> Grafana
InfluxDB --> Grafana
```

## Additional Informations

### Ansible file copy
This command copies the user data from openhab and grafana. The entire installation of software components does not take place.
```sh
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --limit staging
or
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --limit productive
```


### Influx notes

#### Create backup
```sh
influxd backup -portable /home/smarthome/backup_$(date '+%Y-%m-%d_%H-%M')
```
#### Copy backup
```sh
scp -r smarthome@<ip>:/home/smarthome/backup_2025-01-02_14-19 .
```

#### Restore backup
```sh
systemctl stop openhab
/usr/bin/influx -execute 'DROP DATABASE openhab'
influxd restore -portable backup_2024-10-08_21-47/
influx -execute 'SHOW RETENTION POLICIES ON openhab'
systemctl start openhab
```

#### Change Retention Policy
```sh
/usr/bin/influx -execute 'ALTER RETENTION POLICY "autogen" ON "openhab" DURATION 365d'
or
/usr/bin/influx -execute 'ALTER RETENTION POLICY "autogen" ON "openhab" DURATION INF'
```

### LaMetric Display

LaMetric Smart Time is used for the visualisation of power measurements. The ‘my Data DIY’ app
from LaMetric accesses the REST API from openhab for this purpose. The addresses to be used
are as follows:

```sh
http://<ip>:8080/rest/items/LaMetric_Inverter
http://<ip>:8080/rest/items/LaMetric_Grid
http://<ip>:8080/rest/items/LaMetric_Consumption
```
