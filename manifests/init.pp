# == Class: ms_openstack_ci_metrics
#
# Full description of class ms_openstack_ci_metrics here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'ms_openstack_ci_metrics':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ms_openstack_ci_metrics {

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
  }

}
