# == Class: ms_openstack_ci_metrics
#
# Full description of class ms_openstack_ci_metrics here.
#
# === Parameters
#
# [*db_name*]
#   name of the database
# [*db_user*]
#  database user to connect with
# [*db_password*]
#  password of the database user
# [*db_host*]
#  Host where the database resides
# === Examples
#
#  class { 'ms_openstack_ci_metrics':
#    db_name     => 'cimetrics_db',
#    db_user     => 'cimetrics',
#    db_password => 'cimetrics',
#    db_host     => 'localhost',
#  }
#
# === Authors
#
# Peter J. Pouliot <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2015 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.

class ms_openstack_ci_metrics (
  $db_name     = $ms_openstack_ci_metrics::params::db_name,
  $db_user     = $ms_openstack_ci_metrics::params::db_user,
  $db_password = $ms_openstack_ci_metrics::params::db_password,
  $db_host     = $ms_openstack_ci_metrics::params::db_host,

) inherits ms_openstack_ci_metrics::params {

  package{['git','python2.7']:
    ensure => 'latest',
  } ->
  package{'python-pip':
    ensure => 'latest',
  } ->
  package{'ijson':
    ensure   => 'latest',
    provider => pip,
  } ->
  package{'python-django16':
    ensure   => 'latest',
  } ->
  package{'uwsgi':
    ensure   => 'latest',
  } ->
  class{'nginx':} ->
  vcsrepo{'/CIMetricsTool':
    source   => 'https://github.com/openstack-hyper-v/CIMetricsAggregator',
    provider => 'git',
    ensure   => 'latest',
  } ->
  class{'::mysql::server':
    root_password => 'hard24get',
  } ->
  mysql::db { 'cimetrics_db':
    user     => 'cimetrics',
    password => 'cimetrics',
    host     => 'localhost',
    grant    => ['CREATE','INSERT','SELECT','DELETE','UPDATE'],
  } ->
  class{'mysql::bindings':
    python_enable => 'true',
    php_enable    => 'true',
    perl_enable   => 'true',
  } ->
  file {'/CIMetricsTool/statsproj/openstack_stats/openstack_stats':
    ensure => present,
    source => template('ms_openstack_ci_metrics/settings.py.erb'),
  }

}
