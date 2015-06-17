use ExtUtils::MakeMaker;
use File::Spec;
use File::Find;

@PM_FILES = ();

find(sub { push(@PM_FILES, $File::Find::name) if (-f $_ and /\.pm$/) }, '.');

%PM_FILES = map { ($temp = $_) =~ s|^\.|\$\(INST_LIB\)|; $_ => $temp }
    @PM_FILES;

WriteMakefile(NAME => 'ch07-examples',
              VERSION => 1,
              PM => \%PM_FILES,
              EXE_FILES => [],
              clean => { FILES => '*.db' });

sub MY::postamble
{
    my $self = shift;

    my @text;

    push(@text,
         'users.db: users.csv',
         "\t\$(PERL) csv2dbm \$<",
         '',
         'catalog.db: catalog.csv',
         "\t\$(PERL) csv2dbm \$<",
        );

    join("\n", @text);
}
