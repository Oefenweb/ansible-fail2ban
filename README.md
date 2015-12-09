## fail2ban

[![Build Status](https://travis-ci.org/Oefenweb/ansible-fail2ban.svg?branch=master)](https://travis-ci.org/Oefenweb/ansible-fail2ban) [![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-fail2ban-blue.svg)](https://galaxy.ansible.com/list#/roles/1435)

Set up fail2ban in Debian-like systems.

#### Requirements

None

#### Variables
- `fail2ban_apt_cache_valid_time`: [default: `3600`]: Time (in seconds) to pass to Ansible for updating the apt-cache before installing fail2ban

- `fail2ban_loglevel`: [default: `3`]: Sets the loglevel output (1 = ERROR, 2 = WARN, 3 = INFO, 4 = DEBUG)
- `fail2ban_logtarget`: [default: `/var/log/fail2ban.log`]: Sets the log target. This could be a file, SYSLOG, STDERR or STDOUT
- `fail2ban_syslog_target`: [default: `/var/log/fail2ban.log`]:
- `fail2ban_syslog_facility`: [default: `1`]:
- `fail2ban_socket`: [default: `/var/run/fail2ban/fail2ban.sock`]: Sets the socket file, which is used to communicate with the daemon
- `fail2ban_pidfile`: [default: `/var/run/fail2ban/fail2ban.pid`]: Sets the pid file, which is used to to store the process ID of the daemon (Only works on `fail2ban >= 0.8.9`)

- `fail2ban_ignoreips`: [default: `[127.0.0.1/8]`]: Which IP address/CIDR mask/DNS host should be ignored from fail2ban's actions
- `fail2ban_bantime`: [default: `600`]: Sets the bantime
- `fail2ban_maxretry`: [default: `3`]: Maximum number of retries before the host is put into jail
- `fail2ban_findtime`: [default: `600`]: A host is banned if it has generated `fail2ban_maxretry` during the last `fail2ban_findtime` (this can be overriden for each service)
- `fail2ban_backend`: [default: `auto`]: Specifies the backend used to get files modification
- `fail2ban_email`: [default: `root@localhost`]: Email address which can be used in the interpolation of the `fail2ban_services`
- `fail2ban_banaction`: [default: `iptables-multiport`]: Sets the global/default banaction (can be overriden on a per role basis)
- `fail2ban_mta`: [default: `sendmail`]: Email action
- `fail2ban_protocol`: [default: `tcp`]: Sets the default protocol
- `fail2ban_chain`: [default: `INPUT`]: Specifies the chain where jumps would need to be added in iptables-* actions
- `fail2ban_action`: [default: `action_`]: Default action

- `fail2ban_filterd_path`: [optional]: Path to directory containing filters to copy (**note the trailing slash**)

For each of the services you wish to protect/put a jail or ban up for, you need to add it to the `fail2ban_services` list of hashes:

```yaml
fail2ban_services:
  - name: ssh
    enabled: true
    port: ssh
    filter: sshd
    logpath: /var/log/auth.log
    maxretry: 6
    protocol: tcp                 (optional)
    action: action_               (optional)
    banaction: iptables-multiport (optional)
    findtime: 600                 (optional)
```

## Dependencies

None

#### Example(s)

##### Simple configuration

```yaml
---
- hosts: all
  roles:
    - fail2ban
```

##### Add custom filters (from outside the role)

```yaml
---
- hosts: all
  roles:
    - fail2ban
  vars:
    fail2ban_filterd_path: ../../../files/fail2ban/etc/fail2ban/filter.d/
    fail2ban_services:
      - name: apache-wordpress-logins
        enabled: true
        port: http,https
        filter: apache-wordpress-logins
        logpath: /var/log/apache2/access.log
        maxretry: 5
        findtime: 120
```

#### License

MIT

#### Author Information

Mischa ter Smitten (based on work of [ANXS](https://github.com/ANXS))
[Dan Tehranian](https://github.com/tehranian)

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Oefenweb/ansible-fail2ban/issues)!
