package Framework::Primer::UI;

use Moose::Role;
use Framework::Primer::Carp;
use Framework::Primer::Types;

use Path::Abstract::URI;
use Template;

has _uri => qw/is ro lazy_build 1 isa Path::Abstract::URI/;
sub _build__uri {
    my $self = shift;
    my $method = "build_uri";
    croak "Don't have method \"$method\"" unless my $build = $self->can($method);
    my $got = $build->($self, @_);

    return $got if blessed $got && $got->isa("Path::Abstract::URI");
    return Path::Abstract::URI->new($got);
}

sub uri {
    my $self = shift;
    my $uri = $self->_uri;
    return $uri->clone unless @_;

    my @path = @_;
    my $query;
    $query = pop @path if ref $path[-1] eq "ARRAY" || ref $path[-1] eq "HASH";
    $uri = $uri->child(@path);
    $uri->query_form($query) if $query;
    return $uri;
}

sub href {
    my $self = shift;
    # TODO Escaping?
    my $uri = $self->uri(@_);
    return qq/href="$uri"/;
}

sub src {
    my $self = shift;
    # TODO Escaping?
    my $uri = $self->uri(@_);
    return qq/src="$uri"/;
}

has tt => qw/is ro lazy_build 1 isa Template/;
sub _build_tt {
    my $self = shift;
    my $method = "build_tt";
    croak "Don't have method \"$method\"" unless my $build = $self->can($method);
    my $got = $build->($self, @_);

    return $got if blessed $got && $got->isa("Template");
    return Template->new($got) if ref $got eq "HASH";
    return Template->new unless $got;

    croak "Don't know how to build Template with $got";
}

sub build_tt {
    return {};
}

sub process_tt {
    my $self = shift;
    my %given = @_;

    my ($input, $output, $context, @process);

    {
        $input = $given{input};
        croak "Wasn't given input" unless defined $input;
    }

    {
        $output = $given{output};
        my $output_content;
        $output = \$output_content unless exists $given{output};

        if (blessed $output) {
            if ($output->isa("Path::Resource")) {
                $output = $output->file;
            }
            if ($output->isa("Path::Class::File")) {
                $output = "$output";
            }
        }

        if (defined $output && ! ref $output) {
            $output = Path::Class::File->new($output);
            $output->parent->mkpath unless -d $output->parent;
            $output = "$output";
        }
    }

    {
        $context = $self->_tt_context($given{context}, @_);
    }

    if ($given{process}) {
        @process = @{ $given{process} };
    }
    else {
        @process = qw/binmode :utf8/;
    }

    my $tt = $self->tt;
    $tt->process($input, $context, $output, @process) or croak "Couldn't process $input => $output: ", $tt->error;

    return $$output unless exists $given{output};

    return $output if ref $output eq "SCALAR";
}

has tt_context_sticky => qw/is ro isa HashRef lazy_build 1/;
sub _build_tt_context_sticky {
    my $self = shift;
    return {
        uri_for => sub { return $self->uri_for(@_) },
        href => sub { return $self->href(@_) },
        src => sub { return $self->src(@_) },
    };
}

sub _tt_context {
    my $self = shift;
    my $context = shift || {};

    {
        my $sticky = $self->tt_context_sticky;
        $context->{ui} ||= $self;
        $context->{$_} = $sticky->{$_} for keys %{ $sticky };
    }

    my @context = $self->tt_context($context, @_);
    if (1 == @context && ref $context[0] eq "HASH") {
        return $context[0];
    }
    elsif (@context % 2 == 0) {
        my %context = @context;
        $context->{$_} = $context{$_} for keys %context;
    }
    elsif (@context) {
        croak "Don't know what to do with (@context)";
    }

    return $context;
}

sub tt_context {
}

1;
