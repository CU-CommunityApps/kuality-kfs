Kuality-KFS
===========

Kuality-KFS is the automated functional testing suite for the Kuali Financial System (KFS) at Cornell.


Installation
============

### For developers:

1) Setup the kuality-kfs GitHub project in your IDE as you would any other Ruby project.

2) Create any necessary run configurations (or your IDE's equivalent).
   You will need to include the following things:
..* **Environment Variables:** ANSICON-;JRUBY-OPTS=-X+O
..* **Working directory:** The kuality-kfs project base directory

You may want to set up your run configurations to use the Cucumber profiles included
in the project. They can be found in [./cucumber.yml](./cucumber.yml)
