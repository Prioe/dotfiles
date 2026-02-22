# Fingerprint Authentication for Polkit

Uses [pam-fprint-grosshack](https://aur.archlinux.org/packages/pam-fprint-grosshack) to enable simultaneous fingerprint and password prompts in GNOME polkit dialogs. See [CVE-2024-37408](https://wiki.archlinux.org/title/Fprint#Login) for why plain `pam_fprintd.so` as `sufficient` is discouraged for polkit/sudo.

- [fprint - ArchWiki](https://wiki.archlinux.org/title/Fprint)
- [polkit - ArchWiki](https://wiki.archlinux.org/title/Polkit)
- [PAM - ArchWiki](https://wiki.archlinux.org/title/PAM)
- [GDM - ArchWiki](https://wiki.archlinux.org/title/GDM)

## Prerequisites

- `fprintd` installed and fingerprint enrolled (`fprintd-enroll`)
- GDM fingerprint login already working

## Install

```bash
paru -S pam-fprint-grosshack
```

## PAM config

`/etc/pam.d/polkit-1`:

```
#%PAM-1.0

auth       sufficient   pam_fprintd_grosshack.so
auth       sufficient   pam_unix.so try_first_pass nullok
account    include      system-auth
password   include      system-auth
session    include      system-auth
```

This overrides the vendor config at `/usr/lib/pam.d/polkit-1`. Touch the fingerprint reader or type your password, whichever comes first.
