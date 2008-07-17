use inc::Module::Install;

name 'Framework-Primer';
all_from 'lib/Framework/Primer.pm';

build_requires 'Test::More';

{
    require ExtUtils::MakeMaker;
    use strict;
    no strict 'refs';

    my $libscan = \&{"ExtUtils::MM_Any::libscan"};
    *{"ExtUtils::MM_Any::libscan"} = sub {
        return '' unless $libscan->(@_);
        return '' if $_[1] =~ /\.sw[p-z]$/;
        return $_[1];
    };
}

{
    for (grep { ! /^\s*#/ } split m/\n/, <<_END_) {
Moose
MooseX::Types
MooseX::Types::Path::Class
MooseX::Types::UUID
_END_
        my ($package, $version) = split m/\s/;
        requires $package => $version || 0;
    }
}

auto_install;

WriteAll;

