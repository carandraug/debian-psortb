use ExtUtils::MakeMaker;
use lib '../lib';
use Bio::Tools::PSort::Install;

my $CC = 'g++';

@libs = qw/hmmer squid/;
%paths = ();
$libpath = '-lm -lpthread -lstdc++';

$defaults_file = '../psortb.defaults';
if( -f $defaults_file ) {
    unless ($return = do $defaults_file) {
        warn "couldn't parse $file: $@" if $@;
        warn "couldn't do $file: $!"    unless defined $return;
        warn "couldn't run $file"       unless $return;
    }
    do $defaults_file;
} 

if($additional_libpath) {
    $libpath .= ' ' . $additional_libpath . ' ' . join(' ', map { '-l' . $_ } @libs);
} else {
    $libpath .= Bio::Tools::PSort::Install->makeLibPath(@libs);
}

WriteMakefile('NAME'          => 'Algorithm::HMM',
	      'VERSION_FROM'  => 'lib/Algorithm/HMM.pm',
	      'PREREQ_PM'     => {},
	      ($] >= 5.005 ?
	       (ABSTRACT_FROM => 'lib/Algorithm/HMM.pm',
		AUTHOR        => 'Cory Spencer <cspencer@sfu.ca>') : ()),
	      'LIBS'          => $libpath,
	      'CC'            => $CC,
	      'LD'            => '$(CC)',
	      'INC'           => '-Isrc/include',
	      'OBJECT'        => "HMM.o hmm-binding.o",
	      'XSOPT'         => '-C++',
	      );
