# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cryosparc::config
#
class cryosparc::config {
  # $hpc_group = lookup("${cryosparc::instance}[${::fqdn}]['hpc_group']")
  # $hpc_gid = lookup("${cryosparc::instance}.${::fqdn}.hpc_gid")
  group { $cryosparc::hpc_group:
    ensure => 'present',
    gid    => $cryosparc::hpc_gid,
  }

  user { $cryosparc::hpc_user:
    ensure     => 'present',
    uid        => $cryosparc::hpc_uid,
    groups     => $cryosparc::hpc_group,
    managehome => true,
    password   => $cryosparc::password,
  }

  file { "/home/${cryosparc::hpc_user}/.ssh":
    ensure => 'directory',
    owner  => $cryosparc::hpc_user,
    group  => $cryosparc::hpc_user,
    mode   => '0770',
  }

  file { '/cryosparc_database':
    ensure => 'directory',
    owner  => $cryosparc::hpc_user,
    group  => $cryosparc::hpc_group,
    mode   => '0770',
  }

  file { $cryosparc::hpc_directory:
    ensure => 'directory',
    owner  => $cryosparc::hpc_user,
    group  => $cryosparc::hpc_group,
    mode   => '0770',
  }

  firewall { '010 IPv4 allow in/out TCP':
    dport  => [22, 39000, 39001, 39002, 39003, 39004, 39005, 39006, 39007],
    proto  => 'tcp',
    action => 'accept',
  }
}
