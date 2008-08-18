package Framework::Primer::Base;

use Moose;
use Framework::Primer();
use Framework::Primer::Carp;
use Framework::Primer::Types;

use Config::JFDI;

has name => qw/is ro/;

has home_dir => qw/is ro coerce 1 lazy_build 1/, isa => Dir;
sub _build_home_dir {
    return Path::Class::Dir->new("./")->absolute;
}

has config_default => qw/is ro lazy_build 1/;
sub _build_config_default {
    return {};
}

has _config => qw/is ro lazy_build 1 isa Config::JFDI/;
sub _build__config {
    my $self = shift;
    return Config::JFDI->new(path => $self->home_dir."", name => $self->name);
};
sub config {
    return shift->_config->get;
}
sub cfg {
    return shift->config;
}

sub SETUP {
    my $self = shift;
    my $given = shift;

    my $class = $given->{class};

    Framework::Primer->setup_name($class, $given->{name}) if $given->{name};

    Framework::Primer->setup_dir($class, $given->{dir}) if $given->{dir};

    Framework::Primer->setup_config_default($class, $given->{config}) if $given->{config};
}

sub publish_dir {
    my $self = shift;

    Framework::Primer->publish_dir(@_);
}

1;
