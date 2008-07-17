package Framework::Primer::Base;

use Moose;
use Framework::Primer;
use Framework::Primer::Carp;
use Framework::Primer::Types;

use Config::JFDI;
use URI;

has name => qw/is ro required 1/;

has home_dir => qw/is ro required 1 coerce 1/, isa => Dir, default => "./";
has_dir $_ for qw(var var/htdocs);

has _cfg => qw/is ro required 1 lazy 1 isa Config::JFDI/, default => sub {
    my $self = shift;
    return Config::JFDI->new(path => $self->home_dir->stringify, name => $self->name);
};
sub cfg {
    return shift->_cfg->get;
}

has uri => qw/is ro required 1 lazy 1 isa URI/, default => sub {
    my $self = shift;
    return URI->new($self->cfg->{uri});
};

has rsc => qw/is ro required 1 lazy 1 isa Path::Resource/, default => sub {
    my $self = shift;
    return Path::Resource->new(uri => $self->uri, dir => $self->var_htdocs_dir);
};


1;
