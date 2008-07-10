use inc::Module::Install;

name 'Framework-Primer';
all_from 'lib/Framework/Primer.pm';

build_requires 'Test::More';

auto_install;

WriteAll;

