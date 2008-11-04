#!/usr/bin/env perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::ZofCMS::PluginReference' );
}

diag( "Testing App::ZofCMS::PluginReference $App::ZofCMS::PluginReference::VERSION, Perl $], $^X" );
