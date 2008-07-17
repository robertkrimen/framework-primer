package Framework::Primer;

use warnings;
use strict;

=head1 NAME

Framework::Primer -

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

require Moose;
use Sub::Exporter;
use Framework::Primer::Types;
use Carp;

sub setup_dir {
    my $self = shift;
    my $class = shift;
    my $manifest = shift;

    for my $path (sort grep { ! /^\s*#/ } split m/\n/, $manifest) {
        my @path = split m/\//, $path;
        my $last_dir = pop @path;

        my $dir = join "_", @path, $last_dir;
        my $parent_dir = @path ? join "_", @path : qw/home/;

        my $dir_method = "${dir}_dir";
        my $parent_dir_method = "${parent_dir}_dir";
        $dir_method =~ s/\W/_/g;
        $parent_dir_method =~ s/\W/_/g;

        next if $class->can($dir_method);

        $class->meta->add_attribute($dir_method => qw/is ro required 1 coerce 1 lazy 1/, isa => Dir, default => sub {
            return shift->$parent_dir_method->subdir($last_dir);
        }, @_);
    }
}

sub setup_name {
    my $self = shift;
    my $class = shift;
    my $name = shift;

#    croak "$class already has name method" if $class->can("name") && $class->meta->has_attribute("name");
#    croak "$class already has name method" unless $class->meta->has_attribute("name");

    $class->meta->add_attribute("+name" => default => $name);
}

BEGIN {
    my $CALLER;

    my %exports = (

#        has_home_dir => sub {
#            my $class = $CALLER;
#            return sub {
#                my $name = shift;
#                $name = "home_dir";
#                $class->meta->add_attribute($name => qw/is ro required 1 coerce 1/, isa => Dir, default => "./", @_);
#            };
#        },

        has_dir => sub {
            my $class = $CALLER;
            return sub {
                my $path = shift;

                my @path = split m/\//, $path;
                my $last_dir = pop @path;

                my $dir = join "_", @path, $last_dir;
                my $parent_dir = @path ? join "_", @path : qw/home/;

                my $dir_method = "${dir}_dir";
                my $parent_dir_method = "${parent_dir}_dir";
                $dir_method =~ s/\W/_/g;
                $parent_dir_method =~ s/\W/_/g;

                $class->meta->add_attribute($dir_method => qw/is ro required 1 coerce 1 lazy 1/, isa => Dir, default => sub {
                    return shift->$parent_dir_method->subdir($last_dir);
                }, @_);
            };
        },

        name => sub {
            my $class = $CALLER;
            return sub {
                my $name = shift;
                $class->meta->add_attribute("+name" => default => $name);
            };
        }

#        has_file => sub {
#            my $class = $CALLER;
#            return sub {
#                my $file = shift;
#                my $name = join "_", split m/\//, $file;
#                $class->meta->add_attribute("${name}_file" => qw/is ro required 1 coerce 1 lazy 1/, isa => File, default => sub {
#                    return shift->home_file->subfile($file);
#                }, @_);
#            };
#        },
    );
    
    my $exporter = Sub::Exporter::build_exporter({
        exports => \%exports,
        groups  => { default => [':all'] }
    });

    sub import {
        $CALLER = Moose::_get_caller(@_);

        strict->import;
        warnings->import;

        return if $CALLER eq "main";

        goto &$exporter;
    }
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-framework-primer at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Framework-Primer>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Framework::Primer


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Framework-Primer>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Framework-Primer>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Framework-Primer>

=item * Search CPAN

L<http://search.cpan.org/dist/Framework-Primer>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Framework::Primer
