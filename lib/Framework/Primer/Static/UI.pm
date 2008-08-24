package Framework::Primer::Static::UI;

use Moose;

use Path::Resource;

with qw/Framework::Primer::UI Framework::Primer::Static::Component/;

sub build_uri {
    return $_[0]->kit->cfg->{uri};
}

has rsc => qw/is ro lazy_build 1 isa Path::Resource/;
sub _build_rsc {
    my $self = shift;
    return Path::Resource->new(uri => $self->uri, dir => $self->kit->var_htdocs_dir);
}

sub build_tt {
    my $self = shift;
    if (my $method = $self->kit->can("build_tt")) {
        return $method->($self->kit, @_);
    }
    return {
        PRE_PROCESS => [ qw/common.tt.html/ ],
        INCLUDE_PATH => [ $self->kit->assets_tt_dir."" ],
    };
}

sub tt_context {
    my $self = shift;
    if (my $method = $self->kit->can("tt_context")) {
        return $method->($self->kit, @_);
    }
    return ();
}

1;
