# ans_utils/ndred
Ansible utilities for Node-RED

##Prerequisites
The target node needs to be described by group variable with the following structure
```
node_opts:
  <ansible_hostname-of-the-node>:
    ndred:
      node_major:      <numeric-major-ver-of-node.js>
      instances:
      - { name: "<instance-name>", state: "started", allow_remote: false, descr: "<some-instance-description>",	admgrps: }
      ...
      - { name: "<another-name>", state: "stopped", allow_remote: false, descr: "stopped instance", admgrps: }
```

##ndred_allinst_bkp.yml
This playbook will create backup file for each Node-RED instance on selected target (as defined by the list  {{node_opts[ansible_hostname].ndred.instances}}).
Any backup file (tar.gz archive) will get deposited to local path
- "{{inst_data_base}}/{{ansible_hostname}}/ndred_bkp/<backup-timestamp>/<Node-RED-instance-name>.tgz"

