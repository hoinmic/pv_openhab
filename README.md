# pv_openhab
Photovoltaic monitoring and smart control of consumers with openhab 4

## Installation with ansible

ansible-playbook --ask-become-pass -i ansible/inventory ansible/site.yml --tags "all,never"

login: smarthome
pw: smarthome

## Test and Debug

The following can be used for logs:
```sh
openhab-cli showlogs
```

Load the sitemaps
```sh
http://192.168.124.21:8080/basicui/app?sitemap=control
http://192.168.124.21:8080/basicui/app?sitemap=powerOverview
http://192.168.124.21:8080/basicui/app?sitemap=energyOverview
http://192.168.124.21:8080/basicui/app?sitemap=inverter
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
