package Framework::Primer::Static::Component;

use Moose::Role;

has framework_primer_handle => qw/is ro required 1 isa Framework::Primer::Static::Base/;

1;
