# systemd-oomd Setup

Based on [Fedora defaults](https://src.fedoraproject.org/rpms/systemd/blob/main/f/10-oomd-defaults.conf) with adjusted thresholds.

Enable: `systemctl enable --now systemd-oomd`

## Drop-in configs

`/etc/systemd/oomd.conf.d/10-oomd-defaults.conf`:

```ini
[OOM]
DefaultMemoryPressureDurationSec=20s
```

`/etc/systemd/system/system.slice.d/10-oomd-pressure.conf`:

```ini
[Slice]
ManagedOOMMemoryPressure=kill
ManagedOOMMemoryPressureLimit=70%
```

`/etc/systemd/user/slice.d/10-oomd-pressure.conf`:

```ini
[Slice]
ManagedOOMMemoryPressure=kill
ManagedOOMMemoryPressureLimit=60%
```

Verify with `oomctl`.
