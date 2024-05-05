# pv_openhab
Photovoltaic monitoring and smart control of consumers with openhab 4

## Add-ons

- Astro Binding
- Shelly Binding
- mystorm Binding
- Fronius Binding

## Installations on x86

Install java
```sh
sudo apt install zulu17-jdk
```

Install openhab
```sh
curl -fsSL "https://openhab.jfrog.io/artifactory/api/gpg/key/public" | gpg --dearmor > openhab.gpg
sudo mv openhab.gpg /usr/share/keyrings
sudo chmod u=rw,g=r,o=r /usr/share/keyrings/openhab.gpg
echo 'deb [signed-by=/usr/share/keyrings/openhab.gpg] https://openhab.jfrog.io/artifactory/openhab-linuxpkg stable main' | sudo tee /etc/apt/sources.list.d/openhab.list

sudo apt-get update
sudo apt-get install openhab
sudo apt-get install openhab-addons

sudo systemctl start openhab.service
sudo systemctl enable openhab.service
```

Set password and login for openhab linux user (to copy files)
```sh
sudo passwd openhab
sudo vi /etc/passwd
line: openhab .... /bin/false -> /bin/bash
```

## Set timezone of the system

```sh
sudo timedatectl set-timezone Europe/Zurich
```

## Test and Debug

In top foleder is a script to automatic copy the openhab files to remote (file: autocopy)

The following can be used for logs:
```sh
openhab-cli showlogs
```

Load the sitemaps
```sh
http://192.168.124.254:8080/basicui/app?sitemap=consumers
http://192.168.124.254:8080/basicui/app?sitemap=fronius
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

subgraph Future Smart Devices
    U
    M --> V
    M --> W
    Z
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

- In top foleder is a script to automatic copy the openhab files to remote (file: autocopy)

