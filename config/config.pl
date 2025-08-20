#!/usr/bin/perl
# Docker Configuration File For NetRun
#    require 'config.pl'

package config;

$admin_email='admin@netrun.local';
$run_dir='/opt/netrun';
$url_dir='/netrun';
$end_page='<hr>
<p align=right>
<select id="theme">
<option value="light">Light Theme</option>
<option value="dark">Dark Theme</option>
</select>
<a href="mailto:admin@netrun.local">NetRun Admin</a>
';

# Docker-specific backend configuration
$backend_host=$ENV{'NETRUN_BACKEND_HOST'} || 'netrun-runner';
$backend_port=$ENV{'NETRUN_BACKEND_PORT'} || '9922';

package main;