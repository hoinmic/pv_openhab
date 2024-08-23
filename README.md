# pv_openhab
Photovoltaic monitoring and smart control of consumers with openhab 4

## Installation with ansible

### prepare host system
sudo dnf install ansible
sudo dnf install ansible-collection-community-general

### installation on target
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --tags "all,never" --limit staging

login: smarthome
pw: smarthome

## Test and Debug

The following can be used for logs:
```sh
openhab-cli showlogs
```

List installed openhab components:
```sh
openhab-cli console -p habopen bundle:list
```

Sitemaps
```sh
http://192.168.124.21:8080/basicui/app?sitemap=control
http://192.168.124.21:8080/basicui/app?sitemap=powerOverview
http://192.168.124.21:8080/basicui/app?sitemap=energyOverview
http://192.168.124.21:8080/basicui/app?sitemap=inverter
```

Promethious
```sh
http://192.168.124.21:9090/
http://192.168.124.21:8080/rest/metrics/prometheus
```

Grafana
```sh
http://192.168.124.21:3000/
```

Influxdb
```sh
influx -execute "SHOW DATABASES"
influx -execute "SHOW USERS"
```

## Hardware Setup

```mermaid
graph TD
A[Fronius Inverter Roof North Side]
B[Fronius Inverter Roof South Side]
C[Shelly Pro EM3]

F[House Electricity Connection]
G[Shelly Pro EM3]

J[Electricity distribution box]

O[Shelly Pro 3]
P[Electric boiler]

S[MyStrom]
T[Dehumidifier]

U[Heat pump]

M[Connection box]
V[Washing machine]
W[Tumble dryer]


N[Microwave]
X[Electric cooker]
Y[Baking oven]
Z[Dishwasher]
CAR[Car]

A --> C
B --> C
C --> J

F <--> G
G <--> J

J --> O
J --> S

subgraph Smart Devices
    O --> P
    S --> T
end

J --> U
J --> M
J --> Z
J --> CAR
M --> V
M --> W

subgraph Future Smart Devices
    U
    V
    W
    Z
    CAR
end

J --> N
J --> X
J --> Y
subgraph Non-Smart Devices
    N
    X
    Y
end
```

## Additional Informations

### Ansible file copy
ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml

### Restart / Clean Cache
sudo systemctl stop openhab
openhab-cli clean-cache
sudo systemctl start openhab
