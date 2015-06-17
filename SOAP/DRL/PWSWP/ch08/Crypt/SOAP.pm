# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package Crypt::SOAP;

use strict;
use vars qw(%known_cbc);

use SOAP::Lite;
use Crypt::CBC;

# A mapping table of the cyphers that can be used with the
# Crypt::CBC module. The key is the lc'd name for matching
# and the value is what must get passed to Crypt::CBC::new
%known_cbc = ( des      => 'DES',
               idea     => 'IDEA',
               blowfish => 'Blowfish',
               rc6      => 'RC6',
               rijndael => 'Rijndael' );

package Crypt::SOAP::Transport;

use strict;
use vars qw(@ISA);
use subs qw(new proxy cipher key iv padding prepend_iv
            as_hex encrypt decrypt crypt);

@ISA = qw(SOAP::Transport);

sub new {
    my ($class, @args) = @_;
    return $class if ref $class;

    # While SOAP::Transport::new takes no arguments, there
    # are a number of attributes in this class, any of
    # which can be set in the constructor.
    my $self = $class->SUPER::new();
    my ($method, $value);
    while (@args) {
        ($method, $value) = splice(@args, 0, 2);
        $self->can($method) ?
            $self->$method($value) :
            die "$class: Unknown parameter $method in new";
    }

    $self;
}

sub proxy {
    my $self = shift->new;
    my $class = ref $self;

    return $self->{_proxy} unless @_;

    my ($cipher, $proto);
    my $endpoint = shift;
    if ($endpoint =~ /^(\w+):/) {
        ($cipher, $proto) = split(/-/, $1);
        $endpoint =~ s/^$cipher-//;
    } else {
        die "$class: No transport protocol in proxy";
    }
    if ($cipher = $Crypt::SOAP::known_cbc{lc $cipher}) {
        $self->cipher($cipher);
    } else {
        die "$class: Cipher $cipher unknown or unsupported "
            . 'in proxy';
    }

    $self->SUPER::proxy($endpoint, @_);
    # This is cheating, using knowledge of SOAP::Transport
    # internal keys. But it is necessary as long as the
    # super-class proxy method only takes string arguments.
    $self->{_proxy} =
        Crypt::SOAP::Client->new($self, $self->{_proxy});
}

sub encrypt { shift->crypt('E', shift) }
sub decrypt { shift->crypt('D', shift) }

sub crypt {
    my ($self, $direction, $text) = @_;

    die ref($self) . ": both 'direction' and 'text' must " .
        'be passed to crypt'
            unless ($direction and $text);

    # This relies on the application having set most of
    # these attributes already
    my $cipher = Crypt::CBC->new({
                                  key => $self->key,
                                  cipher => $self->cipher,
                                  $self->iv ?
                                  (iv => $self->iv) : (),
                                  $self->padding ?
                                  (padding =>
                                   $self->padding) : (),
                                  prepend_iv =>
                                  $self->prepend_iv || 0
                                 });

    my $method =
        ($direction =~ /^e/i) ? 'encrypt' : 'decrypt';
    $method .= '_hex' if $self->as_hex;

    $cipher->$method($text);
}

BEGIN {
    no strict 'refs';
    for my $method (qw(cipher key iv padding prepend_iv
                       as_hex)) {
        my $field = "_$method";
        *$method = sub {
            my $self = shift->new;
            @_ ? ($self->{$field} = shift, return $self) :
                 return $self->{$field};
        }
    }
}

package Crypt::SOAP::Server;

use strict;
use vars qw(@ISA);
use subs qw(import subclass new handle);

sub import {
    my ($class, $new_parent, $load_class) = @_;

    @ISA = ($new_parent);

    # Attempt to load the module that provides the parent
    # class, unless expressly told not to
    return $class if (defined($load_class) and
                      ("$load_class" eq '0'));
    if ($load_class) {
        eval { require $load_class };
        die "$class: Error loading $load_class: $@" if $@;
    } else {
        # First we try the parent name directly
        eval { require $new_parent };
        # If that failed and the last 8 character of the
        # classname are "::Server", trim that and try again
        if ($@ and substr($new_parent, -8) eq '::Server') {
            substr($new_parent, -8) = '';
            eval { require $new_parent };
            die "$class: Error loading $new_parent " .
                "(derived from ${new_parent}::Server: $@"
                    if $@;
        } else {
            die "$class: Error loading $new_parent: $@";
        }
    }

    $class;
}

# Just a little alias to avoid confusing people not used to
# thinking of import() as just another function. Allows an
# application to say "->subclass($new_parent)" instead.
sub subclass {
    shift->import(@_);
}

sub new {
    my ($class, %args) = @_;
    return $class if ref $class;

    die "$class: Cannot create objects without a parent " .
        'class specified first'
            unless (@ISA);

    # Save any arguments intended for the transport object
    # so they can be passed to new() later.
    my $transport_args;
    if ($args{transport}) {
        $transport_args = $args{transport};
        delete $args{transport};
    }
    my $self = $class->SUPER::new(%args);
    # The CSS in the key is to hopefully avoid collision
    $self->{_CSS_transport} =
        Crypt::SOAP::Transport->new($transport_args ?
                                    @$transport_args : ());

    $self;
}

sub handle {
    my ($self, $message) = @_;

    $message = $self->{_CSS_transport}->decrypt($message);
    $self->SUPER::handle($message);
}

package Crypt::SOAP::Client;

use strict;
use vars qw(@ISA);
use subs qw(new send_receive);

sub new {
    my ($class, $transport, $client) = @_;
    return $class if ref $class;

    # The only purpose of this new() method is to hang a
    # reference to $transport on the object and re-bless it
    # into this class, after setting the @ISA path to
    # include the original class.
    die "$class: new() must be called with a transport " .
        'object and an existing client object'
            unless (UNIVERSAL::can($transport, 'new') &&
                    UNIVERSAL::can($client, 'new'));
    # The key here hopes to avoid collisions
    $client->{_CSC_transport} = $transport;
    @ISA = (ref $client);
    bless $client, $class;
}

sub send_receive {
    my $self = shift;
    my %args = @_;

    $args{envelope} = $self->{_CSC_transport}
                           ->encrypt($args{envelope});
    $self->SUPER::send_receive(%args);
}

1;

