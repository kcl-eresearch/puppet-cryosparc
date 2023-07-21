# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cryosparc::install
class cryosparc::install {
  $packages = [
    'nfs-common',
  ]

  ensure_packages($packages)

  mount { $cryosparc::hpc_dir:
    ensure  => 'mounted',
    device  => "erc-nfs1.create.kcl.ac.uk:/hpc${cryosparc::hpc_dir}",
    fstype  => 'nfs',
    options => 'sec=sys,vers=4',
    require => [Package['nfs-common']],
  }

  archive { "/home/${cryosparc::hpc_user}/cryosparc_master":
    ensure           => present,
    extract          => true,
    source           => "https://get.cryosparc.com/download/master-latest/${cryosparc::cs_license}",
    extract_path     => "/home/${cryosparc::hpc_user}",
    creates          => "/home/${cryosparc::hpc_user}/cryosparc_master",
    download_options => ['-L', '-o cryosparc_master.tar.gz'],
    notify           => Exec('cryosparc_install'),
  }

  exec { 'cryosparc_install':
    command => "./install.sh --license ${cryosparc::cs_license} --hostname ${::fqdn} --dbpath /cryosparc_database --port 39000 --yes",
    path    => ['/usr/bin', '/bin/bash', "/home/${cryosparc::hpc_user}/cryosparc_master/"],
    cwd     => "/home/${cryosparc::hpc_user}/cryosparc_master",
    user    => $cryosparc::hpc_user,
    creates => "/home/${cryosparc::hpc_user}/cryosparc_master/bin",
  }

  # considered using systemd but followed install guidelines on
  # https://guide.cryosparc.com/setup-configuration-and-management/how-to-download-install-and-configure
  exec { 'cryosparc_start':
    command     => "/home/${cryosparc::hpc_user}/cryosparc_master/bin/cryosparcm start",
    user        => $cryosparc::hpc_user,
    refreshonly => true,
    require     => Exec['cryosparc_install'],
  }

  exec { 'cryosparc_admin':
    command     => "/home/${cryosparc::hpc_user}/cryosparc_master/bin/cryosparcm createuser --email ${cryosparc::admin_email} \
  --password ${cryosparc::admin_password} --username ${cryosparc::admin_username} \
  --firstname ${cryosparc::admin_fname} --lastname ${cryosparc::admin_lname}",
    user        => $cryosparc::hpc_user,
    refreshonly => true,
    require     => Exec['cryosparc_start'],
  }
}
