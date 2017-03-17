use ExtUtils::MakeMaker;
use lib '../lib';
use Bio::Tools::PSort::Install;

$CC = 'g++';

%args = ();

@libs = qw/svmloc/;
%paths = ();
$libpath = '-lm -lstdc++';

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

if($^O eq 'cygwin') {
  $args{'LDDLFLAGS'} = '-shared -L/usr/local/lib';
}

WriteMakefile('NAME'          => 'Bio::Tools::PSort::SVMLoc',
	      'VERSION_FROM'  => 'lib/Bio/Tools/PSort/SVMLoc.pm',
	      'PREREQ_PM'     => {},
	      ($] >= 5.005 ?
	       (ABSTRACT_FROM => 'lib/Bio/Tools/PSort/SVMLoc.pm',
		AUTHOR        => 'Matthew Laird <matt@brinkman.mbb.sfu.ca>') : ()),
	      'OPTIMIZE'      => '-O3',  # segfaults with gcc 2.96 if lower (?)
	      'LIBS'          => $libpath,
	      'CC'            => $CC,
	      'LD'            => '$(CC)',
	      'XSOPT'         => '-C++',
              %args);
