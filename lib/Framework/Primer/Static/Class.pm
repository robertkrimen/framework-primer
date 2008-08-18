package Framework::Primer::Static::Class;

use strict;
use warnings;

use Framework::Primer();
use Framework::Primer::Carp;

use MooseX::ClassAttribute();
use Class::Inspector;

require Framework::Primer::Static::Base;
require Framework::Primer::Static::UI;

sub setup_base_class {
    my $self = shift;
    my %given = @_;

    my $class = $given{class};
    my $name = $given{name} or croak "Wasn't given name for $class";

    $class->meta->superclasses(qw/Framework::Primer::Static::Base/);

    Framework::Primer->setup_dir($class, $given{dir}) if $given{dir};

    Framework::Primer->setup_config_default($class, $given{config}) if $given{config};

    MooseX::ClassAttribute::process_class_attribute($class => name => qw/is ro required 1 isa Str/, default => $name);
}

sub setup_ui_class {
    my $self = shift;
    my %given = @_;

    my $base_class = $given{base_class};
    my $class = $given{class};

    my $meta;
    if ($given{create}) {
        $meta = Moose::Meta::Class->create($class);
    }
    else {
        $meta = $class->meta;
    }

    $meta->superclasses(qw/Moose::Object Framework::Primer::Static::UI/);

    $base_class ||= do {
        ($base_class = $class) =~ s/::UI$//;
        $base_class;
    };
#    $meta->add_attribute($base_class->name, qw/is ro required 1 weak_ref 1/, isa => $base_class);
    $meta->add_method($base_class->name => sub {
        return $_[0]->framework_primer_handle;
    });
}

1;
