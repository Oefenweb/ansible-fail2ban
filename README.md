# fail2ban

[![CI](https://github.com/Oefenweb/ansible-fail2ban/workflows/CI/badge.svg)](https://github.com/Oefenweb/ansible-fail2ban/actions?query=workflow%3ACI)
[![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-fail2ban-blue.svg)](https://galaxy.ansible.com/Oefenweb/fail2ban)

Set up fail2ban in Debian-like systems.

## Requirements

None

## Variables

- `fail2ban_loglevel`: [default: `3`, or `INFO` in newer versions]: Sets the loglevel output (e.g. `1 = ERROR`, `2 = WARN`, `3 = INFO`, `4 = DEBUG`)
- `fail2ban_logtarget`: [default: `/var/log/fail2ban.log`]: Sets the log target. This could be a file, SYSLOG, STDERR or STDOUT
- `fail2ban_syslog_target`: [default: `/var/log/fail2ban.log`]:
- `fail2ban_syslog_facility`: [default: `1`]:
- `fail2ban_socket`: [default: `/var/run/fail2ban/fail2ban.sock`]: Sets the socket file, which is used to communicate with the daemon
- `fail2ban_pidfile`: [default: `/var/run/fail2ban/fail2ban.pid`]: Sets the pid file, which is used to to store the process ID of the daemon (Only works on `fail2ban >= 0.8.9`)
- `fail2ban_dbpurgeage`: [default: `86400`]: Sets age at which bans should be purged from the database

- `fail2ban_ignoreips`: [default: `[127.0.0.1/8]`]: Which IP address/CIDR mask/DNS host should be ignored from fail2ban's actions
- `fail2ban_bantime`: [default: `600`]: Sets the bantime
- `fail2ban_maxretry`: [default: `3`]: Maximum number of retries before the host is put into jail
- `fail2ban_findtime`: [default: `600`]: A host is banned if it has generated `fail2ban_maxretry` during the last `fail2ban_findtime`
- `fail2ban_backend`: [default: `auto`]: Specifies the backend used to get files modification. For Debian 12, `systemd` is required
- `fail2ban_banaction`: [default: `iptables-multiport`]: Sets the global/default banaction
- `fail2ban_banaction_allports`: [default: `iptables-allports`]: Sets the global/default banaction for allports
- `fail2ban_mta`: [default: `sendmail`]: Email action
- `fail2ban_protocol`: [default: `tcp`]: Sets the default protocol
- `fail2ban_chain`: [default: `INPUT`]: Specifies the chain where jumps would need to be added in iptables-* actions
- `fail2ban_action`: [default: `%(action_)s`]: Default action.  **Note that variables (including the actions defined elsewhere in the config files) must be wrapped in python-style `%(` and `)s` so they are expanded**
- `fail2ban_sendername`: [default: `Fail2ban`]: The 'from' name for emails sent by mta actions.  NB: Use `fail2ban_sender` to set the 'from' email address.
- `fail2ban_sender`: [optional]: The 'from' address for emails sent by mta actions.
- `fail2ban_filters`: [optional]: List of fail2ban filter templates to be templated out to the server. The template files should end with the Jinja2 suffix `.j2` which is automatically removed when sending to the host.
- `fail2ban_actions`: [optional]: List of fail2ban actions templates to be templated out to the server. The template files should end with the Jinja2 suffix `.j2` which is automatically removed when sending to the host.
- `fail2ban_jails`: [optional]: List of fail2ban jails templates to be templated out to the server. The template files should end with the Jinja2 suffix `.j2` which is automatically removed when sending to the host.

- `fail2ban_services` [default see `defaults/main.yml`]: Service definitions
- `fail2ban_services.{n}.name` [required]: Service name (e.g. `ssh`)
- `fail2ban_services.{n}.enabled` [default: `true`]: Whether or not enabled
- `fail2ban_services.{n}.*` [optional]: Name of the option
- `fail2ban_services.{n}.*.*` [optional]: Value of the option

### For version >= 0.11.1

- `fail2ban_bantime_increment`: [default: `true`]: Increases bantime after being banned before
- `fail2ban_bantime_factor`: [default: `1`]: Bantime increase factor for `bantime_formula` or `bantime_multipliers`
- `fail2ban_bantime_formula`: [default: `'ban.Time * (1<<(ban.Count if ban.Count<20 else 20)) * banFactor'`]: Formula that will be used to calculate the increased bantime. **Note that you can either use `bantime_formula` or `bantime_multipliers` while `bantime_multipliers` takes precedence.**
- `fail2ban_bantime_overalljails`: [default: `false`]: Ban IPs for all jails if multiple are defined
- `fail2ban_bantime_rndtime`: [optional]: Option for smart bots that try to access after the bantime immediately
- `fail2ban_bantime_multipliers`: [optional]: Multiplier to use instead of bantime_formula. For example `1 2 4 8 16 32 64`. **Note for bantime = 600 and bantime_factor=1 this would be `600*1*1, 600*1*2...`**

## Dependencies

None

## Example(s)

### Simple

```yaml
---
- hosts: all
  roles:
    - oefenweb.fail2ban
```

### Enable sshd filter (with non-default settings)

```yaml
---
- hosts: all
  roles:
    - oefenweb.fail2ban
  vars:
    fail2ban_services:
      # In older versions of Fail2Ban this is called ssh
      - name: sshd
        port: 2222
        maxretry: 5
        bantime: -1
```

### Add custom filters (from outside the role)

```yaml
---
- hosts: all
  roles:
    - oefenweb.fail2ban
  vars:
    fail2ban_jails:
      - templates/fail2ban-jails/nginx-http-auth.local.j2
      - templates/fail2ban-jails/nginx-noproxy.local.j2

    fail2ban_filters:
      - templates/fail2ban-filters/nginx-noproxy.conf.j2

    fail2ban_services:
      - name: apache-wordpress-logins
        port: http,https
        filter: apache-wordpress-logins
        logpath: /var/log/apache2/access.log
        maxretry: 5
        findtime: 120
```

## License

MIT

## Author Information

Mischa ter Smitten (based on work of [ANXS](https://github.com/ANXS))

## Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Oefenweb/ansible-fail2ban/issues)!
