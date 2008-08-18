package Framework::Primer::Static::Base;

use Moose;

use Framework::Primer::Static::Class;

use Class::Inspector;

BEGIN {
    extends qw/Framework::Primer::Base/;
}

{
    my $CALLER;

    sub import {
        $CALLER = _get_caller(@_);

        return if $CALLER eq 'main';

        shift;

        Framework::Primer::Static::Class->setup_base_class(class => $CALLER, @_);
    }

    sub _get_caller{
        my $offset = 1;
        return
            (ref $_[1] && defined $_[1]->{into})
                ? $_[1]->{into}
                : (ref $_[1] && defined $_[1]->{into_level})
                    ? caller($offset + $_[1]->{into_level})
                    : caller($offset);
    }

}

has ui => qw/is ro lazy_build 1 isa Framework::Primer::Static::UI/;
sub _build_ui {
    my $self = shift;
    my $class = ref $self;
    my $ui_class = "${class}::UI";
    if (Class::Inspector->installed($ui_class)) {
        # TODO Load the class
    }
    else {
        Framework::Primer::Static::Class->setup_ui_class(create => 1, base_class => $class, class => $ui_class, @_);
    }
    return $ui_class->new(framework_primer_handle => $self);
}

1;
