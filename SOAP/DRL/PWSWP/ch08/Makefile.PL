use ExtUtils::MakeMaker;
use File::Spec;
use File::Find;

@PM_FILES = ();

find(sub { push(@PM_FILES, $File::Find::name) if (-f $_ and /\.pm$/) }, '.');

%PM_FILES = map { ($temp = $_) =~ s|^\.|\$\(INST_LIB\)|; $_ => $temp }
    @PM_FILES;

WriteMakefile(NAME => 'ch08-examples',
              VERSION => 1,
              PM => \%PM_FILES,
              EXE_FILES => []);
