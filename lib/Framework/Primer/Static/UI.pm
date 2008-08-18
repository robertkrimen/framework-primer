package Framework::Primer::Static::UI;

use Moose;

with qw/Framework::Primer::UI Framework::Primer::Static::Component/;

sub build_uri {
    return $_[0]->framework_primer_handle->cfg->{uri};
}

1;
