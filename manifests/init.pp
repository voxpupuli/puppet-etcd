# @summary Manage etcd
#
# @example
#   include etcd
#
# @param version
#   Version of etcd to install
#   Not used if download_url is defined.
# @param base_url
#   Base URL of where to download etcd binaries.
#   Not used if download_url is defined.
# @param os
#   The GOOS to install
#   Not used if download_url is defined.
# @param arch
#   The GOARCH to install
#   Not used if download_url is defined.
# @param download_url
#   Alternative location to download etcd binaries
# @param download_dir
#   The directory of where to download etcd
# @param extract_dir
#   The directory where to extract etcd
# @param bin_dir
#   The path to bin directory for etcd and etcdctl symlinks
# @param manage_user
#   Boolean that determines if etcd user is managed
# @param manage_group
#   Boolean that determines if etcd group is managed
# @param user
#   The etcd user
# @param user_uid
#   The etcd user UID
# @param group
#   The etcd group
# @param group_gid
#   The etcd group GID
# @param config_path
#   The path to etcd YAML configuration
# @param config
#   The config values to pass to etcd
# @param max_open_files
#   The value for systemd LimitNOFILE unit option
class etcd (
  String $version = '3.4.7',
  Stdlib::HTTPUrl $base_url = 'https://github.com/etcd-io/etcd/releases/download',
  String[1] $os = downcase($facts['kernel']),
  String[1] $arch = $facts['os']['architecture'],
  Optional[Stdlib::HTTPUrl] $download_url = undef,
  Stdlib::Absolutepath $download_dir = '/tmp',
  Stdlib::Absolutepath $extract_dir = '/opt',
  Stdlib::Absolutepath $bin_dir = '/usr/bin',
  Boolean $manage_user = true,
  Boolean $manage_group = true,
  String[1] $user = 'etcd',
  Optional[Integer] $user_uid = undef,
  String[1] $group = 'etcd',
  Optional[Integer] $group_gid = undef,
  Stdlib::Absolutepath $config_path = '/etc/etcd.yaml',
  Hash $config = {},
  Integer $max_open_files = 40000,
) {

  if $os != 'linux' {
    fail("Module etcd only supports Linux, not ${os}")
  }
  if $facts['service_provider'] != 'systemd' {
    fail('Module etcd only supported on systems using systemd')
  }
  if ! $config['data-dir'] {
    fail('Module etcd requires data-dir be specified in config Hash')
  }

  case $arch {
    'x86_64', 'amd64': { $real_arch = 'amd64' }
    'aarch64':         { $real_arch = 'arm64' }
    default:           { $real_arch = $arch }
  }

  $_download_url = pick($download_url, "${base_url}/v${version}/etcd-v${version}-${os}-${real_arch}.tar.gz")
  $install_dir = "${extract_dir}/etcd-${version}"

  file { $install_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  archive { "${download_dir}/etcd.tar.gz":
    source          => $_download_url,
    extract         => true,
    extract_path    => $install_dir,
    extract_command => 'tar xfz %s --strip-components=1',
    creates         => "${install_dir}/etcd",
    cleanup         => true,
    user            => 'root',
    group           => 'root',
    require         => File[$install_dir],
    before          => [
      File["${bin_dir}/etcd"],
      File["${bin_dir}/etcdctl"],
    ]
  }

  file { 'etcd':
    ensure => 'link',
    path   => "${bin_dir}/etcd",
    target => "${install_dir}/etcd",
    notify => Service['etcd'],
  }
  file { 'etcdctl':
    ensure => 'link',
    path   => "${bin_dir}/etcdctl",
    target => "${install_dir}/etcdctl",
  }

  if $manage_user {
    user { 'etcd':
      ensure     => 'present',
      name       => $user,
      forcelocal => true,
      shell      => '/bin/false',
      gid        => $group,
      uid        => $user_uid,
      home       => $config['data-dir'],
      managehome => false,
      system     => true,
      before     => Service['etcd'],
    }
  }
  if $manage_group {
    group { 'etcd':
      ensure     => 'present',
      name       => $group,
      forcelocal => true,
      gid        => $group_gid,
      system     => true,
      before     => Service['etcd'],
    }
  }

  file { 'etcd.yaml':
    ensure  => 'file',
    path    => $config_path,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    content => to_yaml($config),
    notify  => Service['etcd'],
  }

  file { 'etcd-data-dir':
    ensure => 'directory',
    path   => $config['data-dir'],
    owner  => $user,
    group  => $group,
    mode   => '0700',
    before => Service['etcd'],
  }

  if $config['wal-dir'] {
    file { 'etcd-wal-dir':
      ensure => 'directory',
      path   => $config['wal-dir'],
      owner  => $user,
      group  => $group,
      mode   => '0700',
      before => Service['etcd'],
    }
  }

  systemd::unit_file { 'etcd.service':
    content => template('etcd/etcd.service.erb'),
    notify  => Service['etcd'],
  }

  if versioncmp($facts['puppetversion'],'6.1.0') < 0 {
    # Puppet 5 doesn't have https://tickets.puppetlabs.com/browse/PUP-3483
    # and camptocamp/systemd only creates this relationship when managing the service
    Class['systemd::systemctl::daemon_reload'] -> Service['etcd']
  }

  service { 'etcd':
    ensure => 'running',
    enable => true,
  }
}
