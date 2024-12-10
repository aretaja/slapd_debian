# Build image
```
docker build --network=host -t slapd_debian .
```

# Make config/log environment
```
mkdir -m 0700 -p /opt/my_containers/slapd \
  && mkdir -p /opt/my_containers/slapd/etc \
  && mkdir -p /opt/my_containers/slapd/certs \
  && mkdir -p /opt/my_containers/slapd/db \
  && mkdir -p /opt/my_containers/slapd/import \
  && mkdir -p /opt/my_containers/slapd/export \
  && chown -R root:root /opt/my_containers/slapd \
  && cp contrib/docker-compose.yml.example /opt/my_containers/slapd/docker-compose.yml
```

# Import
Copy config and data backup files: `ldap_data.ldif` and `ldap_config.ldif` to `/opt/my_containers/slapd/import` directory.
Set `CONFIMPORT` variable to `1` in composefile.

# Backup
Stores slapd config and data backups to `/opt/my_containers/slapd/export` directory
```
docker exec slapd bin/backup.sh
```

# Log verbosity
Set `CONFIMPORT` variable to one of below values in composefile.
```
Any       (-1, 0xffffffff)
Trace     (1, 0x1)
Packets   (2, 0x2)
Args      (4, 0x4)
Conns     (8, 0x8)
BER       (16, 0x10)
Filter    (32, 0x20)
Config    (64, 0x40)
ACL       (128, 0x80)
Stats     (256, 0x100)
Stats2    (512, 0x200)
Shell     (1024, 0x400)
Parse     (2048, 0x800)
Sync      (16384, 0x4000)
None      (32768, 0x8000)
```

# Test
```
radtest <user> <pass> 127.0.0.1 0 <secret>
```
