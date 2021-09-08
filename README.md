
This project contains the ox models and the berlioz config for https://ox-staging.pbs.gov.au/ and https://ox.pbs.gov.au/

## How to test locally

- Setup [berliozweb-ox](https://gitlab.allette.com.au/pageseeder/berliozweb-ox) in your intellij
- In the berliozweb-ox create a copy of gradle/local.properties.sample and save as local.properties
- Update the local.properties with the following information.
- Change the berliozAppdataFolder to {this project instalation path}/berliozweb-mps4-ox-models/local/appdata
- Change the berliozMode to mps4