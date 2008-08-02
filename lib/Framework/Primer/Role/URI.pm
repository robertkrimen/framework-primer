package Framework::Primer::Role::URI;

use Moose::Role;

use URI;

has uri => qw/is ro lazy_build 1 isa URI/;
sub _build_uri {
    my $self = shift;
    return URI->new($self->cfg->{uri});
};

has rsc => qw/is ro lazy_build 1 isa Path::Resource/;
sub _build_rsc {
    my $self = shift;
    return Path::Resource->new(uri => $self->uri, dir => $self->var_htdocs_dir);
};

1;
