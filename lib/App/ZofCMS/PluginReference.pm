package App::ZofCMS::PluginReference;

use warnings;
use strict;

our $VERSION = '0.0107';


1;
__END__

=head1 NAME

App::ZofCMS::PluginReference - docs for all plugins in one document for easy reference

=head1 DESCRIPTION

I often found myself reaching out for docs for different plugins cluttering up my browser. The solution - stick all docs into one!.

=head1 App::ZofCMS::Plugin::AccessDenied (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::AccessDenied>



App::ZofCMS::Plugin::AccessDenied - ZofCMS plugin to restrict pages based on user access roles

SYNOPSIS

    plugins => [
        { AccessDenied => 2000 },
    ],

    # this key and all of its individual arguments are optional
    # ... default values are shown here
    plug_access_denied => {
        role            => sub { $_[0]->{d}{user}{role} },
        separator       => qr/\s*,\s*/,
        key             => 'access_roles',
        redirect_page   => '/access-denied',
        master_roles    => 'admin',
        no_exit         => 0,
    },

    # this user has three roles; but this page requires a different one
    d => { user => { role => 'foo, bar,baz', }, },
    access_roles => 'bez',

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to
restrict access to various pages. It's designed to work in conjunction
with L<App::ZofCMS::Plugin::UserLogin> plugin; however, the use of that
plugin is not required.

This documentation assumes you've read L<App::ZofCMS>, 
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        { AccessDenied => 2000 },
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to
execute.

C<plug_access_denied>

    # default values shown
    plug_access_denied => {
        role            => sub { $_[0]->{d}{user}{role} },
        separator       => qr/\s*,\s*/,
        key             => 'access_roles',
        redirect_page   => '/access-denied',
        master_roles    => 'admin',
        no_exit         => 0,
    },

    # or
    plug_access_denied => sub {
        my ( $t, $q, $config ) = @_;
        return $hashref_to_assign_to_plug_access_denied_key;
    },

B<Optional>.
Takes either a hashref or a subref as a value. If not specified, B<plugin
will still run>, and all the defaults will be assumed. If subref is
specified, its return value will be assigned to C<plug_access_denied> as if
it was already there. The C<@_> of the subref will contain C<$t>, C<$q>,
and C<$config> (in that order): where C<$t> is ZofCMS Tempalate hashref,
C<$q> is query parameters hashref, and C<$config> is
L<App::ZofCMS::Config> object. Possible keys/values for the hashref are as
follows:

C<role>

    plug_access_denied => {
        role => sub { $_[0]->{d}{user}{role} },
    ...

B<Optional>. Takes a subref as a value. This argument tells the plugin
the access roles the current user (visitor) posseses and based on these, 
the access to the page will be either granted or denied. The C<@_> will
contain C<$t>, C<$q>, and C<$config> (in that order), where C<$t> is ZofCMS
Template hashref, C<$q> is query parameter hashref, and C<$config> isf
L<App::ZofCMS::Config> object. B<Defaults to:>
C<< sub { $_[0]->{d}{user}{role} } >> (i.e. attain the value from the
C<< $t->{d}{user}{role} >>). The subref must return one of the following:

a string

    plug_access_denied => {
        role => sub { return 'foo, bar, baz' },
    ...

If the sub returns a string, the plugin will take it as containing
one or more roles that the user (visitor of the page) has. Multiple roles
must be separated using C<separator> (see below).

an arrayref

    plug_access_denied => {
        role => sub { return [ qw/foo  bar  baz/ ] },
    ...

If sub returns an arrayref, each element of that arrayref will be assumed
to be one role.

a hashref

    plug_access_denied => {
        role => sub { return { foo => 1, bar => 1 } },
    ...

If hashref is returned, plugin will assume that the B<keys> of that hashref
are the roles; plugin doesn't care about the values.

C<separator>

    plug_access_denied => {
        separator => qr/\s*,\s*/,
    ...

B<Optional>. Takes a regex (C<qr//>) as a value. The value will be regarded
as a separator for page's access roles (listed in C<key> key, see
below), the value in C<role> (see above) if that argument is set to a
string, as well as the value of C<master_roles> argument (see below). 
B<Defaults to:> C<qr/\s*,\s*/>

C<key>

    plug_access_denied => {
        key => 'access_roles',
    ...

B<Optional>. Takes a string as a value. Specifies the key, inside C<{t}>
ZofCMS Template hashref's special key, under which a string with page's
roles is located.
Multiple roles must be separated with C<separator> (see above).
User must possess at least one of these roles in order to be allowed to
view the current page. B<Defaults to:> C<access_roles> (i.e.
C<< $t->{t}{access_roles} >>)

C<redirect_page>

    plug_access_denied => {
        redirect_page => '/access-denied',
    ...

B<Optional>. Takes a URI as a value. If access is denied to the visitor,
they will be redirected to URI specified by C<redirect_page>. B<Defaults
to:> C</access-denied>

C<master_roles>

    plug_access_denied => {
        master_roles => 'admin',
    ...

B<Optional>. Takes the string a value that contains "master" roles. If the
user has any of the roles specified in C<master_roles>, access to the page
will be B<granted> regardless of what the page's required roles (specified 
via C<key> argument) are. To disable C<master_roles>, use empty string. To 
specify several roles, separate them with your C<separator> (see above).
B<Defaults to:> C<admin>

C<no_exit>

    plug_access_denied => {
        no_exit => 0,
    ...

B<Optional>. Takes either true or false values as a value. If set to
a false value, the plugin will call C<exit()> after it tells the browser
to redirect unauthorized user to C<redirect_page> (see above); otherwise,
the script will continue to run, however, note that you B<will no longer
be able to "interface" with the user> (i.e. if some later plugin dies, user
will be already at the C<redirect_page>). B<Defaults to:> C<0> (false)


=head1 App::ZofCMS::Plugin::AntiSpamMailTo (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::AntiSpamMailTo>



App::ZofCMS::Plugin::AntiSpamMailTo - "smart" HTML escapes to protect mailto:foo@bar.com links from not-so-smart spam bots

SYNOPSIS

In your Main Config file or ZofCMS template:

    # include the plugin
    plugins => [ qw/AntiSpamMailTo/ ],

    # then this: 
    plug_anti_spam_mailto => 'bar',
    # or this:
    plug_anti_spam_mailto => [ qw/foo bar baz/ ],
    # or this:
    plug_anti_spam_mailto => {
        foo => 'bar',
        baz => 'beer',
    },

In your L<HTML::Template> template:

    <tmpl_var name="mailto">
    # or this:
    <tmpl_var name="mailto_0"> <tmpl_var name="mailto_1"> <tmpl_var name="mailto_2">
    # or this:
    <tmpl_var name="foo"> <tmpl_var name="baz">

DESCRIPTION

The module is an L<App::ZofCMS> plugin which provides means to deploy a technique that many
claim to be effective in protecting your C<< <a href="mailto:foo@bar.com"></a> >> links
from dumb spam bots.

The technique is quite simple (and simple to circumvent, but we are talking about B<dumb>
spam bots) - the entire contents of C<href=""> attribute are encoded as HTML entities. Dumb
spam bots miss the C<mailto:> and go their way. Anyway, on to the business.

This documentation assumes you have read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG/ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plug_anti_spam_mailto>

    plug_anti_spam_mailto => 'bar',

    plug_anti_spam_mailto => [ qw/foo bar baz/ ],

    plug_anti_spam_mailto => {
        foo => 'bar',
        baz => 'beer',
    },

The plugin takes it's data from C<plug_anti_spam_mailto> first-level key that is in either
ZofCMS template or config file. The key takes either a string, arrayref or a hashref as its
value. If the key is specified in both main config file and ZofCMS template B<and> the value
is of the same type (string, arrayref or hashref) then both values will be interpreted by
the plugin; in case of the hashref, any duplicate keys will obtain the value assigned to
them in ZofCMS template. B<Note:> if the value is of "type" C<string> specified in B<both>
main config file and ZofCMS template it will interpreted as an arrayref with two elements.
Now I'll tell you why this all matters:

value is a string

    plug_anti_spam_mailto => 'bar',

When the value is a string then in L<HTML::Template> template you'd access the converted
data via variable C<mailto>, i.e. C<< <tmpl_var name="mailto"> >>

value is an arrayref or a string in both ZofCMS template and main config file

    plug_anti_spam_mailto => [ qw/foo bar baz/ ],

To access converted data when the value is an arrayref you'd use C<mailto_NUM> where C<NUM>
is the index of the element in the arrayref. In other words, to access value C<bar> in the
example above you'd use C<< <tmpl_var name="mailto_1"> >>

value is a hashref

    plug_anti_spam_mailto => {
        foo => 'bar',
        baz => 'beer',
    },

You do not have to keep typing C<mailto> to access your converted data. When value is a hashref
the values of that hashref are the data to be converted and the keys are the names of
C<< <tmpl_var name""> >>s into which to stick that data. In the example above, to access
converted data for C<beer> you'd use C<< <tmpl_var name="baz"> >>

EXAMPLE

ZofCMS template:

    plugins => [ qw/AntiSpamMailTo/ ],
    plug_anti_spam_mailto => 'mailto:john.foo@example.com',

L<HTML::Template> template:

    <a href="<tmpl_var name="mailto">">email to John Foo</a>


=head1 App::ZofCMS::Plugin::AutoDump (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::AutoDump>



App::ZofCMS::Plugin::AutoDump - debugging plugin to quickly dump out query parameters and ZofCMS Template hashref

SYNOPSIS

    plugins => [
        { Sub => 200 },
        { AutoDump => 300 },
    ],

    plug_sub => sub { ## this is optional, just for an example
        my ( $t, $q ) = @_;
        $t->{foo} = 'bar';
        $q->{foo} = 'bar';
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to quickly use L<Data::Dumper>
to dump query parameters hashref as well as ZofCMS Template hashref.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

HOW TO USE

    plugins => [
        { Sub => 200 },
        { AutoDump => 300 },
    ],

This plugin requires no configuration. To run it simply include it in the list of plugins
to execute with the priority set at the right point of execution line.

HOW IT WORKS

Plugin assumes that you're using L<CGI::Carp> (should be on by default if you've used
C<zofcms_helper> script to generate site's skeleton). When plugin is run it calls
C<die Dumper [ $q, $t ]> where C<$q> is query parameters hashref and C<$t> is
ZofCMS Template hashef... therefore, in the browser's output the first hashef is the query.


=head1 App::ZofCMS::Plugin::AutoEmptyQueryDelete (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::AutoEmptyQueryDelete>



App::ZofCMS::Plugin::AutoEmptyQueryDelete - automatically delete empty keys from query parameters

SYNOPSIS

    plugins => [
        { AutoEmptyQueryDelete => 100 },
        # plugins that work on query parameters with larger priority value
    ],

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that I made after I got sick and tired of
constantly writing this (where C<$q> is query parameters hashref):

    do_something
        if defined $q->{foo}
            and length $q->{foo};

By simply including this module in the list of plugins to run, I can save a few keystrokes
by writing:

    do_something
        if exists $q->{foo};

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

WHAT DOES THE PLUGIN DO

The plugin doesn't do much, but simply C<delete()>s query parameters that are not defined
or are of zero length if they are. With that being done, we can use a simple C<exists()>
on a key.

USING THE PLUGIN

Plugin does not need any configuration. It will be run as long as it is included
in the list of the plugins to run:

    plugins => [
        { AutoEmptyQueryDelete => 100 },
        # plugins that work on query parameters with larger priority value
    ],

Make sure that the priority of the plugin is set to run B<before> your other code
that would check on query with C<exists()>


=head1 App::ZofCMS::Plugin::AutoIMGSize (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::AutoIMGSize>



App::ZofCMS::Plugin::AutoIMGSize - automatically get image sizes and generate appropriate <img> tags

SYNOPSIS

In your Main Config or ZofCMS Template file:

    plugins => [ qw/AutoIMGSize/ ],
    plug_auto_img_size => {
        imgs => {
            logo    => 'pics/top_logo.png'
            kitteh  => 'pics/kitteh.jpg',
            blah    => { 'somewhere/there.jpg' => ' class="foo"' },
        },
    },

In your L<HTML::Template> template:

    Logo: <tmpl_var name="img_logo">
    Kitteh: <tmpl_var name="img_kitteh">
    blah: <tmpl_var name="img_blah">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to generate HTML
C<< <img ... > >> tags with automatic image size generation, i.e. the plugin gets the size
of the image from the file. Personally, I use it in templates where the size of the
image is unknown, if the image is static and you can physically type in the address, it would
be saner to do so.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE OR ZofCMS TEMPLATE KEYS

C<plugins>

    plugins => [ qw/AutoIMGSize/ ],

You would obvisouly want to add the plugin to the list of plugins to run. Play with priorities
if you are loading image paths dynamically.

C<plug_auto_img_size>

    plug_auto_img_size => {
        xhtml       => 1,
        t_prefix    => 'img_',
        imgs => {
            logo    => 'pics/logo.png',
            kitteh  => { 'pics/kitteh.jpg' => ' class="kitteh' },
        },
    },

The C<plug_auto_img_size> first-level Main Config file or ZofCMS Template file is what
makes the plugin run. If you specify this key in both ZofCMS Template and Main Config file
then keys set in ZofCMS Template will override the ones set in Main Config file. B<Note:>
the C<imgs> key will be completely overridden.

The key takes a hashref as a value. Possible keys/values of that hashref are as follows:

C<imgs>

    imgs => [ qw/foo.jpg bar.jpg/ ],
    #same as
    imgs => {
        'foo.jpg' => 'foo.jpg',
        'bar.jpg' => 'bar.jpg',
    },

B<Mandatory>. The C<imgs> key takes either an arrayref or a hashref as a value. If the
value is an arrayref, it will be converted to a hashref where keys and values are the same.

The key in the hashref specifies the "name" of the key in C<{t}> ZofCMS Template special key to
which the C<t_prefix> (see below) will be prepended. The value specifies the image
filename relative to ZofCMS C<index.pl> file (root dir of your website, basically). The value
of each key can be either a string or a hashref. If it's a string, it will be taken as a
filename of the image. If it is a hashref it must contain only one key/value pair; the key
of that hashref will be taken as a filename of the image and the value will be taken as
extra HTML attributes to insert into C<< <img> >> tag. Note that the value, in this case,
should begin with a space as to not merge with the width/height attributes. Note 2: unless
the value is a hashref, the C<alt=""> attribute will be set to an empty string; otherwise
you must include it in "extra" html attributes. Here are a few
examples (which assume that C<t_prefix> (see below) is set to its default value: C<img_>;
and size of the image is 500px x 500px):

    # ZofCMS template:
    imgs => [ qw/foo.jpg/ ]

    # HTML::Template template:
    <tmpl_var name="img_foo.jpg">

    # Resulting HTML code:
    <img src="/foo.jpg" width="500" height="500" alt="">

B<Note:> that image C<src=""> attribute is made relative to root path of your website (i.e.
starts with a slash C</> character).

    # ZofCMS tempalte:
    imgs => { foo => 'pics/foo.jpg' },

    # HTML::Template template:
    <tmpl_var name="img_foo">

    # Resulting HTML code:
    <img src="/pics/foo.jpg" width="500" height="500" alt="">

Now with custom attributes (note the leading space before C<alt=""> attribute):

    # ZofCMS template:
    imgs => { foo => { 'pics/foo.jpg' => ' alt="foos" class="foos"' } }

    # HTML::Template template:
    <tmpl_var name="img_foo">

    # Resulting HTML code:
    <img src="/pics/foo.jpg" width="500" height="500" alt="foos" class="foos">

Note: if plugin cannot find your image file then the C<< <img> >> tag will be replaced with
C<ERROR: Not found>.

C<t_prefix>

    t_prefix => 'img_',

B<Optional>. The C<t_prefix> takes a string as a value, this string will be prepended to
the "name" of your images in C<{t}> ZofCMS Template special key. In other words, if
you set C<< t_prefix => 'img_', imgs => { foo => 'pics/bar.jpg' } >>, then in your
L<HTML::Template> template you'd insert your image with C<< <tmpl_var name="img_foo"> >>.
B<Defaults to:> C<img_> (note the underscore (C<_>) at the end)

C<xhtml>

    xhtml => 1,

B<Optional>. When set to a true value the C<< <img> >> tag will be closed with C<< /> >>.
When set to a false value the C<< <img> >> tag will be closed with C<< > >>. B<Default to:>
C<0> (false)

DEPENDENCIES

The module relies on L<Image::Size> to get image sizes.


=head1 App::ZofCMS::Plugin::Barcode (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::Barcode>



App::ZofCMS::Plugin::Barcode - plugin to generate various bar codes

SYNOPSIS

In your Main Config File or ZofCMS Template:

    plugins => [
        qw/Barcode/
    ],

    # direct output to browser with default values for optional arguments
    plug_barcode => {
        code => '12345678901',
    },

    # or

    # save to file with all options set
    plug_barcode => {
        code    => '12345678901',
        file    => 'bar.png',
        type    => 'UPCA', # default
        format  => 'png',  # default
        no_text => 0,      # default
        height  => 50,     # default
    },

In your HTML::Template template (in case errors occur):

    <tmpl_if name='plug_barcode_error'>
        <p>Error: <tmpl_var escape='html' name='plug_barcode_error'></p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to generate various
types of barcodes and either output them directly to the browser or save them as
an image.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/Barcode/
    ],

B<Mandatory>.
You need to add the plugins to the list of plugins to execute. B<Note:> if you're outputting
directly to the browser instead of saving the barcode into a file, the B<plugin will call
exit() as soon as it finishes print()ing the image UNLESS an error occured>, so make sure to
run anything that needs to be run before that point.

C<plug_barcode>

    # direct output to browser with default values for optional arguments
    plug_barcode => {
        code => '12345678901',
    },

    # save to file with all options set
    plug_barcode => {
        code    => '12345678901',
        file    => 'bar.png',
        type    => 'UPCA', # default
        format  => 'png',  # default
        no_text => 0,      # default
        height  => 50,     # default
    },

    # set config with a sub
    plug_barcode => sub {
        my ( $t, $q, $config ) = @_;
    }

B<Mandatory>. Specifies plugin's options. Takes a hashref or a subref as a value. If subref is
specified,
its return value will be assigned to C<plug_barcode> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Possible keys/values of the hashref
are as follows:

C<code>

    plug_barcode => {
        code    => '12345678901',
    },

    # or

    plug_barcode => {
        code    => sub {
            my ( $t, $q, $config ) = @_;
            return '12345678901';
        }
    },

B<Mandatory>. Takes either a string or a subref as a value. If the value is a subref,
it will be called and its value will be assigned to C<code> as if it was already there.
The C<@_> of the subref will contain (in this order): ZofCMS Template hashref, query
parameters hashref and L<App::ZofCMS::Config> object.

Specifies the code for the barcode to generate. Valid values depend
on the C<type> of the barcode you're generating. If value is an invalid barcode, plugin
will error out (see C<ERROR HANDLING> section below). If value is either C<undef>
or an empty string, plugin will stop further processing (no exit()s)

C<file>

    plug_barcode => {
        code    => '12345678901',
        file    => 'bar.png',
    },

B<Optional>. Takes a string that represents the name of the file (relative to C<index.pl>)
into which to save the image. When is not defined (or set to an empty string) the plugin
will print out the right C<Content-type> header and output the image right into the browser
B<and then will call exit() UNLESS an error occured> . Plugin will B<NOT> call C<exit()> if
saving to the file. B<By default> is not specified (output barcode image directly to the
browser).

C<type>

    plug_barcode => {
        code    => '12345678901',
        type    => 'UPCA',
    },

    # or
    plug_barcode => {
        code    => '12345678901',
        type    => sub {
            my ( $t, $q, $config ) = @_;
            return 'UPCA';
        },
    },

B<Optional>. Takes a string or a subref as a value. If the value is a subref,
it will be called and its value will be assigned to C<type> as if it was already there.
The C<@_> of the subref will contain (in this order): ZofCMS Template hashref, query
parameters hashref and L<App::ZofCMS::Config> object.

Represents the type of barcode to generate.
See L<GD::Barcode> distribution for possible types. B<As of this writing> these are currently
available types:

    COOP2of5
    Code39
    EAN13
    EAN8
    IATA2of5
    ITF
    Industrial2of5
    Matrix2of5
    NW7
    QRcode
    UPCA
    UPCE

If value is either C<undef> or an empty string, plugin will stop further processing (no exit()s)
B<Defaults to:> C<UPCA>

C<format>

    plug_barcode => {
        code    => '12345678901',
        format  => 'png',
    },

B<Optional>. Can be set to either string C<png> or C<gif> (case sensitive).
Specifies the format of the image to generate (C<png> is for PNG images and C<gif> is for GIF
images). B<Defaults to:> C<png>

C<no_text>

    plug_barcode => {
        code    => '12345678901',
        no_text => 0,
    },

B<Optional>. Takes either true or false values. When set to a true value, the plugin
will not generate text (i.e. it will only make the barcode lines) in the output image.
B<Defaults to:> C<0>

C<height>

    plug_barcode => {
        code    => '12345678901',
        height  => 50,
    },

B<Optional>. Takes positive integer numbers as a value. Specifies the height of the
generated barcode image. B<Defaults to:> C<50>

ERROR HANDLING

    <tmpl_if name='plug_barcode_error'>
        <p>Error: <tmpl_var escape='html' name='plug_barcode_error'></p>
    </tmpl_if>

In an error occurs while generating the barcode (i.e. wrong code length was specified
or some I/O error occured if saving to a file), the plugin will set
the C<< $t->{t}{plug_barcode_error} >> (where C<$t> is ZofCMS Template hashref)
to the error message.

SEE ALSO

L<GD::Barcode>


=head1 App::ZofCMS::Plugin::Base (version 0.0106)

NAME


Link: L<App::ZofCMS::Plugin::Base>



App::ZofCMS::Plugin::Base - base class for App::ZofCMS plugins

SYNOPSIS

    package App::ZofCMS::Plugin::Example;

    use strict;
    use warnings;
    use base 'App::ZofCMS::Plugin::Base';

    sub _key { 'plug_example' }
    sub _defaults {
        qw/foo bar baz beer/
    }
    sub _do {
        my ( $self, $conf, $t, $q, $config ) = @_;
    }

DESCRIPTION

The module is a base class for L<App::ZofCMS> plugins. I'll safely assume that you've
already read the docs for L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

The base class (currently) is only for plugins who take their "config" as a single
first-level key in either Main Config File or ZofCMS Template. That key's value
must be a hashref or a subref that returns a hashref or C<undef>.

SUBS TO OVERRIDE

C<_key>

    sub _key { 'plug_example' }

The C<_key> needs to return a scalar contain the name of first level key in ZofCMS template
or Main Config file. Study the source code of this module to find out what it's used for
if it's still unclear. The value of that key can be either a hashref or a subref that returns
a hashref or undef. If the value is a subref, its return value will be assigned to the key
and its C<@_> will contain (in that order): C<$t, $q, $conf> where C<$t> is ZofCMS Template
hashref, C<$q> is hashref of query parameters and C<$conf> is L<App::ZofCMS::Config> object.

C<_defaults>

    sub _defaults { qw/foo bar baz beer/ }

The C<_defaults> sub needs to return a list of default arguments in a key/value pairs.
By default it returns an empty list.

C<_do>

    sub _do {
        my ( $self, $conf, $template, $query, $config ) = @_;
    }

The C<_do> sub is where you'd do all of your processing. The C<@_> will contain
C<$self, $conf, $template, $query and $config> (in that order) where C<$self> is your
plugin's object, C<$conf> is the plugin's configuration hashref (what the user would specify
in ZofCMS Template or Main Config File, the key of which is returned by C<_key()> sub), the
C<$template> is the hashref of ZofCMS template that is being processed, the C<$query>
is a query parameters hashref where keys are names of the params and values are their values.
Finally, the C<$config> is L<App::ZofCMS::Config> object.

MOAR!

Feel free to email me the requests for extra functionality for this base class.

DOCUMENTATION FOR PLUGINS

Below is a "template" documentation. If you're going to use it, make sure to read
through the entire thing as some things may not apply to your plugin; I've added those
bits as they are very common in the plugins that I write, some of them (but not all)
I marked with word C<[EDIT]>

    =head1 DESCRIPTION

    The module is a plugin for L<App::ZofCMS> that provides means to [EDIT].

    This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

    =head1 FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

    =head2 C<plugins>

        plugins => [
            { [EDIT] => 2000 },
        ],

    B<Mandatory>. You need to include the plugin in the list of plugins to execute.

    =head2 C<[EDIT]>

        [EDIT] => {
        },

        # or
        [EDIT] => sub {
            my ( $t, $q, $config ) = @_;
        },

    B<Mandatory>. Takes either a hashref or a subref as a value. If subref is specified,
    its return value will be assigned to C<[EDIT]> as if it was already there. If sub returns
    an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
    contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
    L<App::ZofCMS::Config> object. [EDIT]. Possible keys/values for the hashref
    are as follows:

    =head3 C<cell>

        [EDIT] => {
            cell => 't',
        },

    B<Optional>. Specifies ZofCMS Template first-level key where to [EDIT]. Must be
    pointing to either a hashref or an C<undef> (see C<key> below). B<Defaults to:> C<t>

    =head3 C<key>

        [EDIT] => {
            key => '[EDIT]',
        },

    B<Optional>. Specifies ZofCMS Template second-level key where to [EDIT]. This key will
    be inside C<cell> (see above)>. B<Defaults to:> C<[EDIT]>


=head1 App::ZofCMS::Plugin::BasicLWP (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::BasicLWP>



App::ZofCMS::Plugin::BasicLWP - very basic "uri-to-content" style LWP plugin for ZofCMS.

SYNOPSIS

In your ZofCMS Template or Main Config File:

    plugins => [ qw/BasicLWP/ ],
    plug_basic_lwp => {
        t_key   => 't',
        uri     => 'http://zofdesign.com/'
    },

In your L<HTML::Template> template:

    <div id="funky_iframe">
        <tmpl_if name='plug_basic_lwp_error'>
            <p>Error fetching content: <tmpl_var name='plug_basic_lwp_error'></p>
        <tmpl_else>
            <tmpl_var name='plug_basic_lwp'>
        </tmpl_if>
    </div>

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides basic functionality to fetch a random
URI with L<LWP::UserAgent> and stick the content into ZofCMS Template hashref.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/BasicLWP/ ],

You need to add the plugin to the list of plugins to execute. Since you are likely to work
on the fetched data, make sure to set correct priorities.

C<plug_basic_lwp>

    plug_basic_lwp => {
        uri     => 'http://zofdesign.com/', # everything but 'uri' is optional
        t_name  => 'plug_basic_lwp',
        t_key   => 'd',
        decoded => 0,
        fix_uri => 0,
        ua_args => [
            agent   => 'Opera 9.2',
            timeout => 30,
        ],
    }

The plugin won't run unless C<plug_basic_lwp> first-level key is present either in Main
Config File or ZofCMS Template. Takes a hashref or a subref as a value. If subref is
specified,
its return value will be assigned to C<plug_basic_lwp> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. If the same keys are specified
in both Main Config File and ZofCMS Template, then the value set in ZofCMS template will
take precedence. The possible keys/values of that hashref are as follows:

C<uri>

    uri => 'http://zofdesign.com/',

    uri => sub {
        my ( $template, $query, $config ) = @_;
        return $query->{uri_to_fetch};
    }

    uri => URI->new('http://zofdesign.com/');

B<Mandatory>. Takes a string, subref or L<URI> object as a value. Specifies the URI to fetch.
When value is a subref that subref will be executed and its return value will be given to
C<uri> argument. Subref's C<@_> will contain the following (in that order): ZofCMS Template hashref, hashref of query parameters and L<App::ZofCMS::Config> object. B<Plugin will stop>
if the C<uri> is undefined; that also means that you can return an C<undef> from your subref
to stop processing.

C<t_name>

    t_name => 'plug_basic_lwp',

B<Optional>. See also C<t_key> parameter below.
Takes a string as a value. This string represents the name of the key in
ZofCMS Template where to put the fetched content (or error). B<Note:> the errors will
be indicated by C<$t_name . '_error'> L<HTML::Template> variable, where C<$t_name> is the value
of C<t_name> argument.
See SYNOPSYS for examples. B<Defaults to:> C<plug_basic_lwp> (and
the errors will be in C<plug_basic_lwp_error>

C<t_key>

    t_key => 'd',

B<Optional>. Takes a string as a value. Specifies the name of B<first-level> key in ZofCMS
Template hashref in which to create the C<t_name> key (see above). B<Defaults to:> C<d>

C<decoded>

    decoded => 0,

B<Optional>. Takes either true or false values as a value. When set to a I<true> value,
the content will be given us with C<decoded_content()>. When set to a I<false> value, the
content will be given us with C<content()> method. See L<HTTP::Response> for description
of those two methods. B<Defaults to:> C<0> (use C<content()>)

C<fix_uri>

    fix_uri => 0,

B<Optional>. Takes either true or false values as a value. When set to a true value, the
plugin will try to "fix" URIs that would cause LWP to crap out with "URI must be absolute"
errors. When set to a false value, will attempt to fetch the URI as it is. B<Defaults to:>
C<0> (fixing is disabled)

B<Note:> the "fixer" is not that smart, here's the code; feel free not to use it :)

    $uri = "http://$uri"
        unless $uri =~ m{^(ht|f)tp://}i;

C<ua_args>

    ua_args => [
        agent   => 'Opera 9.2',
        timeout => 30,
    ],

B<Optional>. Takes an arrayref as a value. This arrayref will be directly dereference into
L<LWP::UserAgent> contructor. See L<LWP::UserAgent>'s documentation for possible values.
B<Defaults to:>

    [
        agent   => 'Opera 9.2',
        timeout => 30,
    ],

HTML::Template VARIABLES

The code below assumes default values for C<t_name> and C<t_key> arguments (see C<plug_basic_lwp> hashref keys' description).

    <tmpl_if name='plug_basic_lwp_error'>
        <p>Error fetching content: <tmpl_var name='plug_basic_lwp_error'></p>
    <tmpl_else>
        <tmpl_var name='plug_basic_lwp'>
    </tmpl_if>


=head1 App::ZofCMS::Plugin::BoolSettingsManager (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::BoolSettingsManager>



App::ZofCMS::Plugin::BoolSettingsManager - Plugin to let individual users manage boolean settings

SYNOPSIS

In L<HTML::Template> template:

    <tmpl_var name='plug_bool_settings_manager_form'>

In ZofCMS Template:

    plugins => [
        qw/BoolSettingsManager/,
    ],

    plug_bool_settings_manager => {
        settings => [
            notice_forum         => q|new forum posts|,
            notice_flyers        => q|new flyer uploads|,
            notice_photo_library => q|new images added to Photo Library|,
        ],

        # everything below is optional; default values are shown
        dsn           => "DBI:mysql:database=test;host=localhost",
        user          => '',
        pass          => undef,
        opt           => { RaiseError => 1, AutoCommit => 1 },
        table         => 'users',
        login_col     => 'login',
        login         => sub { $_[0]->{d}{user}{login} },
        submit_button => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to present
a user a form with a number of checkboxes that control boolean settings,
which are stored in a SQL database.

This documentation assumes you've read L<App::ZofCMS>, 
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/BoolSettingsManager/ ],

B<Mandatory>. You need to include the plugin in the list of plugins
to execute.

C<plug_bool_settings_manager>

    plug_bool_settings_manager => {
        settings => [
            notice_forum         => q|new forum posts|,
            notice_flyers        => q|new flyer uploads|,
            notice_photo_library => q|new images added to Photo Library|,
        ],

        # everything below is optional; default values are shown
        dsn           => "DBI:mysql:database=test;host=localhost",
        user          => '',
        pass          => undef,
        opt           => { RaiseError => 1, AutoCommit => 1 },
        table         => 'users',
        login_col     => 'login',
        login         => sub { $_[0]->{d}{user}{login} },
        submit_button => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    },

B<Mandatory>. Takes either a hashref or a subref as a value.
If subref is specified, its return value will be assigned to
C<plug_user_login_forgot_password> key as if it was already there.
If sub returns an C<undef>, then plugin will stop further processing.
The C<@_> of the subref will contain C<$t>, C<$q>, and C<$config>
(in that order), where C<$t> is ZofCMS Template hashref,
C<$q> is query parameters hashref, and C<$config> is the
L<App::ZofCMS::Config> object. Possible keys/values for the hashref
are as follows:

C<settings>

    plug_bool_settings_manager => {
        settings => [
            notice_forum         => q|new forum posts|,
            notice_flyers        => q|new flyer uploads|,
            notice_photo_library => q|new images added to Photo Library|,
        ],
    ...

    plug_bool_settings_manager => {
        settings => sub {
            my ( $t, $q, $config ) = @_;
            return $arrayref_to_assing_to_settings;
        },
    ...

B<Mandatory>. Takes an arrayref or a subref as a value. If subref is 
specified, its return value must be either an arrayref or 
C<undef> (or empty list). The C<@_> of the subref will contain C<$t>, 
C<$q>, and C<$config> (in that order), where C<$t> is ZofCMS Template 
hashref, C<$q> is query parameters hashref, and C<$config> is the
L<App::ZofCMS::Config> object.

If C<settings> is not specified, or its arrayref is empty, or if the subref 
returns C<undef>, empty arrayref or empty list, plugin will stop further
execution.

The arrayref must have an even number of elements that are to be thought
of as keys and values (the arrayref is used to preserve order). The "keys"
of the arrayref represent boolean column names in C<table> (see below)
SQL table in which users' settings are stored (one setting per column).
The keys will also be used as parts of C<id=""> attributes in the form, thus
they need to also conform to HTML spec (L<http://xrl.us/bicips>)
(or whatever your markup language of choice is).

The "values" must be strings that represent the human readable description
of their corresponding "keys". These will be shown as text in the C<< 
<label> >>s for corresponding checkboxes.

C<dsn>

    plug_bool_settings_manager => {
        dsn => "DBI:mysql:database=test;host=localhost",
    ...

B<Optional, but the default is pretty useless>.
The C<dsn> key will be passed to L<DBI>'s
C<connect_cached()> method, see documentation for L<DBI> and
C<DBD::your_database> for the correct syntax for this one.
The example above uses MySQL database called C<test> which is
located on C<localhost>.
B<Defaults to:> C<"DBI:mysql:database=test;host=localhost">

C<user>

    plug_bool_settings_manager => {
        user => '',
    ...

B<Optional>. Specifies the user name (login) for the database. This can be 
an empty string if, for example, you are connecting using SQLite 
driver. B<Defaults to:> C<''> (empty string)

C<pass>

    plug_bool_settings_manager => {
        pass => undef,
    ...

B<Optional>. Same as C<user> except specifies the password for the
database. B<Defaults to:> C<undef> (no password)

C<opt>

    plug_bool_settings_manager => {
        opt => { RaiseError => 1, AutoCommit => 1 },
    ...

B<Optional>. Will be passed directly to L<DBI>'s C<connect_cached()> method
as "options". B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 } >>

C<table>

    plug_bool_settings_manager => {
        table => 'users',
    ...

B<Optional>. Takes a string as a value that specifies the name of the
table in which users' logins and their settings are stored.
B<Defaults to:> C<users>

C<login_col>

    plug_bool_settings_manager => {
        login_col => 'login',
    ...

B<Optional>. Takes a string as a value that specifies the name of the
column in C<table> table that contains users' logins.
B<Defaults to:> C<login>

C<login>

    plug_bool_settings_manager => {
        login => sub {
            my ( $t, $q, $config ) = @_;
            return $t->{d}{user}{login};
        },
    ...

    plug_bool_settings_manager => {
        login => 'zoffix',
    ...

B<Optional>. Takes an C<undef>, a subref or a scalar as a value.
Specifies the login of a current user. This is the value located in the
C<login_col> (see above) column. This will be used to look up/store the
settings. If a subref is specified, its return value must be either an
C<undef> or a scalar, which will be assigned to C<login> as if it was
already there. If C<login> is set to C<undef> (or the sub returns an
C<undef>/empty list), then plugin will stop further execution. The C<@_> of
the subref will contain C<$t>, C<$q>, and C<$config> (in that order), where
C<$t> is ZofCMS Template hashref, C<$q> is query parameters hashref, and
C<$config> is the L<App::ZofCMS::Config> object. B<Defaults to:>
C<< sub { $_[0]->{d}{user}{login} } >>

C<submit_button>

    plug_bool_settings_manager => {
        submit_button => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    ...

B<Optional>. Takes HTML code as a value, which represents the submit
button to be used on the settings-changing form. Feel free to throw in
any extra code into this argument. B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Save"> >>

HTML::Template TEMPLATE VARIABLE

All of plugin's output is spit out into a single variable in your
L<HTML::Template> template:

    <tmpl_var name='plug_bool_settings_manager_form'>

HTML CODE GENERATED BY THE PLUGIN

The HTML code below was generated after saving settings in the form
generated using this plugin's C<settings> argument:

    settings => [
        notice_forum         => q|new forum posts|,
        notice_flyers        => q|new flyer uploads|,
        notice_photo_library => q|new images added to Photo Library|,
    ],

Notice the "keys" in the C<settings> arrayref are used to generate
C<id=""> attributes on the C<< <li> >> and C<< <input> >> elements
(and C<for=""> attribute on C<< <label> >>s). The value for C<page>
hidden C<< <input> >> is derived by the plugin automagically.

    <p class="success-message">Successfully saved</p>

    <form action="" method="POST" id="plug_bool_settings_manager_form">
    <div>
        <input type="hidden" name="page" value="/index">
        <input type="hidden" name="pbsm_save_settings" value="1">

        <ul>
            <li id="pbsm_container_notice_forum">
                <input type="checkbox"
                    id="pbsm_notice_forum"
                    name="notice_forum"
                ><label for="pbsm_notice_forum"
                    class="checkbox_label"> new forum posts</label>
            </li>
            <li id="pbsm_container_notice_flyers">
                <input type="checkbox"
                    id="pbsm_notice_flyers"
                    name="notice_flyers"
                ><label for="pbsm_notice_flyers"
                    class="checkbox_label"> new flyer uploads</label>
            </li>
            <li id="pbsm_container_notice_photo_library">
                <input type="checkbox"
                    id="pbsm_notice_photo_library"
                    name="notice_photo_library"
                    checked
                ><label for="pbsm_notice_photo_library"
                    class="checkbox_label"> new images added to Photo Library</label>
            </li>
        </ul>
        <input type="submit" class="input_submit" value="Save">
    </div>
    </form>

The C<< <p class="success-message">Successfully saved</p> >> paragraph
is only shown when user saves their settings.

REQUIRED MODULES

Plugin requires the following modules to survive:

    App::ZofCMS::Plugin::Base => 0.0106,
    HTML::Template            => 2.9,
    DBI                       => 1.607,


=head1 App::ZofCMS::Plugin::BreadCrumbs (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::BreadCrumbs>



App::ZofCMS::Plugin::BreadCrumbs - add "breadcrumbs" navigation to your sites

SYNOPSIS

In your ZofCMS template:

    plugins => [ qw/BreadCrumbs/ ]

In your L<HTML::Template> template:

    <tmpl_var name="breadcrumbs">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to add
a "breadcrumbs" (L<http://en.wikipedia.org/wiki/Breadcrumb_(navigation)>)
to your pages.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

HOW DOES IT WORK

The plugin automagically generates breadcrumb links, if your sites are
relatively simple and pages are in good hierarchy the plugin will do
the Right Thing(tm) most of the time. The links for breadcrumbs are
determined as follows. If the page is not called C<index> then the
C<index> page in the current "directory" will be added to the breadcrumbs,
the "path" will be broken down to pieces and C<index> page in each piece
will be added to the breadcrumbs. B<Note:> the examples below assume
that the C<no_pages> argument was not specified:

    # page
    index.pl?page=/foo/bar/baz

    # crumbs
    /index => /foo/index => /foo/bar/index => /foo/bar/baz


    # page
    index.pl?page=/foo/bar/beer/index

    # crumbs
    /index => /foo/index/ => /foo/bar/index => /foo/bar/beer/index

FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    plugins => [ qw/BreadCrumbs/ ]

First and obvious you need to add C<BreadCrumbs> to the list of plugins
to execute. Just this will already make the plugin execute, i.e. having
the C<breadcrumbs> key (see below) is not necessary.

C<breadcrumbs>

    breadcrumbs => {}, # disable the plugin

    # lots of options
    breadcrumbs => {
        direct      => 1,
        span        => 1,
        no_pages => [ '/comments' ],
        key         => 'page_title',
        text_re     => qr/([^-]+)/,
        change      => {
            qr/foo/ => 'foos',
            qr/bar/ => 'bars',
        },
        replace     => {
            qr/foo/ => 'foos',
            qr/bar/ => 'bars',
        },
    },

The C<breadcrumbs> first-level ZofCMS template key controls the behaviour
of the plugin. Can be specified as the first-level key in Main Config File, but unlike many
other plugins the hashref keys do NOT merge; i.e. if you set the key in both files, the value
in ZofCMS Template will take precedence. The key takes a hashref as a value.
Do B<NOT> specify this key if you wish to use all the
defaults, as specifying an I<empty hashref> as a value will B<disable> the
plugin for that given page. Possible keys/values of that hashref are as
follows:

C<direct>

    { direct => 1 },

B<Optional>. Takes either true or false values. When set to a B<false> value
the breadcrumb links will all be of form C</index.pl?page=/index>. When
set to a B<true> value the links will be of form C</index> which is
useful when you are making your URIs with something like C<mod_rewrite>.
B<Defaults to:> false

C<span>

    { span => 1 },

B<Optional>. The C<span> key takes either true
or false values. When set to a true value, the plugin will
generate C<< <span> >> based breadcrumbs. When set to a false value, the
plugin will generate C<< <ul> >> based breadcrumbs. B<Default to:> false.

C<no_pages>

    { no_pages => [ '/comments', '/index' ], }

B<Optional>. Takes an arrayref as a value. Each element of that array
must be a C<dir> + C<page> (as described in I<Note on page and dir query
parameters> in L<App::ZofCMS::Config>). If a certain element of that
array matches the page in the breadcrumbs being generated it will be
removed from the breadcrumbs. In other words, if you specify
C<< no_pages => [ '/index' ] >> the "index" page of the "root"
directory will not show up in the breadcrumbs. B<By default> is not
specified.

C<key>

    { key => 'title', }

B<Optional>. When walking up the "tree" of pages plugin will open ZofCMS
templates for those pages and use the C<key> key's value as the text
for the link. Only first-level keys are supported. B<Defaults to:>
C<title>

C<text_re>

    { text_re => qr/([^-]+)/ }

B<Optional>. Takes a regex (C<qr//>) as a value which must contain
a capturing set of parentheses. When specified will run the regex on the
value of C<key> (see above) key's value and whatever was captured in the
capturing parentheses will be used for the text of the link. B<By default>
is not specified.

C<change>

    change => {
        qr/foo/ => 'foos',
        qr/bar/ => 'bars',
    },

B<Optional>. Takes a hashref as a value. The keys of that hashref are
regexen (C<qr//>) and the values are the text with which the B<entire>
text of the link will be replaced if that particular regex matches. In other
words, if you specify C<< change => { qr/foo/ => 'foo' } >> and your
link text is C<lots and lots of foos> it will turn into just C<foo>.
B<By default> is not specified.

C<replace>

    replace => {
        qr/foo/ => 'foos',
        qr/bar/ => 'bars',
    },

B<Optional>. Same as C<change> key described above, except C<replace> will
B<replace the matching part> with the text provided as a value. In other
words, if you specify C<< replace => { qr/foo/ => 'BAR' } >> and your
link text is C<lots and lots of foos> it will turn into
C<lots and lots of BARs>. B<By default> is not specified.

HTML::Template TEMPLATE VARIABLES

    <tmpl_var name="breadcrumbs">

The plugin set one key - C<breadcrumbs> - in C<{t}> special key which
means that you can stick C<< <tmpl_var name="breadcrumbs"> >> in any
of your L<HTML::Template> templates and this is where the breadcrumbs
will be placed.


=head1 App::ZofCMS::Plugin::Captcha (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Captcha>



App::ZofCMS::Plugin::Captcha - plugin to utilize security images (captchas)

SYNOPSIS

    plugins => [
        { Session => 1000 },
        { Captcha => 2000 },
    ],
    plugins2 => [
        qw/Session/
    ],

    plug_captcha => {},

    # Session plugin configuration (i.e. database connection is left out for brevity)

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to generate and display
security images, known as "captchas" (i.e. protecting forms from bots).

The plugin was coded with idea that you will be using L<App::ZofCMS::Plugin::Session>
along with it to store the generated random string; however, it's not painfully
necessary to use Session plugin (just easier with it).

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        { Session => 1000 },
        { Captcha => 2000 },
    ],
    plugins2 => [
        qw/Session/
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute. I'm using
Session plugin here to first load existing session and after Captcha is ran, to save
the session.

C<plug_captcha>

    # all defaults
    plug_captcha => {},

    # set all arguments
    plug_captcha => {
        string  => 'Zoffix Znet Roxors',
        file    => 'captcha.gif',
        width   => 80,
        height  => 20,
        lines   => 5,
        particle => 0,
        no_exit => 1,
        style   => 'rect',
        format  => 'gif',
        tcolor  => '#895533',
        lcolor  => '#000000',
    },

    # or set some via a subref
    plug_captcha => sub {
        my ( $t, $q, $config ) = @_;
        return {
            string  => 'Zoffix Znet Roxors',
            file    => 'captcha.gif',
        }
    },

B<Mandatory>. Takes either a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_captcha> as if it was already there. If
sub returns an C<undef>, then plugin will stop further processing.
The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run the plugin with all the defaults,
use an empty hashref. Possible keys/values for the hashref
are as follows:

C<string>

    plug_captcha => {
        string  => 'Zoffix Znet Roxors',
    },

B<Optional>. Specifies the captcha string. Takes either a scalar string or C<undef>.
If set to C<undef>, the plugin will generate a random numeric string. B<Defaults to:>
C<undef>.

C<file>

    plug_captcha => {
        file    => 'captcha.gif',
    },

B<Optional>. Takes either a scalar string or C<undef> as a value. If set to a string,
it represents the name of the file into which to save the captcha image (relative to
C<index.pl>). If set to C<undef>, plugin will output correct HTTP headers and the image
directly into the browser. B<Defaults to:> C<undef>.

C<no_exit>

    plug_captcha => {
        no_exit => 1,
    },

B<Optional>. This one is relevant only when C<file> (see above) is set to C<undef>.
Takes either true or false values. If set to a B<false value>, plugin will call
C<exit()> as soon as it finishes outputting the image to the browser. You'd use it
if you're generating your own string and are able to store it with the Session plugin
before Captcha plugin runs. If set to a B<true value>, plugin will not call C<exit()> and
the runcycle will continue; this way the Captcha plugin generated random string can
be stored by Session plugin later in the runlevel. B<Note:> that in this case, after the
image is printed the browser will also send some garbage (and by that I mean the
standard HTTP Content-type headers that ZofCMS prints along with whatever may be in
your template); even though I haven't noticed that causing any problems with the image,
if it does cause broken image for you, simply use L<App::ZofCMS::Plugin::Sub> and call
C<exit()> within it. B<Defaults to:> C<1>

C<width>

    plug_captcha => {
        width   => 80,
    },

B<Optional>. Takes a pisitive integer as a value. Specifies captcha image's width in pixels.
B<Defaults to:> C<80>

C<height>

    plug_captcha => {
        height  => 20,
    },

B<Optional>. Takes a pisitive integer as a value. Specifies captcha image's height in
pixels.B<Defaults to:> C<20>

C<lines>

    plug_captcha => {
        lines   => 5,
    },

B<Optional>. Specifies the number of crypto-lines to generate. See L<GD::SecurityImage> for
more details. B<Defaults to:> C<5>

C<particle>

    plug_captcha => {
        particle => 0, # disable particles
    },

    plug_captcha => {
        particle => 1, # let plugin decide the right amount
    },

    plug_captcha => {
        particle => [40, 50], # set amount yourself
    },

B<Optional>. Takes either false values, true values or an arrayref as a value. When set to an
arrayref, the first element of it is density and the second one is maximum
number of dots to generate - these dots will add more cryptocrap to your captcha. See
C<particle()> method in L<GD::SecurityImage> for more details. When set to a true value
that is not an arrayref, L<GD::SecurityImage> will try to determine optimal number of
particles. When set to a false value, no extra particles will be created.
B<Defaults to:> C<0>

C<style>

    plug_captcha => {
        style   => 'rect',
    },

B<Optional>. Specifies the cryptocrap style of captcha.
See L<GD::SecurityImage> C<create()> method for possible styles.
B<Defaults to:> C<rect>

C<format>

    plug_captcha => {
        format  => 'gif',
    },

B<Optional>. Takes string C<gif>, C<jpeg> or C<png> as a value. Specifies the format
of the captcha image. Some formats may be unavailable depending on your L<GD> version.
B<Defaults to:> C<gif>

C<tcolor>

    plug_captcha => {
        tcolor  => '#895533',
        lcolor  => '#000000',
    },

B<Optional>. Takes 6-digit hex RGB notation as a value. Specifies the color
of the text (and particles if they are on). B<Defaults to:> C<#895533>

C<lcolor>

    plug_captcha => {
        lcolor  => '#000000',
    },

B<Optional>. Takes 6-digit hex RGB notation as a value. Specifies the color
of cryptocrap lines. B<Defaults to:> C<#000000>

OUTPUT

    $t->{d}{session}{captcha} = 'random_number';

    $t->{t}{plug_captcha_error} = 'error message';

Plugin will put the captcha string into C<< $t->{d}{session}{captcha} >> where
C<$t> is ZofCMS Template hashref. Currently there is no way to change that.

If you're saving captcha to a file, possible I/O error message will be put into
C<< $t->{t}{plug_captcha_error} >> where C<$t> is ZofCMS Template hashref.


=head1 App::ZofCMS::Plugin::Comments (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Comments>



App::ZofCMS::Plugin::Comments - drop-in visitor comments support.

SYNOPSIS

In your "main config" file:

    comments_plugin => {
        dsn         => "DBI:mysql:database=test;host=localhost",
        user        => 'test',
        pass        => 'test',
        email_to    => [ 'admin@example.com', 'admin2@example.com' ],
    },

In your ZofCMS template:

    plugins => [ qw/Comments/ ],

In your "comments" page L<HTML::Template> template, which we set to be C</comments> by default:

    <tmpl_var name="zofcms_comments_form">

In any page on which you wish to have comments:

    <tmpl_var name="zofcms_comments_form">
    <tmpl_var name="zofcms_comments">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to easily add
"visitor comments" to your pages. The plugin offers configurable
flood protection ( $x comments per $y seconds ) as well as ability to
notify you of new comments via e-mail. The "moderation" function is also
implemented, what that means is that you (the admin) would get two links
(via e-mail) following one of them will approve the comment; following the
other will simply delete the comment from the database.

I am an utterly lazy person, thus you may find that not everything you
may want to configure in the plugin is configurable. The plugin is
yet to undergo (at the time of this writing) deployment testing, as in
how flexible it is. If you'd like to see some features added, don't be shy
to drop me a line to C<zoffix@cpan.org> 

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

HOW IT ALL COMES TOGETHER OR "WHAT'S THAT 'comments' PAGE ANYWAY?"

So here is how it works, you have some page where you added the plugin's
functionality. Visitor enters his/hers comment and pressed "Post" button.
The request will be POSTed to a "comments" page and depending on what
the visitor entered he or she will either get an error with ability to
fix it or a "success" message with an ability to go back to the page
on which the comment was created. The reason for this "comments" page is
that I couldn't figure out a simple way to have the comments markup inserted
with simple C<< <tmpl_var> >> and keep any page on which the plugin
was used small enough for the user to see the error message easily.

The "comments" must have <tmpl_var name="zofcms_comments_form"> on
it somewhere for the plugin to work.

MAIN CONFIG OR ZofCMS TEMPLATES?

If you have a sharp eye, you've noticed that plugin's configuration was
placed into the 'main config file' in the SYNOPSIS. You actually B<don't
have to>
do that and can keep plugin's configuration in your ZofCMS template,
but personally I find it much easier to just drop it into the main config
and enable it on per-page basis by sticking only C<Comments> in the list
of the plugins on ZofCMS templates.

THE SQL TABLES!

Under the hood the plugin uses L<DBI> to stick data into SQL tables.
Generally speaking you shouldn't have trouble using the plugin with
$database_of_your_choice; however, the plugin was tested only with MySQL
database. B<Before you can use the plugin you need to create one or
two tables in your database>. The columns B<have to> be named those names
and be in that order:

    # comments table
    CREATE TABLE comments (name VARCHAR(100), email VARCHAR(200), comment TEXT, page VARCHAR(100), remote_host TEXT, time VARCHAR(11));

    #moderation table
    CREATE TABLE mod_comments (name VARCHAR(100), email VARCHAR(200), comment TEXT, page VARCHAR(100), remote_host TEXT, time VARCHAR(11), id TEXT);

Now, the note on value types. The C<name>, C<email> and C<comment> is the
data that the comment poster posts. Since the maximum lengths of those
fields are configurable, pick the value types you think fit. The C<page>
column will contain the "page" on which the comment was posted. In other
words, if the comment was posted on
C<http://example.com/?page=/foo/bar/baz>, the C<page> cell will contain
C</foo/bar/baz>. The C<remote_host> is obtained from
L<CGI>'s C<remote_host()> method. The C<time> cell is obtained from
the call to C<time()> and the C<id> in moderation table is generated with
C<< rand() . time() . rand() >> (keep those flames away plz).

COMMENT MODERATION

When moderation of comments is turned on in the plugin you will get
two links e-mailed when a new comment was submitted. One is "approve"
and another one is "deny". Functions of each are self explanatory. What
happens is that the comment is first placed in the "moderation table". If
you click "approve", the comment is moved into the "comments table". If
the comment is denied by you, it is simply deleted from the
"moderation table". There is a feature that allows all comments that
are older than $x seconds (see C<mod_out_time> argument) to be deleted
from the "moderation table" automatically.

WHAT? NO CAPTCHA?

You will notice that there is no "captcha"
(L<http://en.wikipedia.org/wiki/Captcha>) thing done with comments form
generated by the plugin. The reason for that is that I hate them... pure
hate. I think the worst captcha I ever came across was this:
L<http://www.zoffix.com/new/captcha-wtf.png>. But most of all, I think
they are plain annoying.

In this plugin I implemented a non-annoying "captcha" mechanizm suggested
by one of the people I know who claimed it works very well. At the time
of this writing I am not yet aware of how "well" it really is. Basically,
the plugin sticks C<< <input type="hidden" name="zofcms_comments_username" value="your user name"> >> in the form. When checking the parameters,
the plugin checks that this hidden input's value matches. If it doesn't,
boot the request. Apparently the technique works much better when the
C<< <input> >> is not of C<type="hidden"> but I am very against "hiding"
something with CSS.

So, time will show, if this technique proves to be a failure, expect
the plugin to have an option to provide a better "captcha" mechanizm. As for
now, this is all you get, although, I am open for good ideas.

GOODIES IN ZofCMS TEMPLATE/MAIN CONFIG FILE

C<plugins>

    plugins => [ qw/Comments/ ],

This goes without saying that you'd need to stick 'Comments' into the list
of plugins used in ZofCMS template. As opposed to many other plugins
this plugin will not bail out of the execution right away if
C<comments_plugin> first level key (described below) is not specified in
the template (however it will if you didn't specify C<comments_plugin> in
neither the ZofCMS template nor the main config file).

C<comments_plugin>

    comments_plugin => {
        # mandatory
        dsn             => "DBI:mysql:database=test;host=localhost",
        page            => '/comments',

        #optional in some cases, no defaults
        email_to        => [ 'admin@test.com', 'admin2@test.com' ],

        #optional, but default not specified
        user            => 'test', # user,
        pass            => 'test', # pass
        opts            => { RaiseError => 1, AutoCommit => 1 },
        uri             => 'http://yoursite.com',
        mailer          => 'testfile',
        no_pages        => [ qw(/foo /bar/beer /baz/beer/meer) ],

        # optional, defaults presented here
        sort            => 0
        table           => 'comments',
        mod_table       => 'mod_comments',
        must_name       => 0,
        must_email      => 0,
        must_comment    => 1,
        name_max        => 100,
        email_max       => 200,
        comment_max     => 10000,
        moderate        => 1,
        send_entered    => 1,
        subject         => 'ZofCMS Comments',
        flood_num       => 2,
        flood_time      => 180,
        mod_out_time    => 1209600,
    }

Whoosh, now that's a list of options! Luckly, most of them have defaults.
I'll go over them in a second. Just want to point out that all these
arguments can be set in the "main config file" same way you'd set them
in ZofCMS template (the first-level C<comments_plugin> key). In fact,
I recommend you set them all in ZofCMS main config file instead of ZofCMS
templates, primarily because you'd
want to have it duplicated at least twice: once on the "comments page"
and once on the page on which you actually want to have visitors' comments
functionality. So here are the possible arguments:

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Takes a scalar as a value which must contain a valid
"$data_source" as explained in L<DBI>'s C<connect_cached()> method (which
plugin currently uses).

C<email_to>

    email_to => [ 'admin@test.com', 'admin2@test.com' ],

B<Mandatory unless> C<moderate> B<and> C<send entered> are set to a
false values. Takes either a scalar or an arrayref as a value.
Specifying a scalar is equivalent to specifying an arrayref with just
that scalar in it. When C<moderate> B<or> C<send_entered> are set
to true values, the e-mail will be sent to each of the addresses
specified in the C<email_to> arrayref.

C<page>

    page => '/comments',

B<Optional>. This is the "comments page" that I explained in the
C<HOW IT ALL COMES TOGETHER OR "WHAT'S THAT 'comments' PAGE ANYWAY?">
section above. Argument takes a string as a value. That value is what
you'd set the C<page> query parameter in order to get to the "comments
page". B<Make sure> you also prepend the C<dir>. In the example above
the comments page is accessed via
C<http://example.com/index.pl?page=comments&dir=/>. B<Defaults to:>
C</comments>

C<user>

    user => 'test_db_user',

B<Optional>. Specifies the username to use when connecting to the
SQL database used by the plugin. B<By default> is not specified.

C<pass>

    pass => 'teh_password',

B<Optional>. Specifies the password to use when connecting to the
SQL database used by the plugin. B<By default> is not specified.

C<opts>

    opts => { RaiseError => 1, AutoCommit => 1 },

B<Optional>. Takes a hashref as a value.
Specifies additional options to L<DBI>'s C<connect_cached()>
method, see L<DBI>'s documentation for possible keys/values of this
hashref. B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 } >>

C<uri>

    uri => 'http://yoursite.com/index.pl?page=/comments',

B<Optional>. The only place in which this argument is used is for
generating the "Approve" and "Deny" URIs in the e-mail sent to you when
C<moderate> is set to a true value. Basically, here you would give
the plugin a URI to your "comments page" (see C<page> argument above).
If you don't specify this argument, nothing will explode (hopefully) but
you won't be able to "click" the "Approve"/"Deny" URIs.

C<mailer>

    mailer => 'testfile',

B<Optional>. When either C<moderate> or C<send_entered> arguments are
set to true values, the C<mailer> argument specifies which "mailer" to
use to send e-mails. See documentation for L<Mail::Mailer> for possible
mailers. B<By default> C<mailer> argument is not specified, thus the
"mailers" will be tried until one of them works. When C<mailer> is set
to C<testfile>, the mail file will be located at the same place ZofCMS'
C<index.pl> file is located.

C<no_pages>

    no_pages => [ qw(/foo /bar/beer /baz/beer/meer) ],

B<Optional>. Takes an arrayref as a value. Each element of that arrayref
B<must> be a C<page> with C<dir> appended to it, even if C<dir> is C</>
(see the "Note on page and dir query parameters" in L<App::ZofCMS::Config>
documentation). Basically, any pages listed here will not be processed
by the plugin even if the plugin is listed in C<plugins> first-level
ZofCMS template key. B<By default> is not set.

C<sort>

    sort => 0,

B<Optional>. Currently accepts only true or false values.
When set to a true value
the comments on the page will be listed in the "oldest-first" fashion.
When set to a false value the comments will be reversed - "newest-first"
sorting. B<Defaults to:> C<0>.

C<table>

    table => 'comments',

B<Optional>. Takes a string as a value which must contain the name of
SQL table used for storage of comments. See C<THE SQL TABLES!> section
above for details. B<Defaults to:> C<comments>

C<mod_table>

    mod_table => 'mod_comments',

B<Optional>. Same as C<table> argument (see above) except this one
specifies the name of "moderation table", i.e. the comments awaiting
moderation will be stored in this SQL table. B<Defaults to:>
C<mod_comments>

C<must_name>, C<must_email> and C<must_comment>

    must_name    => 0,
    must_email   => 0,
    must_comment => 1,

B<Optional>. The "post comment" form generated by the plugin contains
the C<Name>, C<E-mail> and C<Comment> fields. The
C<must_name>, C<must_email> and C<must_comment> arguments take either
true or false values. When set to a true value, the visitor must fill
the corresponding field in order to post the comment. If field is
spefied as "optional" (by setting a false value) and the visitor doesn't
fill it, it will default to C<N/A>. B<By default> C<must_name> and
C<must_email> are set to false values and C<must_comment> is set to
a true value.

C<name_max>, C<email_max> and C<comment_max>

    name_max    => 100,
    email_max   => 200,
    comment_max => 10000,

B<Optional>. Same principle as with C<must_*> arguments explained above,
except C<*_max> arguments specify the maximum length of the fields. If
visitor enters more than specified by the corresponding C<*_max> argument,
he or she (hopefully no *it*s) will get an error. B<By default>
C<name_max> is set to C<100>, C<email_max> is set to C<200> and
C<comment_max> is set to C<10000>.

C<moderate>

    moderate => 1,

B<Optional>. Takes either true or false values. When set to a true value
will enable "moderation" functionality. See C<COMMENT MODERATION>
section above
for details. When set to a false value, comments will appear on the
page right away. B<Note:> when set to a true value e-mail will be
automatically sent to C<email_to> addresses. B<Defaults to:> C<1>

C<send_entered>

    send_entered => 1,

B<Optional>. Takes either true or false values, regarded only when
C<moderate> argument is set to a false value. When set to a true value
will dispatch an e-mail about a new comment to the addresses set
in C<email_to> argument. B<Defaults to:> C<1>

C<subject>

    subject => 'ZofCMS Comments',

B<Optional>. Takes a string as a value. Nothing fancy, this will be
the "Subject" of the e-mails sent by the plugin (see C<moderate> and
C<send_entered> arguments). B<Defaults to:> C<'ZofCMS Comments'>

C<flood_num>

    flood_num => 2,

B<Optional>. Takes a positive integer or zero as a value. Indicates how many
comments a visitor may post in C<flood_time> (see below) amount of time.
Setting this value to C<0> effectively B<disables> flood protection.
B<Defaults to:> C<2>

C<flood_time>

    flood_time => 180,

B<Optional>. Takes a positive integer as a value. Specifies the time
I<in seconds> during which the visitor may post only C<flood_num> (see
above) comments. B<Defaults to:> C<180>

C<mod_out_time>

    mod_out_time => 1209600,

B<Optional>. Takes a positive integer or false value as a value. When
set to a positive integer indicates how old (B<in seconds>) the comment
in C<mod_table> must get before it will be automatically removed from
the C<mod_table> (i.e. "denied"). Comments older than C<mod_out_time>
seconds will I<not> actually be deleted until moderation takes place, i.e.
until you approve or deny some comment. Setting this value to C<0>
effectively disables this "auto-delete" feature. B<Defaults to:>
C<1209600> (two weeks)

EXAMPLES

The C<examples/> directory of this distribution contains main config file
and HTML/ZofCMS templates which were used during testing of this plugin.

PREREQUISITES

This plugin requires more goodies than any other ZofCMS plugin to the date.
Plugin needs the following modules for happy operation. Plugin was tested
with module versions indicated:

    'DBI'            => 1.602,
    'URI'            => 1.35,
    'HTML::Template' => 2.9,
    'HTML::Entities' => 1.35,
    'Storable'       => 2.18,
    'Mail::Send'     => 2.04,


=head1 App::ZofCMS::Plugin::ConditionalRedirect (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::ConditionalRedirect>



App::ZofCMS::Plugin::ConditionalRedirect - redirect users based on conditions

SYNOPSIS

In Main Config file or ZofCMS template:

    plugins => [ qw/ConditionalRedirect/ ],
    plug_redirect => sub { time() % 2 ? 'http://google.com/' : undef },

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to redirect user to pages
depending on certain conditions, e.g. some key having a value in ZofCMS Template hashref or
anything else, really.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config>
and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE KEYS

C<plugins>

    plugins => [ qw/ConditionalRedirect/ ],

    plugins => [ { UserLogin => 1000 }, { ConditionalRedirect => 2000 } ],

The obvious is that you'd want to stick this plugin into the list of plugins to be
executed. However, since functionality of this plugin can be easily implemented using
C<exec> and C<exec_before> special keys in ZofCMS Template, being able to set the
I<priority> to when the plugin should be run would probably one of the reasons for you
to use this plugin (it was for me at least).

C<plug_redirect>

    plug_redirect => sub {
        my ( $template_ref, $query_ref, $config_obj ) = @_;
        return $template_ref->{foo} ? 'http://google.com/' : undef;
    }

The C<plug_redirect> first-level key in Main Config file or ZofCMS Template takes a subref
as a value. The sub will be executed and its return value will determine where to redirect
(if at all). Returning C<undef> from this sub will B<NOT> cause any redirects at all. Returning
anything else will be taken as a URL to which to redirect and the plugin will call C<exit()>
after printing the redirect headers.

The C<@_> of the sub will receive the following: ZofCMS Template hashref, query parameters
hashref and L<App::ZofCMS::Config> object (in that order).

If you set C<plug_redirect> in both Main Config File and ZofCMS Template, the one in
ZofCMS Template will take precedence.


=head1 App::ZofCMS::Plugin::ConfigToTemplate (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::ConfigToTemplate>



App::ZofCMS::Plugin::ConfigToTemplate - plugin to dynamically stuff Main Config File keys into ZofCMS Template

SYNOPSIS

In Main Config File:

    public_config => {
        name => 'test',
        value => 'plug_test',
    },

In ZofCMS Template:

    plugins => [
        { ConfigToTemplate => 2000 },
    ],

    plug_config_to_template => {
        key     => undef,
        cell    => 't',
    },

Now we can use `name` and `value` variables in HTML::Template template...

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that technically expands functionality of
Main Config File's C<template_defaults> special key.

Using this plugin you can dynamically (and more "on demand") stuff keys from Main Config File
to ZofCMS Template hashref without messing around with other plugins and poking with
->conf method

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

Main Config File and ZofCMS Template First Level Keys

C<plugins>

    plugins => [
        { ConfigToTemplate => 2000 },
    ],

You need to include the plugin in the list of plugins to run.

C<plug_config_to_template>

    # these are the default values
    plug_config_to_template => {
        cell         => 'd',
        key          => 'public_config',
        config_cell  => 'public_config',
        config_keys  => undef,
        noop         => 0,
    }

    plug_config_to_template => sub {
        my ( $t, $q, $config ) = @_;
        return {
            cell         => 'd',
            key          => 'public_config',
            config_cell  => 'public_config',
            config_keys  => undef,
            noop         => 0,
        };
    }

The C<plug_config_to_template> must be present in order for the plugin to run. It takesa
hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_config_to_template> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Keys of this hashref can be set in either (or both) Main Config File and
ZofCMS Template - they will be merged together if set in both files; if the same key is set in
both files, the value set in ZofCMS Template will take precedence. All keys are optional, to
run the plugins with all the defaults use an empty hashref. Possible keys/values
are as follows:

C<cell>

    cell => 'd',

B<Optional>. Specifies the cell (first-level key) in ZofCMS Template hashref where to put
config file data. B<Defaults to:> C<d>

C<key>

    key => 'public_config',

    key => undef,

B<Optional>. Specifies the key in the cell (i.e. the second-level key inside the first-level
key) of where to put config file data. B<Can be set to> C<undef> in which case data will be
stuffed right into the cell. B<Defaults to:> C<public_config>

C<config_cell>

    config_cell  => 'public_config',

B<Optional>. Specifies the cell (first-level key) in Main Config File from where to take the
data. Note that C<config_cell> must point to a hashref. B<Defaults to:> C<public_config>

C<config_keys>

    config_keys  => undef,
    config_keys  => [
        qw/foo bar baz/,
    ],

B<Optional>. Takes either C<undef> or an arrayref. Specifies the keys in the cell (i.e.
the second-level key inside the first-level key) in Main Config File from where to take the
data. When set to an arrayref, the elements of the arrayref represent the names of the keys.
When set to C<undef> all keys will be taken. Note that C<config_cell> must point to
a hashref. B<Defaults to:> C<undef>

C<noop>

    noop => 0,

B<Optional>. Pneumonic: B<No> B<Op>eration. Takes either true or false values. When set to
a true value, the plugin will not run. B<Defaults to:> C<0>

EXAMPLES

EXAMPLE 1

    Config File:
    plug_config_to_template => {}, # all defaults

    public_config => {
        name => 'test',
        value => 'plug_test',
    },


    Relevant dump of ZofCMS Template hashref:

    $VAR1 = {
        'd' => {
            'public_config' => {
                'value' => 'plug_test',
                'name' => 'test'
            }
        },
    };

EXAMPLE 2

    Config File:
    plug_config_to_template => {
        key     => undef,
        cell    => 't',
    },

    public_config => {
        name => 'test',
        value => 'plug_test',
    },


    Relevant dump of ZofCMS Template hashref:

    $VAR1 = {
        't' => {
            'value' => 'plug_test',
            'name' => 'test'
        }
    };


=head1 App::ZofCMS::Plugin::Cookies (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::Cookies>



App::ZofCMS::Plugin::Cookies - HTTP Cookie handling plugin for ZofCMS

SYNOPSIS

In your ZofCMS template, or in your main config file (under C<template_defaults>
or C<dir_defaults>):

    set_cookies => [
        [ 'name', 'value' ],
        {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
        },
    ],

DESCRIPTION

This module is a plugin for L<App::ZofCMS> which provides means to
read and set HTTP cookies.

SETTING COOKIES

    # example 1
    set_cookies => [ 'name', 'value' ],

    # OR

    # example 2
    set_cookies => {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
    },

    # OR

    # example 3
    set_cookies => [
        [ 'name', 'value' ],
        {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
        },
    ],

To set cookies use C<set_cookies> first level key of your ZofCMS template.
It's value can be
either an arrayref or a hashref. When the value is an arrayref elements
of which are not arrayrefs or hashrefs (example 1 above), or when the value
is a hashref (example 2 above) it is encapsulated into an arrayref
automatically to become as shown in (example 3 above). With that in mind,
each element of an arrayref, which is a value of C<set_cookies> key,
specifies a certain cookie which plugin must set. When element of that
arrayref is an arrayref, it must contain two elements. The first element
will be the name of the cookie and the second element will be the value
of the cookie. In other words:

    set_cookies => [ 'name', 'value', ]

    # which is the same as

    set_cookies => [ [ 'name', 'value', ]

    # which is the same as

    CGI->new->cookie( -name => 'name', -value => 'value' );

When the element is a hashref, it will be dereferenced directy into
L<CGI>'s C<cookie()> method, in other words:

    set_cookies => { -name => 'name', -value => 'value' }

    # is the same as

    CGI->new->cookie( -name => 'name', -value => 'value' );

See documentation of L<CGI> module for possible values.

If C<set_cookies> key is not present, no cookies will be set.

READING COOKIES

All of the cookies are read by the plugin automatically and put into
C<< {d}{cookies} >> (the special key C<{d}> (data) of your ZofCMS template)

You can read those either via C<exec> code (NOT C<exec_before>, plugins
are run after) (If you don't know what C<exec> or C<exec_before> are
read L<App::ZofCMS::Template>). Other plugins can also read those cookies,
just make sure they are run I<after> the Cookies plugin is run (set
higher priority number). Below is an example of reading a cookie and
displaying it's value in your L<HTML::Template> template using
L<App::ZofCMS::Plugin::Tagged> plugin.

    # In your ZofCMS template:

        plugins     => [ { Cookies => 10 }, { Tagged => 20 }, ],
        set_cookies => [ foo => 'bar' ],
        t => {
            cookie_foo => '<TAG:TNo cookies:{d}{cookies}{foo}>',
        },

    # In one of your HTML::Template templates which are referenced by
    # ZofCMS plugin above:

    Cookie 'foo': <tmpl_var name="cookie_foo">

When this page is run the first time, no cookies are set, thus
{d}{cookies} will be empty and you will see the default value of
"No cookies" which we set in Tagged's tag:

    Cookie 'foo': No cookies

When the page s run the second time, Cookies plugin will read cookie
'foo' which it set on the first run and will stick its value
into {d}{cookies}{foo}. Our Tagged tag will read that value and enter
it into the C<< <tmpl_var> >> we allocated in L<HTML::Template> plugin,
thus the result will be:

    Cookie 'foo': bar

That's all there is to it, enjoy!


=head1 App::ZofCMS::Plugin::CSSMinifier (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::CSSMinifier>



App::ZofCMS::Plugin::CSSMinifier - plugin for minifying CSS files

SYNOPSIS

In your ZofCMS Template or Main Config File:

    plugins => [
        qw/CSSMinifier/,
    ],

    plug_css_minifier => {
        file => 'main.css',
    },

Now, this page can be linked into your document as a CSS file (it will be minified)

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to send minified CSS files.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

WTF IS MINIFIED?

Minified means that all the useless stuff (which means whitespace, etc)
will be stripped off the CSS file to save a few bytes. See L<CSS::Minifier> for more info.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/CSSMinifier/,
    ],

B<Mandatory>. You need to include the plugin to the list of plugins to execute.

C<plug_css_minifier>

    plug_css_minifier => {
        file        => 'main.css',
        auto_output => 1, # default value
        cache       => 1, # default value
    },

    plug_css_minifier => sub {
        my ( $t, $q, $config ) = @_;
        return {
            file        => 'main.css',
            auto_output => 1, # default value
            cache       => 1, # default value
        }
    },

B<Mandatory>. Takes or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_css_minifier> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object; individual keys can be set in both Main Config
File and ZofCMS Template, if the same key set in both, the value in ZofCMS Template will
take precedence. The following keys/values are accepted:

C<file>

    plug_css_minifier => {
        file        => 'main.css',
    }

B<Mandatory>. Takes a string as an argument that specifies the name of the CSS file to
minify. The filename is relative to C<index.pl> file.

C<cache>

    plug_css_minifier => {
        file        => 'main.css',
        cache       => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value the plugin will
send out an HTTP C<Expires> header that will say that this content expries in like 2038, thus
B<set this option to a false value while still developing your CSS>. This argument
has no effect when C<auto_output> (see below) is turned off (set to a false value).
B<Defaults to:> C<1>

C<auto_output>

    plug_css_minifier => {
        file        => 'main.css',
        auto_output => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value, plugin will
automatically send C<text/css> C<Content-type> header (along with C<Expires> header if
C<cache> argument is set to a true value), output the minified CSS file B<and exit()>.
Otherwise, the minified CSS file will be put into C<< $t->{t}{plug_css_minifier} >>
where C<$t> is ZofCMS Template hashref and you can do whatever you want with it.
B<Defaults to:> C<1>


=head1 App::ZofCMS::Plugin::DateSelector (version 0.0112)

NAME


Link: L<App::ZofCMS::Plugin::DateSelector>



App::ZofCMS::Plugin::DateSelector - plugin to generate and "parse" <select>s for date/time input

SYNOPSIS

In ZofCMS Template or Main Config File

    # the Sub plugin is used only for demonstration here

    plugins => [ { DateSelector => 2000 }, { Sub => 3000 } ],

    plug_date_selector => {
        class           => 'date_selector',
        id              => 'date_selector',
        q_name          => 'date',
        t_name          => 'date_selector',
        start           => time() - 30000000,
        end             => time() + 30000000,
        interval_step   => 'minute',
        interval_max    => 'year',
    },

    plug_sub => sub {
        my $t = shift;
        $t->{t}{DATE} = "[$t->{d}{date_selector}{localtime}]";
    },

In L<HTML::Template> template:

    <form...

        <label for="date_selector">When: </label><tmpl_var name="date_selector">

    .../form>

    <tmpl_if name="DATE">
        <p>You selected: <tmpl_var name="DATE"></p>
    <tmpl_else>
        <p>You did not select anything yet</p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to generate several
C<< <select> >> elements for date and time selection by the user. Plugin also provides means
to "parse" those C<< <select> >>s from the query to generate either epoch time, same string
as C<localtime()> or access each selection individually from a hashref.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/DateSelector/ ],

You obviously need to add the plugin to the list of plugins to execute. The plugin does not
provide any input checking and sticks the "parse" of query into the C<{d}> special key in
ZofCMS Template, thus you'd very likely to use this plugin in combination with some other
plugin.

C<plug_date_selector>

    plug_date_selector => {
        class           => 'date_selector',
        id              => 'date_selector',
        q_name          => 'date',
        t_name          => 'date_selector',
        d_name          => 'date_selector',
        start           => time() - 30000000,
        end             => time() + 30000000,
        interval_step   => 'minute',
        interval_max    => 'year',
    }

    plug_date_selector => [
        {
            class           => 'date_selector1',
            id              => 'date_selector1',
            q_name          => 'date1',
            t_name          => 'date_selector1',
            d_name          => 'date_selector1',
        },
        {
            class           => 'date_selector2',
            id              => 'date_selector2',
            q_name          => 'date2',
            t_name          => 'date_selector2',
            d_name          => 'date_selector2',
        }
    ]

Plugin will not run unless C<plug_date_selector> first-level key is specified in either
ZofCMS Template or Main Config File. When specified in both, ZofCMS Template and Main Config
File, then the value set in ZofCMS Template takes precedence. To use the plugin with all
of its defaults use C<< plug_date_selector => {} >>

The C<plug_date_selector> key takes either hashref or an arrayref as a value. If the value
is a hashref, it is the same as specifying an arrayref with just that hashref in it. Each
hashref represents a separate "date selector", i.e. a set of C<< <select> >> elements for
date selection. The possible keys/values of each of those hashrefs are as follows:

C<class>

    class => 'date_selector',

B<Optional>. Specifies the C<class=""> attribute to stick on every generated C<< <select> >>
element in the date selector. B<Defaults to:> C<date_selector>

C<id>

    id => 'date_selector',

B<Optional>. Specifies the C<id=""> attribute to stick on the B<first> generated
C<< <select> >> element in the date selector. B<By default> is not specified, i.e. no C<id="">
will be added.

C<q_name>

    q_name => 'date',

B<Optional>. Specifies the "base" B<q>uery parameter name for generated C<< <select> >>
elements.
Each of those elements will have its C<name=""> attribute made from C<$q_name . '_' . $type>,
where C<$q_name> is the value of C<q_name> key and C<$type> is the type of the
C<< <select> >>, the types are as follows: C<year>, C<month>, C<day>, C<hour>, C<minute>
and C<second>. B<Defaults to:> C<date>

C<t_name>

    t_name => 'date_selector',

B<Optional>. Specifies the name of the key in C<{t}> ZofCMS Template special key where to
stick HTML code for generated C<< <select> >>s. B<Defaults to:> C<date_selector>, thus you'd
use C<< <tmpl_var name='date_selector'> >> to insert HTML code.

C<d_name>

    d_name => 'date_selector',

B<Optional>. If plugin sees that the query contains B<all> of the parameters from a given
"date selector", then it will set the C<d_name> key in C<{d}> ZofCMS Template special key
with a hashref that contains three keys:

    $VAR1 = {
        'time' => 1181513455,
        'localtime' => 'Sun Jun 10 18:10:55 2007',
        'bits' => {
            'hour' => '18',
            'minute' => '10',
            'second' => 55,
            'month' => '5',
            'day' => '10',
            'year' => 107
        }
    };

C<time>

    'time' => 1181513455,

The C<time> key will contain the epoch time of the date that user selected (i.e. as C<time()>
would output).

C<localtime>

    'localtime' => 'Sun Jun 10 18:10:55 2007',

The C<localtime> key will contain the "date string" of the selected date (i.e. output of
C<localtime()>).

C<bits>

    'bits' => {
        'hour' => '18',
        'minute' => '10',
        'second' => 55,
        'month' => '5',
        'day' => '10',
        'year' => 107
    }

The C<bits> key will contain a B<hashref>, with individual "bits" of the selected date. The
"bits" are keys in the hashref and are as follows: year, month, day, hour, minute and second.
If your date selector's range does not cover all the values (e.g. has only month and day)
(see C<interval_step> and C<interval_max> options below) then the B<missing values> will
be taken from the output of C<localtime()>. The values of each of these "bits" are in
the same format as C<localtime()> would give them to you, i.e. to get the full year you'd
do bits->{year} + 1900.

C<start>

    start => time() - 30000000,

B<Optional>. The plugin will generate values for C<< <select> >> elements to cover a certain
period of time. The C<start> and C<end> (see below) parameters take the number of seconds
from epoch (i.e. same as return of C<time()>) as values and C<start> indicates the start
of the period to cover and C<end> indicates the end of the time period to cover. B<Defaults
to:> C<time() - 30000000>

C<end>

    end => time() + 30000000,

B<Optional>. See description of C<start> right above. B<Defaults to:> C<time() + 30000000>

C<interval_step>

    interval_step   => 'minute',

B<Optional>. Specifies the "step", or the minimum unit of time the user would be able to
select. Valid values (all lowercase) are as follows: C<year>, C<month>, C<day>, C<hour>,
C<minute> and C<second>. B<Defaults to:> C<minute>

C<interval_max>

    interval_max => 'year',

B<Optional>. Specifies the maximum unit of time the user would be able to select.
Valid values (all lowercase) are as follows: C<year>, C<month>, C<day>, C<hour>,
C<minute> and C<second>. B<Defaults to:> C<year>

C<minute_step>

    minute_step => 5,

B<Optional>. Specifies the "step" of minutes to display, in other words, when C<minute_step>
is set to C<10>, then in the "minutes" C<< <select> >>
the plugin will generate only C<< <option> >>s 0, 10, 20, 30, 40 and 50. B<Defaults to:>
C<5> (increments of 5 minutes).

C<second_step>

    second_step => 10,

B<Optional>. Specifies the "step" of seconds to display, in other words, when C<second_step>
is set to C<10>, then in the "minutes" C<< <select> >>
the plugin will generate only C<< <option> >>s 0, 10, 20, 30, 40 and 50. B<Defaults to:>
C<5> (increments of 5 minutes).

HTML::Template VARIABLES

See description of C<t_name> argument above. The value of C<t_name> specifies the name
of the C<< <tmpl_var name=""> >> plugin will generate. Note that there could be several of
these of you are generating several date selectors.

GENERATED HTML CODE

The following is a sample of the generated code with all the defaults left intact:

    <select name="date_year" class="date_selector">
        <option value="107" selected>2007</option>
        <option value="108">2008</option>
        <option value="109">2009</option>
    </select>

    <select name="date_month" class="date_selector">
        <option value="0" selected>January</option>
        <option value="1">February</option>
        <option value="2">March</option>
        <option value="3">April</option>
        <option value="4">May</option>
        <option value="5">June</option>
        <option value="6">July</option>
        <option value="7">August</option>
        <option value="8">September</option>
        <option value="9">October</option>
        <option value="10">November</option>
        <option value="11">December</option>
    </select>

    <select name="date_day" class="date_selector">
        <option value="1" selected>Day: 1</option>
        <option value="2">Day: 2</option>
        <option value="3">Day: 3</option>
        <option value="4">Day: 4</option>
        <option value="5">Day: 5</option>
        <option value="6">Day: 6</option>
        <option value="7">Day: 7</option>
        <option value="8">Day: 8</option>
        <option value="9">Day: 9</option>
        <option value="10">Day: 10</option>
        <option value="11">Day: 11</option>
        <option value="12">Day: 12</option>
        <option value="13">Day: 13</option>
        <option value="14">Day: 14</option>
        <option value="15">Day: 15</option>
        <option value="16">Day: 16</option>
        <option value="17">Day: 17</option>
        <option value="18">Day: 18</option>
        <option value="19">Day: 19</option>
        <option value="20">Day: 20</option>
        <option value="21">Day: 21</option>
        <option value="22">Day: 22</option>
        <option value="23">Day: 23</option>
        <option value="24">Day: 24</option>
        <option value="25">Day: 25</option>
        <option value="26">Day: 26</option>
        <option value="27">Day: 27</option>
        <option value="28">Day: 28</option>
        <option value="29">Day: 29</option>
        <option value="30">Day: 30</option>
        <option value="31">Day: 31</option>
    </select>

    <select name="date_hour" class="date_selector">
        <option value="0" selected>Hour: 0</option>
        <option value="1">Hour: 1</option>
        <option value="2">Hour: 2</option>
        <option value="3">Hour: 3</option>
        <option value="4">Hour: 4</option>
        <option value="5">Hour: 5</option>
        <option value="6">Hour: 6</option>
        <option value="7">Hour: 7</option>
        <option value="8">Hour: 8</option>
        <option value="9">Hour: 9</option>
        <option value="10">Hour: 10</option>
        <option value="11">Hour: 11</option>
        <option value="12">Hour: 12</option>
        <option value="13">Hour: 13</option>
        <option value="14">Hour: 14</option>
        <option value="15">Hour: 15</option>
        <option value="16">Hour: 16</option>
        <option value="17">Hour: 17</option>
        <option value="18">Hour: 18</option>
        <option value="19">Hour: 19</option>
        <option value="20">Hour: 20</option>
        <option value="21">Hour: 21</option>
        <option value="22">Hour: 22</option>
        <option value="23">Hour: 23</option>
    </select>

    <select name="date_minute" class="date_selector">
        <option value="0" selected>Minute: 00</option>
        <option value="5">Minute: 05</option>
        <option value="10">Minute: 10</option>
        <option value="15">Minute: 15</option>
        <option value="20">Minute: 20</option>
        <option value="25">Minute: 25</option>
        <option value="30">Minute: 30</option>
        <option value="35">Minute: 35</option>
        <option value="40">Minute: 40</option>
        <option value="45">Minute: 45</option>
        <option value="50">Minute: 50</option>
        <option value="55">Minute: 55</option>
    </select>


=head1 App::ZofCMS::Plugin::DBI (version 0.0402)

NAME


Link: L<App::ZofCMS::Plugin::DBI>



App::ZofCMS::Plugin::DBI - DBI access from ZofCMS templates

SYNOPSIS

In your main config file or ZofCMS template:

    dbi => {
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test', # user,
        pass    => 'test', # pass
        opt     => { RaiseError => 1, AutoCommit => 0 },
    },

In your ZofCMS template:

    dbi => {
        dbi_get => {
            layout  => [ qw/name pass/ ],
            sql     => [ 'SELECT * FROM test' ],
        },
        dbi_set => sub {
            my $query = shift;
            if ( defined $query->{user} and defined $query->{pass} ) {
                return [
                    [ 'DELETE FROM test WHERE name = ?;', undef, $query->{user}      ],
                    [ 'INSERT INTO test VALUES(?,?);', undef, @$query{qw/user pass/} ],
                ];
            }
            elsif ( defined $query->{delete} and defined $query->{user_to_delete} ) {
                return [ 'DELETE FROM test WHERE name =?;', undef, $query->{user_to_delete} ];
            }
            return;
        },
    },

In your L<HTML::Template> template:

    <form action="" method="POST">
        <div>
            <label for="name">Name: </label>
            <input id="name" type="text" name="user" value="<tmpl_var name="query_user">"><br>
            <label for="pass">Pass: </label>
            <input id="pass" type="text" name="pass" value="<tmpl_var name="query_pass">"><br>
            <input type="submit" value="Add">
        </div>
    </form>
    
    <table>
        <tmpl_loop name="dbi_var">
            <tr>
                <td><tmpl_var name="name"></td>
                <td><tmpl_var name="pass"></td>
                <td>
                    <form action="" method="POST">
                        <div>
                            <input type="hidden" name="user_to_delete" value="<tmpl_var name="name">">
                            <input type="submit" name="delete" value="Delete">
                        </div>
                    </form>
                </td>
            </tr>
        </tmpl_loop>
    </table>

DESCRIPTION

Module is a L<App::ZofCMS> plugin which provides means to retrieve
and push data to/from SQL databases using L<DBI> module.

Current functionality is limited. More will be added as the need arrises,
let me know if you need something extra.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

DSN AND CREDENTIALS

    dbi => {
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test', # user,
        pass    => 'test', # pass
        opt     => { RaiseError => 1, AutoCommit => 0 },
        last_insert_id => 1,
        do_dbi_set_first => 1,
    },

You can set these either in your ZofCMS template's C<dbi> key or in your
main config file's C<dbi> key. The key takes a hashref as a value.
The keys/values of that hashref are as follows:

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

Specifies the DSN for DBI, see C<DBI> for more information on what to use
here.

C<user> and C<pass>

        user    => 'test', # user,
        pass    => 'test', # pass

The C<user> and C<pass> key should contain username and password for
the database you will be accessing with your plugin.

C<opt>

    opt => { RaiseError => 1, AutoCommit => 0 },

The C<opt> key takes a hashref of any additional options you want to
pass to C<connect_cached> L<DBI>'s method.

C<last_insert_id>

    last_insert_id => 1,
    last_insert_id => [
        $catalog,
        $schema,
        $table,
        $field,
        \%attr,
    ],

B<Optional>. When set to a true value, the plugin will attempt to figure out the
C<LAST_INSERT_ID()> after processing C<dbi_set> (see below). The result will be placed
into C<d> ZofCMS Template special key under key C<last_insert_id> (currently there is no
way to place it anywhere else). The value of C<last_insert_id> argument can be either a true
value or an arrayref. Having any true value but an arrayref is the same as having an
arrayref with three C<undef>s. That arrayref will be directly dereferenced into L<DBI>'s
C<last_insert_id()> method. See documentation for L<DBI> for more information.
B<By default is not specified> (false)

C<do_dbi_set_first>

    do_dbi_set_first => 1,

B<Optional>. Takes either true or false values. If set to a true value, the plugin
will first execute C<dbi_set> and then C<dbi_get>; if set to a false value, the order will
be reversed (i.e. C<dbi_get> first and then C<dbi_set> will be executed. B<Defaults to:> C<1>

RETRIEVING FROM AND SETTING DATA IN THE DATABASE

In your ZofCMS template the first-level C<dbi> key accepts a hashref two
possible keys: C<dbi_get> for retreiving data from database and C<dbi_set>
for setting data into the database. Note: you can also have your C<dsn>,
C<user>, C<pass> and C<opt> keys here if you wish.

C<dbi_get>

    dbi => {
        dbi_get => {
            layout  => [ qw/name pass/ ],
            single  => 1,
            sql     => [ 'SELECT * FROM test' ],
            on_data => 'has_data',
            process => sub {
                my ( $data_ref, $template, $query, $config ) = @_;
            }
        },
    }

    dbi => {
        dbi_get => sub {
            my ( $query, $template, $config, $dbh ) = @_;
            return {
                sql     => [
                    'SELECT * FROM test WHERE id = ?',
                    { Slice => {} },
                    $query->{id},
                ],
                on_data => 'has_data',
            }
        },
    },

    dbi => {
        dbi_get => [
            {
                layout  => [ qw/name pass/ ],
                sql     => [ 'SELECT * FROM test' ],
            },
            {
                layout  => [ qw/name pass time info/ ],
                sql     => [ 'SELECT * FROM bar' ],
            },
        ],
    }

The C<dbi_get> key takes either a hashref, a subref or an arrayref as a value.
If the value is a subref, the subref will be evaluated and its value will be assigned to C<dbi_get>; the C<@_> of that subref will contain the following (in that order):
C<$query, $template, $config, $dbh> where C<$query> is query string hashref, C<$template> is
ZofCMS Template hashref, $config is the L<App::ZofCMS::Config> object and C<$dbh> is a
L<DBI> database handle (already connected).

If the value is a hashref it is the same as having just that hashref
inside the arrayref. Each element of the arrayref must be a hashref with
instructions on how to retrieve the data. The possible keys/values of
that hashref are as follows:

C<layout>

    layout  => [ qw/name pass time info/ ],

B<Optional>. Takes an arrayref as an argument.
Specifies the name of C<< <tmpl_var name=""> >>s in your
C<< <tmpl_loop> >> (see C<type> argument below) to which map the columns
retrieved from the database, see C<SYNOPSIS> section above. If the second element in your
C<sql> arrayref is a hashref with a key C<Slice> whose value is a hashref, then C<layout>
specifies which keys to keep, since C<selectall_arrayref()> (the only currently supported
method) will return an arrayref of hashrefs where keys are column names and values are
the values. Not specifying C<layout> is only allowed when C<Slice> is a hashref and in that
case all column names will be kept. B<By default> is not specified.

C<sql>

    sql => [ 'SELECT * FROM bar' ],

B<Mandatory>. Takes an arrayref as an argument which will be directly
dereferenced into the L<DBI>'s method call specified by C<method> argument
(see below). See L<App::ZofCMS::Plugin::Tagged> for possible expansion
of possibilities you have here.

C<single>

    single => 1,

B<Optional>. Takes either true or false values. Normally, the plugin will make
a datastructure suitable for a C<< <tmpl_loop name=""> >>; however, if you expecting
only one row from the table to be returned you can set C<single> parameter B<to a true value>
and then the plugin will stuff appropriate values into C<{t}> special hashref where keys will
be the names you specified in the C<layout> argument and values will be the values of the
first row that was fetched from the database. B<By default is not specified> (false)

C<single_prefix>

    single_prefix => 'dbi_',

B<Optional>. Takes a scalar as a value. Applies only when 
C<single> (see above) is set to a true value. The value you specify here
will be prepended to any key names your C<dbi_get> generates. This is
useful when you're grabbing a single record from the database and
dumping it directly into C<t> special key; using the prefix helps
prevent any name clashes. B<By default is not specified>

C<type>

    dbi_get => {
        type    => 'loop'
    ...

B<Optional>. Specifies what kind of a L<HTML::Template> variable to
generate from database data. Currently the only supported value is C<loop>
which generates C<< <tmpl_loop> >> for yor L<HTML::Template> template.
B<Defaults to:> C<loop>

C<name>

    dbi_get => {
        name    => 'the_var_name',
    ...

B<Optional>. Specifies the name of the key in the C<cell> (see below) into
which to stuff your data. With the default C<cell> argument this will
be the name of a L<HTML::Template> var to set. B<Defaults to:> C<dbi_var>

C<method>

    dbi_get => {
        method => 'selectall',
    ...

B<Optional>. Specifies with which L<DBI> method to retrieve the data.
Currently the only supported value for this key is C<selectall> which
uses L<selectall_arrayref>. B<Defaults to:> C<selectall>

C<cell>

    dbi_get => {
        cell => 't'
    ...

B<Optional>. Specifies the ZofCMS template's first-level key in which to
create the C<name> key with data from the database. C<cell> must point
to a key with a hashref in it (though, keep autovivification in mind).
Possibly the sane values for this are either C<t> or C<d>. B<Defaults to:>
C<t> (the data will be available in your L<HTML::Template> templates)

C<on_data>

    dbi_get => {
        on_data => 'has_data',
    ...

B<Optional>. Takes a string as an argument. When specified will set the key in C<{t}> name of
which is specified C<on_data> to C<1> when there are any rows that were selected. Typical
usage for this would be to display some message if no data is available; e.g.:

    dbi_get => {
        layout => [ qw/name last_name/ ],
        sql => [ 'SELECT * FROM users' ],
        on_data => 'has_users',
    },

    <tmpl_if name="has_users">
        <p>Here are the users:</p>
        <!-- display data here -->
    <tmpl_else>
        <p>I have no users for you</p>
    </tmpl_if>

C<process>

    dbi_get => {
        process => sub {
            my ( $data_ref, $template, $query, $config ) = @_;
            # do stuff
        }
    ...

B<Optional>. Takes a subref as a value. When specified the sub will be executed right after
the data is fetched. The C<@_> will contain the following (in that order):
C<$data_ref> - the return of L<DBI>'s C<selectall_arrayref> call, this may have other
options later on when more methods are supported, the ZofCMS Template hashref, query
hashref and L<App::ZofCMS::Config> object.

C<dbi_set>

    dbi_set => sub {
        my $query = shift;
        if ( defined $query->{user} and defined $query->{pass} ) {
            return [
                [ 'DELETE FROM test WHERE name = ?;', undef, $query->{user}      ],
                [ 'INSERT INTO test VALUES(?,?);', undef, @$query{qw/user pass/} ],
            ];
        }
        elsif ( defined $query->{delete} and defined $query->{user_to_delete} ) {
            return [ 'DELETE FROM test WHERE name =?;', undef, $query->{user_to_delete} ];
        }
        return;
    },

    dbi_set => [
        'DELETE FROM test WHERE name = ?;', undef, 'foos'
    ],

    dbi_set => [
        [ 'DELETE FROM test WHERE name = ?;', undef, 'foos' ],
        [ 'INSERT INTO test VALUES(?, ?);', undef, 'foos', 'bars' ],
    ]

B<Note:> the C<dbi_set> will be processed B<before> C<dbi_get>. Takes
either a subref or an arrayref as an argument. Multiple instructions
can be put inside an arrayref as the last example above demonstrates. Each
arrayref will be directly dereferenced into L<DBI>'s C<do()> method. Each
subref must return either a single scalar, an arrayref or an arrayref
of arrayrefs. Returning a scalar is the same as returning an arrayref
with just that scalar in it. Returning just an arrayref is the same as
returning an arrayref with just that arrayref in it. Each arrayref of
the resulting arrayref will be directly dereferenced into L<DBI>'s C<do()>
method. The subrefs will have the following in their C<@_> when called:
C<< $query, $template, $config, $dbh >>. Where C<$query> is a hashref
of query parameters in which keys are the name of the parameters and
values are values. C<$template> is a hashref of your ZofCMS template.
C<$config> is the L<App::ZofCMS::Config> object and C<$dbh> is L<DBI>'s
database handle object.


=head1 App::ZofCMS::Plugin::DBIPPT (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::DBIPPT>



App::ZofCMS::Plugin::DBIPPT - simple post-processor for results of DBI plugin queries

SYNOPSIS

In your ZofCMS Template or Main Config file:

    plugins => [
        { DBI => 2000 },  # use of DBI plugin in this example is optional
        { DBIPPT => 3000 },
    ],

    dbi => {
        # ..connection options are skipped for brevity

        dbi_get => {
            name => 'comments',
            sql  => [
                'SELECT `comment`, `time` FROM `forum_comments`',
                { Slice => {} },
            ],
        },
    },

    plug_dbippt => {
        key => 'comments',
        n   => 'comment',
        # t => 'time' <---- by default, so we don't need to specify it
    }

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides 
means to automatically post-process some most common (at least for me)
post-processing needs when using L<App::ZofCMS::Plugin::DBI>; namely,
converting numerical output of C<time()> with C<localtime()> as well
as changing new lines in regular text data into C<br>s while escaping
HTML Entities.

This documentation assumes you've read L<App::ZofCMS>, 
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

DO I HAVE TO USE DBI PLUGIN?

No, you don't have to use L<App::ZofCMS::Plugin::DBI>, 
C<App::ZofCMS::Plugin::DBIPPT> can be run on any piece of data
that fits the description of C<< <tmpl_loop> >>. The reason for the
name and use of L<App::ZofCMS::Plugin::DBI> in my examples here is because
I only required doing such post-processing as this plugin when I used
the DBI plugin.

WTF IS PPT?

Ok, the name C<DBIPPT> isn't the most clear choice for the name of
the plugin, but when I first wrote out the full name I realized that
the name alone defeats the purpose of the plugin - saving keystrokes -
so I shortened it from C<DBIPostProcessLargeText> to C<DBIPPT> (the C<L>
was lost in "translation" as well). If you're suffering from memory
problems, I guess one way to remember the name is "B<P>lease B<Process>
B<This>".

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        { DBI => 2000 },  # example plugin that generates original data
        { DBIPPT => 3000 }, # higher run level (priority)
    ],

You need to include the plugin in the list of plugins to run. Make
sure to set the priority right so C<DBIPPT> would be run after
any other plugins generate data for processing.

C<plug_dbippt>

    # run with all the defaults
    plug_dbippt => {},

    # all arguments specified (shown are default values)
    plug_dbippt => {
        cell    => 't',
        key     => 'dbi',
        n       => undef,
        t       => 'time',
    }

    # derive config via a sub
    plug_dbippt => sub {
        my ( $t, $q, $config ) = @_;
        return {
            cell    => 't',
            key     => 'dbi',
            n       => undef,
            t       => 'time',
        };
    }

B<Mandatory>. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_dbippt> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run with all the defaults,
use an empty hashref. The keys/values are as follows:

C<cell>

    plug_dbippt => {
        cell => 't',
    }

B<Optional>. Specifies the first-level ZofCMS Template hashref key
under which to look for data to convert. B<Defaults to:> C<t>

C<key>

    plug_dbippt => {
        key => 'dbi',
    }

    # or
    plug_dbippt => {
        key => [ qw/dbi dbi2 dbi3 etc/ ],
    }
    
    # or
    plug_dbippt => {
        key => sub {
            my ( $t, $q, $config ) = @_;
            return
                unless $q->{single};

            return $q->{single} == 1
            ? 'dbi' : [ qw/dbi dbi2 dbi3 etc/ ];
        }
    }

B<Optional>. Takes either
a string, subref or an arrayref as a value. If the value is a subref,
that subref will be executed and its return value will be assigned
to C<key> as if it was already there. The C<@_> will contain
(in that order) ZofCMS Template hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Passing (or returning from the sub) 
a string is the same as passing an arrayref with just that string in it.

Each element of the arrayref specifies the second-level key(s) inside 
C<cell> first-level key value of which is an arrayref of either hashrefs
or arrayrefs (i.e. typical output of L<App::ZofCMS::Plugin::DBI>).
B<Defaults to:> C<dbi>

C<n>

    plug_dbippt => {
        n => 'comments',
    }
    
    # or
    plug_dbippt => {
        n => [ 'comments', 'posts', 'messages' ],
    }

    # or
    plug_dbippt => {
        n => sub {
            my ( $t, $q, $config ) = @_;
            return
                unless $q->{single};

            return $q->{single} == 1
            ? 'comments' : [ qw/comments posts etc/ ];
        }
    }

B<Optional>. Pneumonic: B<n>ew lines. Keys/indexes specified in
C<n> argument will have HTML entities escaped and new lines converted
to C<< <br> >> HTML elements.

Takes either a string, subref or an arrayref as a value. If the value is a subref,
that subref will be executed and its return value will be assigned
to C<n> as if it was already there. The C<@_> will contain
(in that order) ZofCMS Template hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Passing (or returning from the sub) 
a string is the same as passing an arrayref with just that string in it.
If set to C<undef> no processing will be done for new lines.

Each element of the arrayref specifies either the B<keys> of the hashrefs
(for DBI plugin that would be when second element of C<sql> arrayref
is set to C<< { Slice => {} } >>) or B<indexes> of the arrayrefs
(if they are arrayrefs). 
B<Defaults to:> C<undef>

C<t>

    plug_dbippt => {
        t => undef, # no processing, as the default value is "time"
    }

    # or
    plug_dbippt => {
        t => [ qw/time post_time other_time/ ],
    }

    # or
    plug_dbippt => {
        t => sub {
            my ( $t, $q, $config ) = @_;
            return
                unless $q->{single};

            return $q->{single} == 1
            ? 'time' : [ qw/time post_time other_time/ ];
        }
    }

B<Optional>. Pneumonic: B<t>ime. Keys/indexes specified in
C<t> argument are expected to point to either C<undef> or empty string, in which case, no conversion will
be done, or values of C<time()> output
and what will be done is C<scalar localtime($v)> (where C<$v>) is 
the original value) run on them and the return is assigned back to
the original. In other words, they will be converted from C<time> to 
C<localtime>.

Takes either a string, subref or an arrayref as a value. If the value is a subref,
that subref will be executed and its return value will be assigned
to C<t> as if it was already there. The C<@_> will contain
(in that order) ZofCMS Template hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Passing (or returning from the sub) 
a string is the same as passing an arrayref with just that string in it.
If set to C<undef> no processing will be done.

Each element of the arrayref specifies either the B<keys> of the hashrefs
(for DBI plugin that would be when second element of C<sql> arrayref
is set to C<< { Slice => {} } >>) or B<indexes> of the arrayrefs
(if they are arrayrefs).
B<Defaults to:> C<time>


=head1 App::ZofCMS::Plugin::Debug::Dumper (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Debug::Dumper>



App::ZofCMS::Plugin::Debug::Dumper - small debugging plugin that Data::Dumper::Dumper()s interesting portions into {t}

SYNOPSIS

In your Main Config file or ZofCMS Template:

    plugins => [ qw/Debug::Dumper/ ],

In your L<HTML::Template> template:

    Dump of {t} key: <tmpl_var name="dumper_tt">
    Dump of {d} key: <tmpl_var name="dumper_td">
    Dump of ZofCMS template: <tmpl_var name="dumper_t">
    Dump of query: <tmpl_var name="dumper_q">
    Dump of main config: <tmpl_var name="dumper_c">

DESCRIPTION

The module is a small debugging plugin for L<App::ZofCMS>. It uses L<Data::Dumper> to
make dumps of 5 things and sticks them into C<{t}> ZofCMS template key so you could display
the dumps in your L<HTML::Template> template for debugging purposes.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config>
and L<App::ZofCMS::Template>

MAIN CONFIG FILE OR ZofCMS TEMPLATE

C<plugins>

    plugins => [ qw/Debug::Dumper/ ],

    plugins => [ { UserLogin => 100 }, { 'Debug::Dumper' => 200 } ],

You need to add the plugin to the list of plugins to execute (duh!). By setting the priority
of the plugin you can make dumps before or after some plugins executed.

C<plug_dumper>

    plug_dumper => {
        t_prefix    => 'dumper_',
        use_qq      => 1,
        pre         => 1,
        escape_html => 1,
        line_length => 80,
    },

The plugin takes configuration via C<plug_dumper> first-level key that can be either
in ZofCMS template or Main Config file, same keys set in ZofCMS template will override
those keys set in Main Config file. As opposed to many ZofCMS plugins,
L<App::ZofCMS::Plugin::Debug::Dumper> will B<still> execute even if the C<plug_dumper>
key is not set to anything.

The C<plug_dumper> key takes a hashref as a value. Possible keys/values of that hashref
are as follows:

C<t_prefix>

    { t_prefix => 'dumper_', }

B<Optional>. The C<t_prefix> specifies the string to use to prefix the names of the
L<HTML::Template> variables generated by the plugin in C<{t}> ZofCMS Template key. See
C<HTML::Template VARIABLES> section below for more information. B<Defaults to:> C<dumper_> (
note the underscore at the end)

C<use_qq>

    { use_qq => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value, the plugin
will set C<$Data::Dumper::Useqq> to C<1> before making the dumps, this will basically
make, e.g. C<"\n">s instead of generating real new lines in output. See L<Data::Dumper> for
more information. B<Defaults to:> C<1>

C<pre>

    { pre => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value the plugin
will wrap all the generated dumps into HTML C<< <pre></pre> >> tags. B<Defaults to:> C<1>

C<escape_html>

    { escape_html => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value the plugin
will escape HTML code in the dumps. B<Defaults to:> C<1>

C<line_length>

    { line_length => 150, }

B<Optional>. The C<line_length> key takes a positive integer as a value. This value will
specify the maximum length of each line in generated dumps. Strictly speaking it will
stick a C<\n> after every C<line_length> characters that are not C<\n>.
B<Special value> or C<0> will B<disable> line length feature. B<Defaults to:> C<150>

HTML::Template VARIABLES

The plugin will stick the generated dumps in the C<{t}> ZofCMS template special key;
that means that you can dump them out in your L<HTML::Template> templates with
C<< <tmpl_var name""> >>s. The following five variables are available so far:

    Dump of {t} key: <tmpl_var name="dumper_tt">
    Dump of {d} key: <tmpl_var name="dumper_td">
    Dump of ZofCMS template: <tmpl_var name="dumper_t">
    Dump of query: <tmpl_var name="dumper_q">
    Dump of main config: <tmpl_var name="dumper_c">

The C<{t}> and C<{d}> keys refer to special keys in ZofCMS Templates. The C<query> is
the hashref of query parameters passed to the script and C<main config> is your Main Config
file hashref. The C<dumper_> prefix in the C<< <tmpl_var name=""> >>s above is the
C<t_prefix> that you can set in C<plug_dumper> configuration key (explained way above). In
other words, in your main config file or ZofCMS template you can set:
C<< plug_dumper => { t_prefix => '_' } >> and in L<HTML::Template> templates you'd then use
C<< <tmpl_var name="_tt"> >>, C<< <tmpl_var name="_q"> >>, etc.

The names are generated by using C<$t_prefix  . $name>, where C<$t_prefix> is C<t_prefix>
set in C<plug_dumper> and C<$name> is one of the "variable names" that are as follows:

C<tt>

    <tmpl_var name="dumper_tt">

The dump of C<{t}> ZofCMS template special key. Mnemonic: B<t>emplate {B<t>} key.

C<td>

    <tmpl_var name="dumper_td">

The dump of C<{d}> ZofCMS template special key. Mnemonic: B<t>emplate {B<d>} key.

C<t>

    <tmpl_var name="dumper_t">

The dump of entire ZofCMS template hashref. Mnemonic: B<t>emplate.

C<q>

    <tmpl_var name="dumper_q">

The dump of query parameters as a hashref, in parameter/value way. Mnemonic: B<q>uery.

C<c>

    <tmpl_var name="dumper_c">

The dump of your Main Config file hashref. Mnemonic: B<c>onfig.

SPECIAL NOTES

Note that all properly behaving plugins will remove their config data from ZofCMS templates
and Main Config files, that list includes this plugin as well, therefore when dumping
the ZofCMS template (C<< <tmpl_var name="dumper_t"> >>) after the plugins were executed, you
will not see the configuration for those plugins that you wrote.

SEE ALSO

L<Data::Dumper>


=head1 App::ZofCMS::Plugin::Debug::Validator::HTML (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Debug::Validator::HTML>



App::ZofCMS::Plugin::Debug::Validator::HTML - debugging plugin for auto validating HTML

SYNOPSIS

In your Main Config file or ZofCMS Template:

    plugins => [ 'Debug::Validator::HTML' ]

In your L<HTML::Template> template:

    <tmpl_var name="plug_val_html">

Access your page with L<http://your.domain.com/index.pl?page=/test&plug_val_html=1>

Read the validation results \o/

DESCRIPTION

The module is a B<debugging> plugin for L<App::ZofCMS> that provides means to validate the HTML
code that you are writing on the spot.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/Debug::Validator::HTML/ ],

You need to include the plugin in the list of plugins to be executed.

C<plug_validator_html>

    # everything is optional
    plug_validator_html => {
        t_name          => 'plug_val_html',
        q_name          => 'plug_val_html',
        validator_uri   => 'http://127.0.0.1/w3c-markup-validator/check',
        address         => 'http://your.site.com/index.pl?page=/test', 
    }

The plugin takes its optional configuration from C<plug_validator_html> first-level key that
takes a hashref as a value. Plugin will B<still run> even if C<plug_validator_html> key
is not present. You can set any of the config options in either Main Config File or ZofCMS
Template file. Whatever you set in ZofCMS Template file will override the same key if
it was set in Main Config File. Possible keys/values are as follows:

C<t_name>

    t_name => 'plug_val_html',

B<Optional>. The plugin sets validation results in one of the keys in the C<{t}> special key.
The C<t_name> argument specifies the name of that key. See C<HTML::Template VARIABLES> section
below for details. B<Defaults to:> C<plug_val_html>

C<q_name>

    q_name => 'plug_val_html',

B<Optional>. To trigger the execution of the plugin you need to pass a query parameter that
is set to a true value. This is to speed up normal development process (because
you don't really want to validate on every refresh) but most importantly it is to prevent
infinite loops where the plugin will try to execute itself while fetching your HTML for
validation. See C<SYNOPSIS> section for example
on how to trigger the validator with this query parameter. B<Defaults to:> C<plug_val_html>

C<validator_uri>

    validator_uri   => 'http://127.0.0.1/w3c-markup-validator/check',

B<Optional>.
Plugin accesses a W3C markup validator. The C<validator_uri> argument takes a URI pointing
to the validator. It would be REALLY GREAT if you'd download the
validator for your system and use a local version. Debian/Ubuntu users can do it
as simple as C<sudo apt-get install w3c-markup-validator>,
others see L<http://validator.w3.org/source/>. If you cannot install a local version
of the validator set C<validator_uri> to L<http://validator.w3.org/check>. B<Defaults to:>
C<http://127.0.0.1/w3c-markup-validator/check>

C<address>

    address => 'http://your.site.com/index.pl?page=/test',

B<Optional>. The plugin uses needs to fetch your page in order to get the markup to validate.
Generally you don't need to touch C<address> argument as the plugin will do its black magic
to figure out, but in case it fails you can set it or wish to validate some other page
that is not the one on which you are displaying the results, you can set the C<address>
argument that takes a string that is the URI to the page you wish to validate.

HTML::Template VARIABLES

    <tmpl_var name='plug_val_html'>
    <tmpl_var name='plug_val_html_link'>

The plugin sets two L<HTML::Template> variables in C<{t}> key; its name is what you set in
C<t_name> argument, which defaults to C<plug_val_html>.

If your HTML code is valid, this variable will be replaced with words C<HTML is valid>.
Otherwise you'll see either an error message for why validation failed or actual error
messages that explain why your HTML is invalid.

The second variable will contain a link to either turn on or turn off validation. The name
of that variable is contructed by appending C<_link> to the C<t_name> argument, thus
by default it will be C<< <tmpl_var name='plug_val_html_link'> >>

USAGE NOTES

You'd probably would want to include the plugin to execute in your Main Config File
and put the C<< <tmpl_var name=""> >> in your base template while developing the site.
Just don't forget to take it out when you done ;)

PLEASE! Install a local validator. Tons of people already accessing the one that is hosted
in C<http://w3.org>, don't make the lag worse.


=head1 App::ZofCMS::Plugin::DirTreeBrowse (version 0.0105)

NAME


Link: L<App::ZofCMS::Plugin::DirTreeBrowse>



App::ZofCMS::Plugin::DirTreeBrowse - plugin to display browseable directory tree

SYNOPSIS

SIMPLE VARIANT

In your Main Config file or ZofCMS Template:

    plugins     => [ qw/DirTreeBrowse/ ],
    plug_dir_tree => {
        auto_html => 1,
        start     => 'pics',
    },

In you L<HTML::Template> template:

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>
    <tmpl_var name='dir_tree_auto'>

MORE FLEXIBLE VARIANT

In your Main Config file or ZofCMS Template:

    plugins     => [ qw/DirTreeBrowse/ ],
    plug_dir_tree => {
        start     => 'pics',
    },

In your L<HTML::Template> template:

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>

    <ul>
        <tmpl_if name="dir_tree_back">
            <li><a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='dir_tree_back'>">UP</a></li>
        </tmpl_if>
    <tmpl_loop name='dir_tree_list'>
        <li>
            <tmpl_if name="is_file">
            <a href="/<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            <tmpl_else>
            <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            </tmpl_if>
        </li>
    </tmpl_loop>
    </ul>

DESCRIPTION

The module is an L<App::ZofCMS> plugin that provides means to display a browseable directory
three (list of files and other dirs).

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/DirTreeBrowse/ ],

First and foremost, you'd obviously would want to add the plugin into the list of plugins
to execute.

C<plug_dir_tree>

    plug_dir_tree => {
        start                  => 'pics',
        auto_html              => 'ul_class',
        re                     => qr/[.]jpg$/,
        q_name                 => 'dir_tree',
        t_prefix               => 'dir_tree_',
        display_path_separator => '/',
    }

    plug_dir_tree => sub {
        my ( $t, $q, $config ) = @_;
        return {
            start                  => 'pics',
            auto_html              => 'ul_class',
            re                     => qr/[.]jpg$/,
            q_name                 => 'dir_tree',
            t_prefix               => 'dir_tree_',
            display_path_separator => '/',
        };
    }

The C<plug_dir_tree> takes a hashref or subref as a value and can be set in either Main Config file or
ZofCMS Template file. Keys that are set in both Main Config file and ZofCMS Template file
will get their values from ZofCMS Template file. If subref is specified,
its return value will be assigned to C<plug_dir_tree> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
Possible keys/values of C<plug_dir_tree>
hashref are as follows:

C<start>

    plug_dir_tree => {
        start => 'pics',
    },

B<Mandatory>. Specifies the starting directory of the directory three you wish to browse. The
directory is relative to your C<index.pl> file and must be web-accessible.

C<auto_html>

    plug_dir_tree => {
        start       => 'pics',
        auto_html   => 'ul_class',
    },

B<Optional>. When set to a C<defined> value will cause the
plugin to generate directory tree HTML automatically, the value then will become the
classname for the C<< <ul> >> element that holds the list of files/dirs. See SYNOPSIS and
HTML::Template VARIABLES sectons for more details. B<Note:> the plugin does not append
current query to links, so if you wish to add something to the query parameters

C<re>

    plug_dir_tree => {
        start => 'pics',
        re    => qr/[.]jpg$/,
    }

B<Optional>. Takes a regex (C<qr//>) as a value. When specified only the files matching
this regex will be in the list. Note that file and its path will be matched, e.g.
C<pics/old_pics/foo.jpg>

C<q_name>

    plug_dir_tree => {
        start  => 'pics',
        q_name => 'dir_tree',
    }

B<Optional>. The plugin uses one query parameter to reference its position in the directory
tree. The C<q_name> key specifies the name of that query parameter. Unless you are using
the C<auto_html> option, make sure that your links include this query parameter along
with C<< <tmpl_var name="path"> >>. In other words, if your C<q_name> is set to C<dir_tree>
you'd make your links:
C<< <a href="/index.pl?page=/page_with_this_plugin&dir_tree=<tmpl_var escape='html' name='path'>"> >>. B<Defaults to:> C<dir_tree>

C<t_prefix>

    plug_dir_tree => {
        start    => 'pics',
        t_prefix => 'dir_tree_',
    }

B<Optional>. The C<t_prefix> specifies the prefix to use for several keys that plugin creates
in C<{t}> ZofCMS Template special key. See C<HTML::Template VARIABLES> section below for
details. B<Defaults to:> C<dir_tree_> (note the trailing underscore (C<_>))

C<display_path_separator>

    plug_dir_tree => {
        start                  => 'pics',
        display_path_separator => '/',
    }

B<Optional>. One of the C<{t}> keys generated by the plugin will contain the current
path in the directory tree. If C<display_path_separator> is specified, every C</> character
in that current path will be replaced by whatever C<display_path_separator> is set to.
B<By default> is not specified.

HTML::Template VARIABLES

The samples below assume that the plugin is run with all of its optional arguments set to
defaults.

When C<auto_html> is turned on

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>
    <tmpl_var name='dir_tree_auto'>

C<dir_tree_path>

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>

The C<< <tmpl_var name='dir_three_path'> >> variable will contain the current path in the
directory tree.

C<dir_tree_auto>

    <tmpl_var name='dir_tree_auto'>

The C<< <tmpl_var name='dir_tree_auto'> >> is available when C<auto_html> option is turned
on in the plugin. The generated HTML code would be pretty much as the C<MORE FLEXIBLE VARIANT>
section in C<SYNOPSIS> demonstrates.

When C<auto_html> is turned off

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>
    <ul>
        <tmpl_if name="dir_tree_back">
            <li><a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='dir_tree_back'>">UP</a></li>
        </tmpl_if>
    <tmpl_loop name='dir_tree_list'>
        <li>
            <tmpl_if name="is_file">
            <a href="/<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            <tmpl_else>
            <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            </tmpl_if>
        </li>
    </tmpl_loop>
    </ul>

C<dir_tree_path>

    <p>We are at: <tmpl_var escape='html' name='dir_tree_path'></p>

The C<< <tmpl_var name='dir_three_path'> >> variable will contain the current path in the
directory tree.

C<dir_tree_back>

    <tmpl_if name="dir_tree_back">
        <li><a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='dir_tree_back'>">UP</a></li>
    </tmpl_if>

The C<dir_tree_back> will be available when the user browsed to some directory inside the
C<start> directory. It will contain the path to the parent directory so the user could
traverse up the tree.

C<dir_tree_list>

    <tmpl_loop name='dir_tree_list'>
        <li>
            <tmpl_if name="is_file">
            <a href="/<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            <tmpl_else>
            <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
            </tmpl_if>
        </li>
    </tmpl_loop>

The C<dir_tree_list> will contain data structure suitable for C<< <tmpl_loop name=""> >>. Each
item of that loop would be an individual file or a directory. The variables that
are available in that loop are as follows:

C<is_file>

    <tmpl_if name="is_file">
        <a target="_blank" href="/<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
    <tmpl_else>
        <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>
    </tmpl_if>

The C<is_file> will be set whenever the item is a file (as opposed to being a directory).
As the example above shows, you'd use this variable as a C<< <tmpl_if name=""> >> to adjust
your links to open the file instead of trying to make the plugin "browse" that file as
a directory.

C<path>

    <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>

The C<path> variable will contain the path to the directory/file (including the name
of that directory/file) starting from the C<start> directory. You'd want to include that
as a value of C<q_name> query parameter so the user could traverse the dirs.

C<name>

    <a href="/index.pl?page=/&dir_tree=<tmpl_var escape='html' name='path'>"><tmpl_var escape='html' name='name'></a>

The C<name> variable will contain just the name of the file/directory without it's path. You'd
want to use this for for displaying the names of the files/dirs to the user.


=head1 App::ZofCMS::Plugin::Doctypes (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::Doctypes>



App::ZofCMS::Plugin::Doctypes - include DOCTYPEs in your pages without remembering how to spell them

SYNOPSIS

In your Main Config file:

    template_defaults => {
        plugins => [ qw/Doctypes/ ],
    },

In your L<HTML::Template> files

    <tmpl_var name="doctype HTML 4.01 Strict">

DESCRIPTION

If you are like me you definitely don't remember how to properly spell out the DOCTYPE (DOCument TYPE definition) in your pages and always rely on your editor or look it up. Well,
fear no more! This little module contains all the common DTDs and will stuff them into C<{t}>
ZofCMS template's special key for you to use.

AVAILABLE DTDs

Below are examples of C<< <tmpl_var name=""> >> that will be substituted into the actual
doctypes. The names of the doctypes correspoding to each of those examples are self
explanatory. B<Note:> the plugin has two modes (for now). The I<basic> mode is the default
one, it will make only DTDs available under L<BASIC> section. The I<extra> mode will include
more doctypes.

ENABLING 'EXTRA' MODE

B<To enable the extra mode>: in your ZofCMS template, but most likely you'd want that in your
main config file:

    plugin_doctype => { extra => 1 },

This would be the first-level key in ZofCMS template as well as main config file.

'BASIC' MODE DTDs

    <tmpl_var name="doctype HTML 4.01 Strict">
    <tmpl_var name="doctype HTML 4.01 Transitional">
    <tmpl_var name="doctype HTML 4.01 Frameset">
    <tmpl_var name="doctype XHTML 1.0 Strict">
    <tmpl_var name="doctype XHTML 1.0 Transitional">
    <tmpl_var name="doctype XHTML 1.0 Frameset">
    <tmpl_var name="doctype XHTML 1.1">

'EXTRA' MODE DTDs

    <tmpl_var name="doctype XHTML Basic 1.0">
    <tmpl_var name="doctype XHTML Basic 1.1">
    <tmpl_var name="doctype HTML 2.0">
    <tmpl_var name="doctype HTML 3.2">
    <tmpl_var name="doctype MathML 1.01">
    <tmpl_var name="doctype MathML 2.0">
    <tmpl_var name="doctype XHTML + MathML + SVG">
    <tmpl_var name="doctype SVG 1.0">
    <tmpl_var name="doctype SVG 1.1 Full">
    <tmpl_var name="doctype SVG 1.1 Basic">
    <tmpl_var name="doctype SVG 1.1 Tiny">
    <tmpl_var name="doctype XHTML + MathML + SVG Profile (XHTML as the host language)">
    <tmpl_var name="doctype XHTML + MathML + SVG Profile (Using SVG as the host)">


=head1 App::ZofCMS::Plugin::FileList (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::FileList>



App::ZofCMS::Plugin::FileList - ZofCMS plugin to display lists of files

SYNOPSIS

In your Main Config file or ZofCMS template:

    plugins     => [ qw/FileList/ ],
    plug_file_list => {
        list => {
            list1 => 'pics',
            list2 => 'pics2',
        },
    },

In your L<HTML::Template> template:

    <ul>
    <tmpl_loop name='list1'>
        <li><a href="/<tmpl_var escape='html' name='path'>"><tmpl_var name='name'></a></li>
    </tmpl_loop>
    </ul>

    <ul>
    <tmpl_loop name='list2'>
        <li><a href="/<tmpl_var escape='html' name='path'>"><tmpl_var name='name'></a></li>
    </tmpl_loop>
    </ul>

DESCRIPTION

Module is a L<App::ZofCMS> plugin which provides means to display lists of files.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE OR ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/FileList/ ],

You would definitely want to add the plugin into the list of plugins to execute :)

C<plug_file_list>

    plug_file_list => {
        name => 0,
        re   => qr/[.]jpg$/i,
        list => {
            list1 => 'pics',
            list2 => [ qw/pics2 pics3/ ],
        },
    },

    plug_file_list => {
        list => [ qw/pics pics2/ ],
    },

    plug_file_list => {
        list => 'pics',
    },

You can specify the C<plug_file_list> first-level key in either Main Config File or ZofCMS
Template file. Specifying the same keys in both will lead to the ones set in ZofCMS Template
take precedence.

The C<plug_file_list> key takes a hashref as a value. Possible keys/values of that hashref
are as follows:

C<list>

    plug_file_list => {
        list => {
            list1 => 'pics',
            list2 => [ qw/pics2 pics3/ ],
        },
    },

    plug_file_list => {
        list => [ qw/pics pics2/ ],
    },

    plug_file_list => {
        list => 'pics',
    },

The C<list> key specifies the directories in which to search for files. The value of that
key can be either a hashref, arrayref or a scalar. If the value is not a hashref it will
be converted into a hashref as follows:

    plug_file_list => {
        list => 'pics', # a scalar
    },

    # same as

    plug_file_list => {
        list => [ 'pics' ], # arrayref
    },

    # same as

    # hashref with a key that has a scalar value
    plug_file_list => {
        list => {
            plug_file_list => 'pics',
        }
    },

    # same as

    # hashref with a key that has an arrayref value
    plug_file_list => {
        list => {
            plug_file_list => [ 'pics' ],
        }
    },

The hashref assigned to C<list> (or converted from other values) takes the following meaning:
the keys of that hashref are the names of the keys in C<{t}> ZofCMS Template special key
and the values are the lists (arrayrefs) of directories in which to search for files.
See SYNOPSIS section for some examples. Note that default C<{t}> key would be C<plug_file_list>
as is shown in conversion examples above.

C<re>

    plug_file_list => {
        re   => qr/[.]jpg$/i,
        list => 'pics',
    },

B<Optional>. The C<re> argument takes a regex as a value (C<qr//>). If specified only the files
that match the regex will be listed. B<By default> is not specified.

C<name>

    plug_file_list => {
        name => 0,
        list => 'foo',
    },

B<Optional>. Takes either true or false values,
specifies whether or not to create the C<name> C<< <tmpl_var name=""> >> in the
output. See C<HTML::Template TEMPLATES> section below. B<Defaults to:> C<1> (*do* create)

HTML::Template TEMPLATES

In HTML::Template templates you'd show the file lists in the following fashion:

    <ul>
    <tmpl_loop name='plug_file_list'>
        <li><a href="/<tmpl_var escape='html' name='path'>"><tmpl_var name='name'></a></li>
    </tmpl_loop>
    </ul>

The name of the C<< <tmpl_loop name=""> >> is what you specified (directly or indirectly)
as keys in the C<list> hashref (see above). Inside the loop there are two
C<< <tmpl_var name=""> >> that you can use:

C<< <tmpl_var name='path'> >>

The C<< <tmpl_var name='path'> >> will contain the path to the file, that is the directory
you specified . '/' . file name.

C<< <tmpl_var name='name'> >>

The C<< <tmpl_var name='path'> >> (providing the C<name> key in C<plug_file_list> hashref
is set to a true value) will contain just the filename of the file.


=head1 App::ZofCMS::Plugin::FileToTemplate (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::FileToTemplate>



App::ZofCMS::Plugin::FileToTemplate - read or do() files into ZofCMS Templates

SYNOPSIS

In your ZofCMS Template:

    plugins => [ qw/FileToTemplate/ ],
    t  => {
        foo => '<FTTR:index.tmpl>',
    },

In you L<HTML::Template> template:

    <tmpl_var escape='html' name='foo'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS>; it provides functionality to either read (slurp)
or C<do()> files and stick them in place of "tags".. read on to understand more.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

ADDING THE PLUGIN

    plugins => [ qw/FileToTemplate/ ],

Unlike many other plugins to run this plugin you barely need to include it in the list of
plugins to execute.

TAGS

    t  => {
        foo => '<FTTR:index.tmpl>',
        bar => '<FTTD:index.tmpl>',
    },

Anywhere in your ZofCMS template you can use two "tags" that this plugin provides. Those
"tags" will be replaced - depending on the type of tag - with either the contents of the file
or the last value returned by the file.

Both tags are in format: opening angle bracket, name of the tag in capital letters, semicolon,
filename, closing angle bracket. The filename is relative to your "templates" directory, i.e.
the directory referenced by C<templates> key in Main Config file.

C<< <FTTR:filename> >>

    t  => {
        foo => '<FTTR:index.tmpl>',
    },

The C<< <FTTR:filename> >> reads (slurps) the contents of the file and tag is replaced
with those contents. You can have several of these tags as values. Be careful reading in
large files with this tag. Mnemonic: B<F>ile B<T>o B<T>emplate B<R>ead.

C<< <FTTD:filename> >>

    t => {
        foo => '<FTTD:index.tmpl>',
    },

The C<< <FTTD:filename> >> tag will C<do()> your file and the last returned value will be
assigned to the B<value in which the tag appears>, in other words, having
C<< foo => '<FTTD:index.tmpl>', >> and C<< foo => '<FTTD:index.tmpl> blah blah blah', >>
is the same. Using this tag, for example, you can add large hashrefs or config hashrefs
into your templates without clobbering them. Note that if the C<do()> cannot find your file
or compilation of the file fails, the value with the tag will be replaced by the error message.
Mnemomic: B<F>ile B<T>o B<T>emplate B<D>o.

NON-CORE PREREQUISITES

The plugin requires one non-core module: L<Data::Transformer>


=head1 App::ZofCMS::Plugin::FileTypeIcon (version 0.0105)

NAME


Link: L<App::ZofCMS::Plugin::FileTypeIcon>



App::ZofCMS::Plugin::FileTypeIcon - present users with pretty icons depending on file type

SYNOPSIS

# first of all, get icon images (they are also in the examples/ dir of this distro)

    wget http://zoffix.com/new/fileicons.tar.gz;tar -xvvf fileicons.tar.gz;rm fileicons.tar.gz;

In your ZofCMS Template or Main Config File:

    plug_file_type_icon => {
        files => [  # mandatory
            qw/ foo.png bar.doc beer.pdf /,
            sub {
                my ( $t, $q, $conf ) = @_;
                return 'meow.wmv';
            },
        ],
        # all the defaults for reference:
        resource    => 'pics/fileicons/',
        prefix      => 'fileicon_',
        as_arrayref => 0, # put all files into an arrayref at $t->{t}{ $prefix }
        only_path   => 0, # i.e. do not generate the <img> element
        icon_width  => 16,
        icon_height => 16,
        code_after  => sub {
            my ( $t, $q, $conf ) = @_;
            die "Weeee";
        },
        xhtml       => 0,
    },

In your L<HTML::Template> file:

    <tmpl_var name='fileicon_0'>
    <tmpl_var name='fileicon_1'>
    <tmpl_var name='fileicon_2'>
    <tmpl_var name='fileicon_3'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides a method to show pretty little icons
that vary depending on the extension of the file (which is just a string as far as the module
is concerned).

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

GETTING THE IMAGES FOR THE ICONS

There are 69 icons plus the "unknown file" icon in an archive that is in examples/ directory
of this distribution. You can also get it from my website:

    wget http://zoffix.com/new/fileicons.tar.gz;
    tar -xvvf fileicons.tar.gz;
    rm fileicons.tar.gz;

As well as the original website from where I got them:
L<http://www.splitbrain.org/projects/file_icons>

Alternatively, you may want to draw your own icons; in that case, the filenames for the icons
are made out as C<$lowercase_filetype_extension.png>.
If you draw some icons yourself and would like to share, feel free to email them to me
at C<zoffix@cpan.org>. 

These images would obviously need to be placed in web-accessible directory on your website.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/FileTypeIcon/ ],

You obviously need to include the plugin in the list of plugins to execute. You're likely
to use this plugin with some other plugins, so make sure to get priority right.

C<plug_file_type_icon>

    plug_file_type_icon => {
        files => [  # mandatory
            qw/ foo.png bar.doc beer.pdf /,
            sub {
                my ( $t, $q, $conf ) = @_;
                return 'meow.wmv';
            },
        ],
        # all the defaults for reference:
        resource    => 'pics/fileicons/',
        prefix      => 'fileicon_',
        as_arrayref => 0, # put all files into an arrayref at $t->{t}{ $prefix }
        only_path   => 0, # i.e. do not generate the <img> element
        icon_width  => 16,
        icon_height => 16,
        code_after  => sub {
            my ( $t, $q, $conf ) = @_;
            die "Weeee";
        },
        xhtml       => 0,
    },

    # or set config via a subref
    plug_file_type_icon => sub {
        my ( $t, $q, $config ) = @_;
        return {
            files => [
                qw/ foo.png bar.doc beer.pdf /,
            ],
        };
    },

Plugin won't run if C<plug_file_type_icon> is not set or its C<files> key does not contain
any files. The C<plug_file_type_icon> first-level key takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_file_type_icon> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. The
keys of this hashref can be set in either ZofCMS Template or Main Config Files; keys that are
set in both files will take their values from ZofCMS Template file. The following keys/values
are valid in C<plug_file_type_icon>:

C<files>

    files => [
        qw/ foo.png bar.doc beer.pdf /,
        { 'beer.doc' => 'doc_file' },
        sub {
            my ( $t, $q, $conf ) = @_;
            return 'meow.wmv';
        },
    ],

B<Mandatory>. The C<files> key takes either an arrayref, a subref or a hashref as a value.
If its value is B<NOT> an arrayref, then it will be converted to an arrayref with just one
element - the original value.

The elements of C<files> arrayref can be strings, hashrefs or subrefs. If the value is a
subref, the sub will be executed and its return value will replace the subref. The
C<@_> of the sub will contain C<$t, $q, $conf> (in that order) where C<$t> is ZofCMS Template
hashref, C<$q> is a hashref of query parameters and C<$conf> is L<App::ZofCMS::Config> object.

If the element is a hashref, it must contain only one key/value pair and the key will be
treated as a filename to process and the value will become the name of the key in C<t> ZofCMS
special key (see C<prefix> key below). If the element is a regular string, then it will be
treated as a filename to process.

C<resource>

    resource => 'pics/fileicons/',

B<Optional>. Specifies the path to directory with icon images. Must be relative to C<index.pl>
file and web-accessible, as this path will be used in generating path/filenames to the icons.
B<Defaults to:> C<pics/fileicons/>

C<prefix>

    prefix => 'fileicon_',

B<Optional>. When the plugin generates path to the icon or the C<< <img> >> element, it
will stick it into C<t> ZofCMS special key. The C<prefix> key takes a string as a value and
specifies the prefix to use for keys in C<t> ZofCMS special key. If C<as_arrayref> key
(see below) is set to a true value, then C<prefix> will specify the name of the key, in
C<t> ZofCMS special key where to store that arrayref. When the element of C<files> arrayref
is a hashref, the value of the only key in that hashref will become the name of the
key in C<t> special key B<WITHOUT> the C<prefix>; otherwise, the name will be constructed
by using C<prefix> and a counter; the elements of C<files> arrayref that are hashrefs do
not increase that counter. B<Defaults to:> C<fileicon_> (note that underscore at the end)

C<as_arrayref>

    as_arrayref => 0,

B<Optional>. Takes either true or false values.
When set to a true value, the plugin will create an arrayref of generated
C<< <img> >> elements (or just paths) and stick it in C<t> special key under C<prefix> (see above) key. B<Defaults to:> C<0>

C<only_path>

    only_path   => 0,

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
not generate the code for C<< <img> >> elements, but instead it will only provide paths
to appropriate icon image. B<Defaults to:> C<0>

C<icon_width> and C<icon_height>

    icon_width  => 16,
    icon_height => 16,

B<Optional>. All the icon images to which I referred you above are sized 16px x 16px. If you
are creating your own icons, use C<icon_width> and C<icon_height> keys to set proper
dimensions. You cannot set different sizes for individual icons, but you can use
C<Image::Size> in the C<code_after> sub (see below). B<Defaults to:> C<16> (for both)

C<code_after>

    code_after => sub {
        my ( $t, $q, $conf ) = @_;
        die "Weeee";
    },

B<Optional>. Takes a subref as a value, this subref will be run after all filenames in
C<files> arrayref have been processed. The C<@_> will contain (in that order) C<$t, $q, $conf>
where C<$t> is ZofCMS Template hashref, C<$q> is hashref of query parameters and
C<$conf> is L<App::ZofCMS::Config> object. B<By defaults:> is not specified.

C<xhtml>

    xhtml => 0,

B<Optional>. If you wish to close C<< <img> >> elements as to when you're writing XHTML, then
set C<xhtml> argument to a true value. B<Defaults to:> C<0>

GENERATED HTML CODE

The plugin generates the following HTML code:

<img class="file_type_icon" src="pics/fileicons/png.png" width="16" height="16" alt="PNG file" title="PNG file">


=head1 App::ZofCMS::Plugin::FileUpload (version 0.0114)

NAME


Link: L<App::ZofCMS::Plugin::FileUpload>



App::ZofCMS::Plugin::FileUpload - ZofCMS plugin to handle file uploads

SYNOPSIS

In your ZofCMS template:

    file_upload => {
        query   => 'uploaded_file',
    },
    plugins => [ qw/FileUpload/ ],

In your L<HTML::Template> template:

    <tmpl_if name="upload_error">
        <p class="error">Upload failed: <tmpl_var name="upload_error">
    </tmpl_if>
    <tmpl_if name="upload_success">
        <p>Upload succeeded: <tmpl_var name="upload_filename"></p>
    </tmpl_if>

    <form action="" method="POST" enctype="multipart/form-data">
    <div>
        <input type="file" name="uploaded_file">
        <input type="submit" value="Upload">
    </div>
    </form>

DESCRIPTION

The module is a ZofCMS plugin which provides means to easily handle file
uploads.

This documentation assumes you've read
L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    plugins => [ qw/FileUpload/ ],

First and obvious, you need to stick C<FileUpload> in the list of your
plugins.

C<file_upload>

    file_upload => {
        query   => 'upload',
        path    => 'zofcms_upload',
        name    => 'foos',
        ext     => '.html',
        content_type => 'text/html',
        on_success => sub {
            my ( $uploaded_file_name, $template, $query, $conf ) = @_;
            # do something useful
        }
    },

    # or

    file_upload => [
        { query   => 'upload1', },
        { query   => 'upload2', },
        {}, # all the defaults
        {
            query   => 'upload4',
            name    => 'foos',
            ext     => '.html',
            content_type => 'text/html',
            on_success => sub {
                my ( $uploaded_file_name, $template, $query, $conf ) = @_;
                # do something useful
            }
        },
    ],

Plugin takes input from C<file_upload> first level ZofCMS template key which
takes an arrayref or a hashref as a value. Passing a hashref as a value
is the same as passing an arrayref with just that hashref as an element.
Each element of the given arrayref is a hashref which
represents one file upload. The possible keys/values of those hashrefs
are as follows:

C<query>

    { query => 'zofcms_upload' },

B<Optional>. Specifies the query parameter which is the file being uploaded,
in other words, this is the value of the C<name=""> attribute of the
C<< <input type="file"... >>. B<Defaults to:> C<zofcms_upload>

C<path>

    { path => 'zofcms_upload', }

B<Optional>. Specifies directory (relative to C<index.pl>) into which
the plugin will store uploaded files. B<Defaults to:> C<zofcms_upload>

C<name>

    { name => 'foos', }
    
    { name => '[rand]', }
    
    { name => \1 } # any scalar ref
    
    {
        name => sub {
            my ( $t, $q, $config ) = @_;
            return 'file_name.png';
        },
    }

B<Optional>. Specifies the name (without the extension)
of the local file into which save the uploaded file. Special value of
C<[rand]> specifies that the name should be random, in which case it
will be created by calling C<rand()> and C<time()> and removing any dots
from the concatenation of those two. If a I<scalarref> is specified
(irrelevant of its value), the plugin will use the filename that the
browser gave it (relying on L<File::Spec::Functions>'s
C<splitpath> here; also, note that extension will be obtained
using C<ext> argument (see below). The C<name> parameter can also take
a subref, if that's the case, then the C<name> parameter will obtain
its value from the return value of that subref. The subref's C<@_> will
contain the following (in that order): ZofCMS Template hashref, hashref
of query parameters and L<App::ZofCMS::Config> object.
B<Defaults to:> C<[rand]>

C<ext>

    { ext => '.html', }

B<Optional>. Specifies the extension to use for the name of local file
into which the upload will be stored. B<By default> is not specified
and therefore the extension will be obtained from the name of the remote
file.

C<name_filter>

    { name_filter => qr/Z(?!ofcms)/i, }

B<Optional>. Takes a regex ref (C<qr//>) as a value. Anything
in the C<path> + C<name> + C<ext> final string (regardles of how each
of those is obtained) that matches this regex
will be stripped. B<By default> is not specified.

C<content_type>

    { content_type => 'text/html', }

    { content_type => [ 'text/html', 'image/jpeg' ], }

B<Optional>. Takes either a scalar string or an arrayref of strings.
Specifying a string is equivalent to specifying an arrayref with just that
string as an element. Each element of the given arrayref indicates the
allowed Content-Type of the uploaded files. If the Content-Type does
not match allowed types the error will be shown (see HTML TEMPLATE VARS
section below). B<By default> all Content-Types are allowed.

C<on_success>

    on_success => sub {
        my ( $uploaded_file_name, $template, $query, $config ) = @_;
        # do something useful
    }

B<Optional>. Takes a subref as a value. The specified sub will be
executed upon a successful upload. The C<@_> will contain the following
elements: C<$uploaded_file_name, $template, $query, $config> where
C<$uploaded_file_name> is the directory + name + extension of the local
file into which the upload was stored, C<$template> is a hashref of
your ZofCMS template, C<$query> is a hashref of query parameters and
C<$config> is the L<App::ZofCMS::Config> object. B<By default> is not
specified.

HTML TEMPLATE VARS

Single upload:

    <tmpl_if name="upload_error">
        <p class="error">Upload failed: <tmpl_var name="upload_error">
    </tmpl_if>
    <tmpl_if name="upload_success">
        <p>Upload succeeded: <tmpl_var name="upload_filename"></p>
    </tmpl_if>

    <form action="" method="POST" enctype="multipart/form-data">
    <div>
        <input type="file" name="upload">
        <input type="submit" value="Upload">
    </div>
    </form>

Multi upload:

    <tmpl_if name="upload_error0">
        <p class="error">Upload 1 failed: <tmpl_var name="upload_error0">
    </tmpl_if>
    <tmpl_if name="upload_success0">
        <p>Upload 1 succeeded: <tmpl_var name="upload_filename0"></p>
    </tmpl_if>

    <tmpl_if name="upload_error1">
        <p class="error">Upload 2 failed: <tmpl_var name="upload_error1">
    </tmpl_if>
    <tmpl_if name="upload_success1">
        <p>Upload 2 succeeded: <tmpl_var name="upload_filename1"></p>
    </tmpl_if>

    <form action="" method="POST" enctype="multipart/form-data">
    <div>
        <input type="file" name="upload">
        <input type="file" name="upload2">
        <input type="submit" value="Upload">
    </div>
    </form>

B<NOTE:> upload of multiple files from a single C<< <input type="file"... >>
is currently not supported. Let me know if you need such functionality.
The folowing C<< <tmpl_var name=""> >>s will be set in your
L<HTML::Template> template.

SINGLE AND MULTI 

If you are handling only one upload, i.e. you have only one hashref in
C<file_upload> ZofCMS template key and you have only one
C<< <input type="file"... >> then the HTML::Template variables described
below will B<NOT> have any trailing numbers, otherwise each of them
will have a trailing number indicating the number of the upload. This number
will starts from B<zero> and it will correspond to the index of hashref of
C<file_upload> arrayref.

C<upload_error>

    # single
    <tmpl_if name="upload_error">
        <p class="error">Upload failed: <tmpl_var name="upload_error">
    </tmpl_if>

    # multi
    <tmpl_if name="upload_error0">
        <p class="error">Upload 1 failed: <tmpl_var name="upload_error0">
    </tmpl_if>

The C<upload_error> will be set if some kind of an error occurred during
the upload of the file. This also includes if the user tried to upload
a file of type which is not listed in C<content_type> arrayref.

C<upload_success>

    # single
    <tmpl_if name="upload_success">
        <p>Upload succeeded: <tmpl_var name="upload_filename"></p>
    </tmpl_if>

    # multi
    <tmpl_if name="upload_success0">
        <p>Upload 1 succeeded: <tmpl_var name="upload_filename0"></p>
    </tmpl_if>

The C<upload_success> will be set to a true value upon successful upload.

C<upload_filename>

    # single
    <tmpl_if name="upload_success">
        <p>Upload succeeded: <tmpl_var name="upload_filename"></p>
    </tmpl_if>

    # multi
    <tmpl_if name="upload_success0">
        <p>Upload 1 succeeded: <tmpl_var name="upload_filename0"></p>
    </tmpl_if>

The C<upload_filename> will be set to directory + name + extension of the
local file into which the upload was saved.


=head1 App::ZofCMS::Plugin::FloodControl (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::FloodControl>



App::ZofCMS::Plugin::FloodControl - plugin for protecting forms and anything else from floods (abuse)

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plug_flood_control => {
        dsn             => "DBI:mysql:database=test;host=localhost",
        user            => 'test',
        pass            => 'test',
        # everything below is optional
        opt             => { RaiseError => 1, AutoCommit => 1 }, 
        create_table    => 0, 
        limit           => 2,
        timeout         => 600,
        table           => 'flood_control',
        run             => 0,
        trigger         => 'plug_flood',
        cell            => 'q',
        t_key           => 'plug_flood',
        flood_id        => 'flood',
        flood_code      => sub {
            my ( $template, $query, $config ) = @_;
            kill_damn_flooders();
        },
        no_flood_code   => sub {
            my ( $template, $query, $config ) = @_;
            hug_the_user();
        },
    }

In your L<HTML::Template> Template:

    <tmpl_if name='plug_flood'>
        STOP FLOODING, ASSHOLE!
    <tmpl_else>
        <form ....
        .../form>
    </tmpl_if>

Plugin needs an SQL table to operate. You can either create it by hand or set the
C<create_table> option to a true value once so plugin could create the table automatically.
The needed table needs to have these three columns:

    CREATE TABLE flood_table (host VARCHAR(250), time VARCHAR(10), id VARCHAR(5));

The value type of the C<id> column can be different depending on what C<flood_id> arguments
you'd use (see docs below for more).

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to detect flood (abuse) and
react accordingly depending on whether or not flood was detected.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/FloodControl/ ],

You obviously need to the add the plugin in the list of plugins to execute. Along with this
plugin you would probably want to use something like L<App::ZofCMS::Plugin::FormChecker>
and L<App::ZofCMS::Plugin::DBI>

C<plug_flood_control>

    plug_flood_control => {
        dsn             => "DBI:mysql:database=test;host=localhost",
        user            => 'test',
        pass            => 'test',
        # everything below is optional
        opt             => { RaiseError => 1, AutoCommit => 1 }, 
        create_table    => 0, 
        limit           => 2,
        timeout         => 600,
        table           => 'flood_control',
        run             => 0,
        trigger         => 'plug_flood',
        cell            => 'q',
        t_key           => 'plug_flood',
        flood_id        => 'flood',
        flood_code      => sub {
            my ( $template, $query, $config ) = @_;
            kill_damn_flooders();
        },
        no_flood_code   => sub {
            my ( $template, $query, $config ) = @_;
            hug_the_user();
        },
    }

    plug_flood_control => sub {
        my ( $t, $q, $config ) = @_;
        return {
            dsn             => "DBI:mysql:database=test;host=localhost",
            user            => 'test',
            pass            => 'test',
        };
    }

Plugin uses C<plug_flood_control> first-level key that can be specified in either (or both)
Main Config File or ZofCMS Template file. The key takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_flood_control> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. If the keys of
that hashref are specified in both files will take their values from ZofCMS Template.
Most of these keys are optional with sensible defaults. Possible keys/values are as follows:

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Specifies the "DSN" for L<DBI> module. See L<DBI>'s docs for C<connect_cached()>
method for more info on this one.

C<user>

    user => 'test',

B<Mandatory>. Specifies your username for the SQL database.

C<pass>

    pass => 'test',

B<Mandatory>. Specifies your password for the SQL database.

C<opt>

    opt => { RaiseError => 1, AutoCommit => 1 },

B<Optional>. Takes a hashref as a value. Specifies the additional options for L<DBI>'s
C<connect_cached()> method. See L<DBI>'s docs for C<connect_cached()>
method for more info on this one. B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 } >>

C<table>

    table => 'flood_control',

B<Optional>. Takes a string as a value that represents the name of the table in which to
store flood data. B<Defaults to:> C<flood_control>

C<create_table>

    create_table => 0,

B<Optional>. Takes either true or false values. When set to a true value will automatically
create the table that is needed for the plugin. You can create the table manually, its
format is described in the C<SYNOPSIS> section above. B<Defaults to:> C<0>

C<limit>

    limit => 2,

B<Optional>. Specifies the "flood limit". Takes a positive integer value that
is the number of times the plugin will be
triggered in C<timeout> (see below) seconds before it will think we are being abused.
B<Defaults to:> C<2>

C<timeout>

    timeout => 600,

B<Optional>. Takes a positive integer value. Specifies timeout in seconds after which
the plugin will forget that a certain user triggered it. In other words, if the plugin is
triggered when someone submits the form and C<timeout> is set to C<600> and C<limit> is set
to C<2> then the user would be able to submit the form only twice every 10 minutes.
B<Defaults to:> C<600>

C<trigger>

    trigger => 'plug_flood',

B<Optional>. Takes a string as a value that names the key in a C<cell> (see below).
Except for when the C<cell> is set to C<q>, the value referenced by the key must contain
a true value in order for the plugin to trigger (to run). B<Defaults to:> C<plug_flood>

C<cell>

    cell => 'q',

B<Optional>. The plugin can be triggered either from query, C<{t}> special key, C<{d}>
ZofCMS Template special key, or any first-level ZofCMS Template key (also, see C<run>
option below). The value of the C<cell> key specifies where the plugin will look for the
C<trigger> (see above). Possible values for C<cell> key are: C<q> (query), C<d> (C<{d}> key),
C<t> (C<{t}> key) or empty string (first-level ZofCMS Template key). For every C<cell> value
but the C<q>, the trigger (i.e. the key referenced by the C<trigger> argument) must be set
to a true value in order for the plugin to trigger. When C<cell> is set to value C<q>, then
the query parameter referenced by C<trigger> must have C<length()> in order for the plugin
to trigger. B<Defaults to:> C<q>

C<run>

    run => 0,

B<Optional>. An alternative to using C<cell> and C<trigger> arguments you can set
(e.g. dynamically with some other plugin) the C<run> argument to a true value. Takes
either true or false values. When set to a true value plugin will "trigger" (check for floods)
without any consideration to C<cell> and C<trigger> values. B<Defaults to:> C<0>

C<t_key>

    t_key => 'plug_flood',

B<Optional>. If plugin sees that the user is flooding, it will set C<t_key> in ZofCMS Template
C<{t}> special key. Thus you can display appropriate messages using C<< <tmpl_if name=""> >>.
B<Defaults to:> C<plug_flood>

C<flood_id>

    flood_id => 'flood',

B<Optional>. You can use the same table to control various pages or forms from flood
independently by setting C<flood_id> to different values for each of them. B<Defaults to:>
C<flood>

C<flood_code>

    flood_code => sub {
        my ( $template, $query, $config ) = @_;
        kill_damn_flooders();
    },

B<Optional>. Takes a subref as a value. This sub will be run if plugin thinks that the user
is flooding. The C<@_> will contain (in that order) ZofCMS Template hashref, query parameters
hashref where keys are params' names and values are their values and L<App::ZofCMS::Config>
object. B<By default> is not specified.

C<no_flood_code>

    no_flood_code   => sub {
        my ( $template, $query, $config ) = @_;
        hug_the_user();
    },

B<Optional>. Takes a subref as a value. This is the opposite of C<flood_code>.
This sub will be run if plugin thinks that the user
is B<NOT> flooding.
The C<@_> will contain (in that order) ZofCMS Template hashref, query parameters
hashref where keys are params' names and values are their values and L<App::ZofCMS::Config>
object. B<By default> is not specified.


=head1 App::ZofCMS::Plugin::FormChecker (version 0.0341)

NAME


Link: L<App::ZofCMS::Plugin::FormChecker>



App::ZofCMS::Plugin::FormChecker - plugin to check HTML form data.

SYNOPSIS

In ZofCMS template or main config file:

    plugins => [ qw/FormChecker/ ],
    plug_form_checker => {
        trigger     => 'some_param',
        ok_key      => 't',
        ok_code     => sub { die "All ok!" },
        fill_prefix => 'form_checker_',
        rules       => {
            param1 => 'num',
            param2 => qr/foo|bar/,
            param3 => [ qw/optional num/ ],
            param4 => {
                optional        => 1,
                select          => 1,
                must_match      => qr/foo|bar/,
                must_not_match  => qr/foos/,
                must_match_error => 'Param4 must contain either foo or bar but not foos',
                param           => 'param2',
            },
            param5 => {
                valid_values        => [ qw/foo bar baz/ ],
                valid_values_error  => 'Param5 must be foo, bar or baz',
            },
            param6 => sub { time() % 2 }, # return true or false values
        },
    },

In your L<HTML::Template> template:

    <tmpl_if name="plug_form_checker_error">
        <p class="error"><tmpl_var name="plug_form_checker_error"></p>
    </tmpl_if>

    <form ......

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides nifteh form checking.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

ZofCMS TEMPLATE/MAIN CONFIG FILE FIRST LEVEL KEYS

The keys can be set either in ZofCMS template or in Main Config file, if same keys
are set in both, then the one in ZofCMS template takes precedence.

C<plugins>

    plugins => [ qw/FormChecker/ ],

You obviously would want to include the plugin in the list of plugins to execute.

C<plug_form_checker>

    # keys are listed for demostrative purposes,
    # some of these don't make sense when used together
    plug_form_checker => {
        trigger     => 'plug_form_checker',
        ok_key      => 'd',
        ok_redirect => '/some-page',
        fail_code   => sub { die "Not ok!" },
        ok_code     => sub { die "All ok!" },
        no_fill     => 1,
        fill_prefix => 'plug_form_q_',
        rules       => {
            param1 => 'num',
            param2 => qr/foo|bar/,
            param3 => [ qw/optional num/ ],
            param4 => {
                optional        => 1,
                select          => 1,
                must_match      => qr/foo|bar/,
                must_not_match  => qr/foos/,
                must_match_error => 'Param4 must contain either foo or bar but not foos',
            },
            param5 => {
                valid_values        => [ qw/foo bar baz/ ],
                valid_values_error  => 'Param5 must be foo, bar or baz',
            },
            param6 => sub { time() % 2 }, # return true or false values
        },
    },

The C<plug_form_checker> first-level key takes a hashref as a value. Only the
C<rules> key is mandatory, the rest are optional. The possible
keys/values of that hashref are as follows.

C<trigger>

    trigger => 'plug_form_checker',

B<Optional>. Takes a string as a value that must contain the name of the query
parameter that would trigger checking of the form. Generally, it would be some
parameter of the form you are checking (that would always contain true value, in perl's sense
of true) or you could always use
C<< <input type="hidden" name="plug_form_checker" value="1"> >>. B<Defaults to:>
C<plug_form_checker>

C<ok_key>

    ok_key => 'd',

B<Optional>. If the form passed all the checks plugin will set a B<second level>
key C<plug_form_checker_ok> to a true value. The C<ok_key> parameter specifies the
B<first level> key in ZofCMS template where to put the C<plug_form_checker> key. For example,
you can set C<ok_key> to C<'t'> and then in your L<HTML::Template> template use
C<< <tmpl_if name="plug_form_checker_ok">FORM OK!</tmpl_if> >>... but, beware of using
the C<'t'> key when you are also using L<App::ZofCMS::QueryToTemplate> plugin, as someone
could avoid proper form checking by passing fake query parameter. B<Defaults to:>
C<d> ("data" ZofCMS template special key).

C<ok_redirect>

    ok_redirect => '/some-page',

B<Optional>. If specified, the plugin will automatically redirect the user to the
URL specified as a value to C<ok_redirect> key. Note that the plugin will C<exit()> right
after printing the redirect header. B<By default> not specified.

C<ok_code>

    ok_code => sub {
        my ( $template, $query, $config ) = @_;
        $template->{t}{foo} = "Kewl!";
    }

B<Optional>. Takes a subref as a value. When specfied that subref will be executed if the
form passes all the checks. The C<@_> will contain the following (in that order):
hashref of ZofCMS Template, hashref of query parameters and L<App::ZofCMS::Config> object.
B<By default> is not specified. Note: if you specify C<ok_code> B<and> C<ok_redirect> the
code will be executed and only then user will be redirected.

C<fail_code>

    fail_code => sub {
        my ( $template, $query, $config, $error ) = @_;
        $template->{t}{foo} = "We got an error: $error";
    }

B<Optional>. Takes a subref as a value. When specfied that subref will be executed if the
form fails any of the checks. The C<@_> will contain the following (in that order):
hashref of ZofCMS Template, hashref of query parameters, L<App::ZofCMS::Config> object and
(if the C<all_errors> is set to a false value) the scalar contain the error that would
also go into C<{t}{plug_form_checker_error}> in
ZofCMS template; if C<all_errors> is set to a true value, than C<$error> will be an arrayref
of hashrefs that have only one key - C<error>, value of which is the error message.
B<By default> is not specified.

C<all_errors>

    all_errors => 1,

B<Optional>. Takes either true or false values. When set to a false value plugin will
stop processing as soon as it finds the first error and will report it to the user. When
set to a true value will find all errors and report all of them; see C<HTML::Template
VARIABLES> section below for samples. B<Defaults to:> C<0>

C<no_fill>

    no_fill => 1,

B<Optional>. When set to a true value plugin will not fill query values. B<Defaults to:> C<0>.
When C<no_fill> is set to a B<false> value the plugin will fill in
ZofCMS template's C<{t}> special key with query parameter values (only the ones that you
are checking, though, see C<rules> key below). This allows you to fill your form
with values that user already specified in case the form check failed. The names
of the keys inside the C<{t}> key will be formed as follows:
C<< $prefix . $query_param_name >> where C<$prefix> is the value of C<fill_prefix> key
(see below) and C<$query_param_name> is the name of the query parameter.
Of course, this alone wouldn't cut it for radio buttons or C<< <select> >>
elements. For that, you need to set C<< select => 1 >> in the ruleset for that particular
query parameter (see C<rules> key below); when C<select> rule is set to a true value then
the names of the keys inside the C<{t}> key will be formed as follows:
C<< $prefix . $query_param_name . '_' . $value >>. Where the C<$prefix> is the value
of C<fill_prefix> key, C<$query_param_name> is the name of the query parameter; following
is the underscore (C<_>) and then C<$value> that is the value of the query parameter. Consider
the following snippet in ZofCMS template and corresponding L<HTML::Template> HTML code as
an example:

    plug_form_checker => {
        trigger => 'foo',
        fill_prefix => 'plug_form_q_',
        rules => { foo => { select => 1 } },
    }

    <form action="" method="POST">
        <input type="text" name="bar" value="<tmpl_var name="plug_form_q_">">
        <input type="radio" name="foo" value="1"
            <tmpl_if name="plug_form_q_foo_1"> checked </tmpl_if>
        >
        <input type="radio" name="foo" value="2"
            <tmpl_if name="plug_form_q_foo_2"> checked </tmpl_if>
        >
    </form>

C<fill_prefix>

    fill_prefix => 'plug_form_q_',

B<Optional>. Specifies the prefix to use for keys in C<{t}> ZofCMS template special key
when C<no_fill> is set to a false value. The "filling" is described above in C<no_fill>
description. B<Defaults to:> C<plug_form_q_> (note the underscore at the very end)

C<rules>

        rules       => {
            param1 => 'num',
            param2 => qr/foo|bar/,
            param3 => [ qw/optional num/ ],
            param4 => {
                optional        => 1,
                select          => 1,
                must_match      => qr/foo|bar/,
                must_not_match  => qr/foos/,
                must_match_error => 'Param4 must contain either foo or bar but not foos',
            },
            param5 => {
                valid_values        => [ qw/foo bar baz/ ],
                valid_values_error  => 'Param5 must be foo, bar or baz',
            },
            param6 => sub { time() % 2 }, # return true or false values
        },

This is the "heart" of the plugin, the place where you specify the rules for checking.
The C<rules> key takes a hashref or a subref as a value. If the value is a subref,
its C<@_> will contain (in that order) ZofCMS Template hashref, query parameters hashref
and L<App::ZofCMS::Config> object. The return value of the subref will be assigned
to C<rules> parameter and therefore must be a hashref; alternatively the sub may
return an C<undef>, in which case the plugin will stop executing.

The keys of C<rules> hashref are the names
of the query parameters that you wish to check. The values of those keys are the
"rulesets". The values can be either a string, regex (C<qr//>), arrayref, subref, scalarref
or a hashref;
If the value is NOT a hashref it will be changed into hashref
as follows (the actual meaning of resulting hashrefs is described below):

a string

    param => 'num',
    # same as
    param => { num => 1 },

a regex

    param => qr/foo/,
    # same as
    param => { must_match => qr/foo/ },

an arrayref

    param => [ qw/optional num/ ],
    # same as
    param => {
        optional => 1,
        num      => 1,
    },

a subref

    param => sub { time() % 2 },
    # same as
    param => { code => sub { time() % 2 } },

a scalarref

    param => \'param2',
    # same as
    param => { param => 'param2' },

C<rules> RULESETS

The rulesets (values of C<rules> hashref) have keys that define the type of the rule and
value defines diffent things or just indicates that the rule should be considered.
Here is the list of all valid ruleset keys:

    rules => {
        param => {
            name            => 'Parameter', # the name of this param to use in error messages
            num             => 1, # value must be numbers-only
            optional        => 1, # parameter is optional
            either_or       => [ qw/foo bar baz/ ], # param or foo or bar or baz must be set
            must_match      => qr/foo/, # value must match given regex
            must_not_match  => qr/bar/, # value must NOT match the given regex
            max             => 20, # value must not exceed 20 characters in length
            min             => 3,  # value must be more than 3 characters in length
            valid_values    => [ qw/foo bar baz/ ], # value must be one from the given list
            code            => sub { time() %2 }, # return from the sub determines pass/fail
            select          => 1, # flag for "filling", see no_fill key above
            param           => 'param1',
            num_error       => 'Numbers only!', # custom error if num rule failed
            mandatory_error => '', # same for if parameter is missing and not optional.
            must_match_error => '', # same for must_match rule
            must_not_match_error => '', # same for must_not_match_rule
            max_error            => '', # same for max rule
            min_error            => '', # same for min rule
            code_error           => '', # same for code rule
            either_or_error      => '', # same for either_or rule
            valid_values_error   => '', # same for valid_values rule
            param_error          => '', # same fore param rule
        },
    }

You can mix and match the rules for perfect tuning.

C<name>

    name => 'Decent name',

This is not actually a rule but the text to use for the name of the parameter in error
messages. If not specified the actual parameter name - on which C<ucfirst()> will be run -
will be used.

C<num>

    num => 1,

When set to a true value the query parameter's value must contain digits only.

C<optional>

    optional => 1,

When set to a true value indicates that the parameter is optional. Note that you can specify
other rules along with this one, e.g.:

    optional => 1,
    num      => 1,

Means, query parameter is optional, B<but if it is given> it must contain only digits.

C<either_or>

    optional    => 1, # must use this
    either_or   => 'foo',

    optional    => 1, # must use this
    either_or   => [ qw/foo bar baz/ ],

The C<optional> rul B<must be set to a true value> in order for C<either_or> rule to work.
The rule takes either a string or an arrayref as a value. Specifying a string as a value is
the same as specifying a hashref with just that string in it. Each string in an arrayref
represents the name of a query parameter. In order for the rule to succeed B<either> one
of the parameters must be set. It's a bit messy, but you must use the C<optional> rule
as well as list the C<either_or> rule for every parameter that is tested for "either or" rule.

C<must_match>

    must_match => qr/foo/,

Takes a regex (C<qr//>) as a value. The query parameter's value must match this regex.

C<must_not_match>

    must_not_match => qr/bar/,

Takes a regex (C<qr//>) as a value. The query parameter's value must B<NOT> match this regex.

C<max>

    max => 20,

Takes a positive integer as a value. Query parameter's value must not exceed C<max>
characters in length.

C<min>

    min => 3,

Takes a positive integer as a value. Query parameter's value must be at least C<min>
characters in length.

C<valid_values>

    valid_values => [ qw/foo bar baz/ ],

Takes an arrayref as a value. Query parameter's value must be one of the items in the arrayref.

C<code>

    code => sub { time() %2 },

Here you can let your soul dance to your desire. Takes a subref as a value. The C<@_> will
contain the following (in that order): - the value of the parameter that is being tested,
the hashref of ZofCMS Template, hashref of query parameters and the L<App::ZofCMS::Config>
object. If the sub returns a true value - the check will be considered successfull. If the
sub returns a false value, then test fails and form check stops and errors.

C<param>

    param => 'param2',

Takes a string as an argument; that string will be interpreted as a name of a query parameter.
Values of the parameter that is currently being inspected and the one given as a value must
match in order for the rule to succeed. The example above indicates that query parameter
C<param> C<eq> query parameter C<param2>.

C<select>

    select => 1,

This one is not actually a "rule". This is a flag for C<{t}> "filling" that is
described in great detail (way) above under the description of C<no_fill> key.

CUSTOM ERROR MESSAGES IN RULESETS

All C<*_error> keys take strings as values; they can be used to set custom error
messages for each test in the ruleset. In the defaults listed below under each C<*_error>,
the C<$name> represents either the name of the parameter or the value of C<name> key that
you set in the ruleset.

C<num_error>

    num_error => 'Numbers only!',

This will be the error to be displayed if C<num> test fails.
B<Defaults to> C<Parameter $name must contain digits only>.

C<mandatory_error>
 
    mandatory_error => 'Must gimme!',

This is the error when C<optional> is set to a false value, which is the default, and
user did not specify the query parameter. I.e., "error to display for missing mandatory
parameters". B<Defaults to:> C<You must specify parameter $name>

C<must_match_error>

    must_match_error => 'Must match me!',

This is the error for C<must_match> rule. B<Defaults to:>
C<Parameter $name contains incorrect data>

C<must_not_match_error>

    must_not_match_error => 'Cannot has me!',

This is the error for C<must_not_match> rule. B<Defaults to:>
C<Parameter $name contains incorrect data>

C<max_error>

    max_error => 'Too long!',

This is the error for C<max> rule. B<Defaults to:>
C<Parameter $name cannot be longer than $max characters> where C<$max> is the C<max> rule's
value.

C<min_error>

    min_error => 'Too short :(',

This is the error for C<min> rule. B<Defaults to:>
C<Parameter $name must be at least $rule->{min} characters long>

C<code_error>

    code_error => 'No likey 0_o',

This is the error for C<code> rule. B<Defaults to:>
C<Parameter $name contains incorrect data>

C<either_or_error>

    either_or_error => "You must specify either Foo or Bar",

This is the error for C<either_or> rule.
B<Defaults to:> C<Parameter $name must contain data if other parameters are not set>

C<valid_values_error>

    valid_values_error => 'Pick the correct one!!!',

This is the error for C<valid_values> rule. B<Defaults to:>
C<Parameter $name must be $list_of_values> where C<$list_of_values> is the list of the
values you specified in the arrayref given to C<valid_values> rule joined by commas and
the last element joined by word "or".

C<param_error>

    param_error => "Two passwords do not match",

This is the error for C<param> rule. You pretty much always would want to set a custom
error message here as it B<defaults to:> C<< Parameter $name does not match parameter
$rule->{param} >> where C<< $rule->{param} >> is the value you set to C<param> rule.

HTML::Template VARIABLES

    <tmpl_if name="plug_form_checker_error">
        <p class="error"><tmpl_var name="plug_form_checker_error"></p>
    </tmpl_if>

    # or, if 'all_errors' is turned on:
    <tmpl_if name="plug_form_checker_error">
        <tmpl_loop name="plug_form_checker_error">
            <p class="error"><tmpl_var name="error"></p>
        </tmpl_loop>
    </tmpl_if>

If the form values failed any of your checks, the plugin will set C<plug_form_checker_error>
key in C<{t}> special key explaining the error. If C<all_errors> option is turned on, then
the plugin will set C<plug_form_checker_error> to a data structure that you can feed
into C<< <tmpl_loop name=""> >> where the C<< <tmpl_var name="error"> >> will be replaced
with the error message. The sample usage of this is presented above.


=head1 App::ZofCMS::Plugin::FormFiller (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::FormFiller>



App::ZofCMS::Plugin::FormFiller - fill HTML form elements' values.

SYNOPSIS

In Main Config file or ZofCMS Template:

    plugins => [ qw/FormFiller/ ],
    plug_form_filler => {
        params => [ qw/nu_login nu_name nu_email nu_admin nu_aa nu_mm user/ ],
    },

DESCRIPTION

The module provides filling of form elements from C<{t}> ZofCMS Template special key or query
parameters if those are specified.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/FormFiller/ ],

Your obviously need to specify the name of the plugin in C<plugins> arrayref for ZofCMS
to execute the plugin. However, you'll probably be using another plugin, such as
L<App::ZofCMS::Plugin::DBI> to fill the C<{t}> key first, thus don't forget to set
right priorities.

C<plug_form_filler>

    plug_form_filler => {
        params => [ qw/login name email/ ],
    },
    
    plug_form_filler => {
        params => {
             t_login    => 'query_login',
             t_name     => 'query_name',
             t_email    => 'query_email',
        },
    },

The C<plug_form_filler> takes a hashref as a value. The possible keys/values of that
hashref are as follows:

C<params>

    params => {
            t_login    => query_login,
            t_name     => query_name,
            t_email    => query_email,
    },

    params => [ qw/login name email/ ],
    # same as
    params => {
        login => 'login',
        name  => 'name',
        email => 'email',
    },

B<Mandatory>. The C<params> key takes either a hashref or an arrayref as a value. If the
value is an arrayref it will be converted to a hashref where keys and values are the same.
The keys of the hashref will be interpreted as keys in the C<{t}> ZofCMS Template special
key and values will be interpreted as names of query parameters.

The idea of the plugin is that if query parameter (one of the specified in the C<params>
hashref/arrayref) has some value that is different from the corresponding value
in the C<{t}> hashref, the plugin will put that value into the C<{t}> ZofCMS
Template hashref. This allows you to do, for example, the following: fetch preset values
from the database (using L<App::ZofCMS::Plugin::DBI> perhaps) and present them to the user,
if the user edits some fields you have have the preset values along with those changes made
by the user.


=head1 App::ZofCMS::Plugin::FormMailer (version 0.0222)

NAME


Link: L<App::ZofCMS::Plugin::FormMailer>



App::ZofCMS::Plugin::FormMailer - plugin for e-mailing forms

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plug_form_mailer => {
        trigger => [ qw/ d   plug_form_checker_ok / ],
        subject => 'Zen of Design Account Request',
        to      => 'foo@bar.com',
        mailer  => 'testfile',
        format  => <<'END',
The following account request has been submitted:
First name: {:{first_name}:}
Time:       {:[time]:}
Host:       {:[host]:}
END
    },

In your L<HTML::Template> file:

    <tmpl_if name="plug_form_mailer_ok">
        <p>Your request has been successfully submitted.</p>
    <tmpl_else>
        <form action="" method="POST" id="form_account_request">
            <input type="text" name="first_name">
            <input type="submit" value="Request account">
        </form>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that
provides means to easily e-mail query parameters.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/FormMailer/ ],

You need to add the plugin in the list of plugins to execute. Generally you'd want to check
query parameters first with, e.g. L<App::ZofCMS::Plugin::FormChecker>. If that's what you're
doing then make sure to set the correct priority:

    plugins => [ { FormChecker => 1000 }, { FormMailer => 2000 }, ],

C<plug_form_mailer>

        plug_form_mailer => {
            trigger     => [ qw/ d   plug_form_checker_ok / ],
            subject     => 'Zen of Design Account Request',
            to          => 'foo@bar.com',
            from        => 'Me <me@mymail.com>',
            ok_redirect => 'http://google.com/',
            mailer      => 'testfile',
            format      => <<'END',
    The following account request has been submitted:
    First name: {:{first_name}:}
    Time:       {:[time]:}
    Host:       {:[host]:}
    END
        },


    plug_form_mailer => sub {
        my ( $t, $q, $config ) = @_;
        return {
            # set plugin config here
        };
    },

The plugin will not run unless C<plug_form_mailer> first-level key is set in either Main
Config File or ZofCMS Template file. The C<plug_form_mailer> first-level key takes a hashref
or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_form_mailer> as if it was already there. If sub
returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Keys that are set in both Main Config File and ZofCMS Template file will take on
their values from ZofCMS Template. Possible keys/values are as follows:

C<format>

        format  => \'file_name_relative_to_templates',

        # or

        format  => <<'END',
    The following account request has been submitted:
    First name: {:{first_name}:}
    Time:       {:[time]:}
    Host:       {:[host]:}
    END
        },

B<Mandatory>. The C<format> key takes a scalar or a scalarref as a value.
When the value is a B<scalarref> then it is interpreted as a file name relative to the
"templates" dir; this file will be read and its contents will serve as a value for C<format>
argument (i.e. same as specifying contents of the file to C<format> as scalar value).
If an error occured when opening the file, the plugin will set the C<plug_form_mailer_error>
in the C<{t}> special key to the error message and will set the C<format> to an empty string.

When value is a B<scalar>, it represents the body
of the e-mail that plugin will send. In this scalar you can use special "tags" that will
be replaced with data. The tag format is C<{:{TAG_NAME}:}>. Tag name cannot contain a closing
curly bracket (C<}>) in it. Two special tags are C<{:[time]:}> and C<{:[host]:}> (note
a slightly different tag format) that will
be replaced with current time and user's host respectively.

C<to>

    to => 'foo@bar.com',
    to => [ qw/foo@bar.com  foo2@bar.com/ ],

B<Mandatory>. Specifies the e-mail address(es) to which to send the e-mails. Takes either
an arrayref or a scalar as a value. Specifying a scalar is the same as specifying
an arrayref with just that scalar in it. Each element of that arrayref must be a valid
e-mail address.

C<from>

    from => 'Me <me@mymail.com>',

B<Optional>. Specifies the "From" header to use. Note: in my experience, setting the "From"
to some funky address would sometimes make the server refuse to send mail; if your mail
is not being sent, try to leave the C<from> header at the default.B<By default:> not
specified, thus the "From" will be whatever your server has in stock.

C<trigger>

    trigger => [ qw/ d   plug_form_checker_ok / ],

B<Optional>. The plugin will not do anything until its "trigger" is set to a true value.
The C<trigger> argument takes an arrayref as a value. Each element of this arrayref represent
a B<hashref> key in which to find the trigger. In other words, if C<trigger> is set to
C<[ qw/ d   plug_form_checker_ok / ]> then the plugin will check if the C<plug_form_checker_ok>
key I<inside> C<{d}> ZofCMS Template special key is set to a true value. You can nest as
deep as you want, however only hashref keys are supported. B<Defaults to:>
C<[ qw/d plug_form_mailer/ ]> (C<plug_form_mailer> key inside C<d> first-level key).

C<subject>

    subject => 'Zen of Design Account Request',

B<Optional>. The C<subject> key takes a scalar as a value. This value will be the "Subject"
line in the e-mails sent by the plugin. B<Defaults to:> C<FormMailer>

C<mailer>

    mailer  => 'testfile',

B<Optional>. Specfies the "mailer" to use for e-mailing. See DESCRIPTION of L<Mail::Mailer>
for possible values and their meanings. If this value is set to a false value (or not
specified at all) then plugin will try all available mailers until one succeeds. Specifying
C<testfile> as a mailer will cause the plugin to "e-mail" data into C<mailer.testfile> file
in the same directory as your C<index.pl> file.

C<ok_key>

    ok_key  => 't',

B<Optional>. After sending an e-mail the plugin will set key C<plug_form_mailer_ok>
in one of the first-level
keys of ZofCMS Template hashref. The C<ok_key> specifies the name of that first-level key.
Note that that key's must value must be a hashref. B<Defaults to:> C<t> (thus you can
readily use the C<< <tmpl_if name="plug_form_mailer_ok"> >> to check for success (or rather
display some messages).

C<ok_redirect>

    ok_redirect => 'http://google.com/',

B<Optional>. Takes a string with a URL in it. When specified the plugin will redirect the
user to the page specified in C<ok_redirect> after sending the mail. B<By default> is not
specified.


=head1 App::ZofCMS::Plugin::FormToDatabase (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::FormToDatabase>



App::ZofCMS::Plugin::FormToDatabase - simple insertion of query into database

SYNOPSIS

In your Main Config file or ZofCMS template:

    plugins => [ qw/FormToDatabase/ ],
    plug_form_to_database => {
        go_field   => 'd|foo',
        values   => [ qw/one two/ ],
        table   => 'form',
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test',
        pass    => 'test',
        opt     => { RaiseError => 1, AutoCommit => 0 },
    },

DESCRIPTION

The module is a simple drop in to stick query into database. The module does not provide any
parameter checking and is very basic. For anything more advanced check out
L<App::ZofCMS::Plugin::DBI>

This documentation assumes you have read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE OR ZofCMS TEMPLATE FIRST LEVEL KEYS

    plug_form_to_database => {
        go_field   => 'd|foo',
        values   => [ qw/one two/ ],
        table   => 'form',
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test',
        pass    => 'test',
        opt     => { RaiseError => 1, AutoCommit => 0 },
    },

Plugin uses the C<plug_form_to_database> first-level key in ZofCMS template or your
main config file. The key takes a hashref as a value. Values set under this key
in ZofCMS template will override values set in main config file. Possible keys/values
are as follows.

C<go_field>

    go_field => 'd|foo',

B<Optional>. B<Defaults to: > C<d|form_to_database>.
The C<go_field> key specifies the "go" to the plugin; in other words, if value referenced
by the string set under C<go_field> key the plugin will proceed with stuffing your database,
otherwise it will not do anything. Generally, you'd do some query checking with a plugin
(e.g. L<App::ZofCMS::Plugin::FormChecker>) with lower priority number (so it would be run
first) and then set the value referenced by the C<go_field>.

The C<go_field> key takes a string as a value. The string is in format C<s|key_name> - where
C<s> is the name of the "source". What follows the "source" letter is a pipe (C<|>)
and then they name of the key. The special value of source C<q> (note that it is lowercase)
means "query". That is C<q|foo> means, "query parameter 'foo'". Other values of the "source"
will be looked for inside ZofCMS template hash, e.g. C<d|foo> means key C<foo> in ZofCMS
template special first-level key C<{d}> - this is probably where you'd want to check that for.

Example:

    # ZofCMS template:
    plugins => [ qw/FormToDatabase/ ],
    d       => { foo => 1 },
    plug_form_to_database => {
        go_field => 'd|foo',
        ..... # omited for brevity
    },

The example above will always stuff the query data into the database because key C<foo> under
key C<d> is set to a true value and C<go_field> references that value with C<d|foo>.

C<values>

        values => [ qw/one two/ ],

B<Mandatory>. The C<values> key takes an arrayref as a value. The elements of that arrayref
represent the names of query parameters that you wish to stick into the database.
Under the hood of the module the following is being called:

    $dbh->do(
        "INSERT INTO $conf{table} VALUES(" . join(q|, |, ('?')x@values) . ');',
        undef,
        @$query{ @values },
    );

Where C<@values> contains values you passed via C<values> key and C<$dbh> is the database
handle created by C<DBI>. If you want something more
advanced consider using C<App::ZofCMS::Plugin::DBI> instead.

C<table>

    table => 'form',

B<Mandatory>. Specifies the name of the table into which you wish to store the data.

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Specifies the I<dsn> to use in DBI connect call. See documentation for
L<DBI> and C<DBD::your_database> for proper syntax for this string.

C<user>

    user => 'test',

B<Mandatory>. Specifies the user name (login) to use when connecting to the database.

C<pass>

    pass => 'test',

B<Mandatory>. Specifies the password to use when connecting to the database.

C<opt>

B<Optional>. Specifies extra options to use in L<DBI>'s C<connect_cached()> call.
B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 0 } >>

SEE ALSO

L<DBI>, L<App::ZofCMS::Plugin::DBI>


=head1 App::ZofCMS::Plugin::GetRemotePageTitle (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::GetRemotePageTitle>



App::ZofCMS::Plugin::GetRemotePageTitle - plugin to obtain page titles from remote URIs

SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/GetRemotePageTitle/
    ],

    plug_get_remote_page_title => {
        uri => 'http://zoffix.com',
    },

In HTML::Template file:

    <tmpl_if name='plug_remote_page_title_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_remote_page_title_error'></p>
    <tmpl_else>
        <p>Title: <tmpl_var escape='html' name='plug_remote_page_title'></p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to get page titles from
remote URIs which can be utilized when automatically parsing URIs posted in coments, etc.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/GetRemotePageTitle/
    ],

B<Mandatory>. You must specify the plugin in the list of plugins to execute.

C<plug_get_remote_page_title>

    plug_get_remote_page_title => {
        uri => 'http://zoffix.com',
        ua => LWP::UserAgent->new(
            agent    => "Opera 9.5",
            timeout  => 30,
            max_size => 2000,
        ),
    },

    plug_get_remote_page_title => sub {
        my ( $t, $q, $config ) = @_;
        return {
            uri => 'http://zoffix.com',
        };
    },

B<Mandatory>. Takes either a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_get_remote_page_title>
as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Possible keys/values for the hashref
are as follows:

C<uri>

    plug_get_remote_page_title => {
        uri => 'http://zoffix.com',
    }

    plug_get_remote_page_title => {
        uri => [
            'http://zoffix.com',
            'http://haslayout.net',
        ],
    }

    plug_get_remote_page_title => {
        uri => sub {
            my ( $t, $q, $config ) = @_;
            return 'http://zoffix.com';
        },
    }

B<Mandatory>. Specifies URI(s) titles of which you wish to obtain. The value can be either
a direct string, an arrayref or a subref. When value is a subref, its C<@_> will contain
(in that order): ZofCMS Template hashref, query parameters hashref and L<App::ZofCMS::Config>
object. The return value of the sub will be assigned to C<uri> argument as if it was already
there.

The single string vs. arrayref values affect the output format (see section below).

C<ua>

    plug_get_remote_page_title => {
        ua => LWP::UserAgent->new(
            agent    => "Opera 9.5",
            timeout  => 30,
            max_size => 2000,
        ),
    },

B<Optional>. Takes an L<LWP::UserAgent> object as a value; this object will be used for
fetching titles from the remote pages. B<Defaults to:>

    LWP::UserAgent->new(
        agent    => "Opera 9.5",
        timeout  => 30,
        max_size => 2000,
    ),

PLUGIN'S OUTPUT

    # uri argument set to a string
    <tmpl_if name='plug_remote_page_title_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_remote_page_title_error'></p>
    <tmpl_else>
        <p>Title: <tmpl_var escape='html' name='plug_remote_page_title'></p>
    </tmpl_if>


    # uri argument set to an arrayref
    <ul>
        <tmpl_loop name='plug_remote_page_title'>
        <li>
            <tmpl_if name='error'>
                Got error: <tmpl_var escape='html' name='error'>
            <tmpl_else>
                Title: <tmpl_var escape='html' name='title'>
            </tmpl_if>
        </li>
        </tmpl_loop>
    </ul>

Plugin will set C<< $t->{t}{plug_remote_page_title} >> (where C<$t> is ZofCMS Template
hashref) to either a string or an
arrayref when C<uri> plugin's argument is set to a string or arrayref respectively. Thus,
for arrayref values you'd use a C<< <tmpl_loop> >> plugins will use two variables
inside that loop: C<error> and C<title>; the C<error> variable will be present when
an error occured during title fetching. The C<title> will be the title of the URI. Order
for arrayrefs will be the same as the order in C<uri> argument.

If C<uri> argument was set to a single string, then C<{plug_remote_page_title}> will contain
the actual title of the page and C<{plug_remote_page_title_error}> will be set if an error
occured.


=head1 App::ZofCMS::Plugin::GoogleCalculator (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::GoogleCalculator>



App::ZofCMS::Plugin::GoogleCalculator - simple plugin to interface with Google calculator

SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/GoogleCalculator/
    ],
    plug_google_calculator => {},

In HTML::Template template:

    <form action="" method="POST">
    <div>
        <label>Enter an expression: <input type="text" name="calc"></label>
        <input type="submit" value="Calculate">
    </div>
    </form>

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    <tmpl_else>
        <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides a simple interface to Google
calculator (L<http://www.google.com/help/calculator.html>).
This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/GoogleCalculator/
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute.

C<plug_google_calculator> 

    plug_google_calculator => {}, # run with all the defaults


    plug_google_calculator => {  ## below are the default values
        from_query => 1,
        q_name     => 'calc',
        expr       => undef,
    }

    plug_google_calculator => sub {  # set configuration via a subref
        my ( $t, $q, $config ) = @_;
        return {
            from_query => 1,
            q_name     => 'calc',
            expr       => undef,
        };
    }

B<Mandatory>. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_google_calculator> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run with all the defaults, pass an empty hashref.
Hashref's keys/values are as follows:

C<from_query>

    plug_google_calculator => {
        from_query  => 1,
    }

B<Optional>. Takes either true or false values. When set to a true value, the expression
to calculate will be taken from query parameters and parameter's name will be derived
from C<q_name> argument (see below). When set to a false value, the expression will
be taken from C<expr> argument (see below) directly. B<Defaults to:> C<1>

C<q_name>

    plug_google_calculator => {
        q_name     => 'calc',

B<Optional>. When C<from_query> argument is set to a true value, specifies the name
of the query parameter from which to gather the expression to calculate.
B<Defaults to:> C<calc>

C<expr>

    plug_google_calculator => {
        expr       => '2*2',
    }

    plug_google_calculator => {
        expr       => sub {
            my ( $t, $q, $config ) =  @_;
            return '2' . $q->{currency} ' in CAD';
        },
    }

B<Optional>. When C<from_query> argument is set to a false value, specifies the expression
to calculate. Takes either a literal expression as a string or a subref as a value.
When set to a subref, subref will be executed and its return value will be assigned
to C<expr> as if it was already there (note, C<undef>s will cause the plugin to
stop further processing). The sub's C<@_> will contain the following (in that order):
ZofCMS Template hashref, query parameters hashref and L<App::ZofCMS::Config> object.
B<Defaults to:> C<undef>

PLUGIN OUTPUT

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    <tmpl_else>
        <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>
    </tmpl_if>

C<plug_google_calculator>

    <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>

If result was calculated successfully, the plugin will set
C<< $t->{t}{plug_google_calculator} >> to the result string where C<$t> is ZofCMS Template
hashref.

C<plug_google_calculator_error>

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    </tmpl_if>

If an error occured during the calculation, C<< $t->{t}{plug_google_calculator_error} >>
will be set to the error message where C<$t> is ZofCMS Template hashref.


=head1 App::ZofCMS::Plugin::GooglePageRank (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::GooglePageRank>



App::ZofCMS::Plugin::GooglePageRank - Plugin to show Google Page Ranks

SYNOPSIS

    plugins => [
        { GooglePageRank => 200 },
    ],

    # all defaults and URI is set to the current page
    plug_google_page_rank => {},

    # all options set
    plug_google_page_rank => {
        uri => 'zoffix.com',
        timeout => 20,
        agent   => 'Opera 9.6',
        host    => 'suggestqueries.google.com',
        cell    => 't',
        key     => 'plug_google_page_rank',
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to obtain Google Page Rank.
This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/GooglePageRank/
    ],

B<Mangatory>. You need to add the plugin to list of plugins to execute.

C<plug_google_page_rank>

    plug_google_page_rank => {
        uri     => 'zoffix.com',
        timeout => 20,
        agent   => 'Opera 9.6',
        host    => 'suggestqueries.google.com',
        cell    => 't',
        key     => 'plug_google_page_rank',
    },

    plug_google_page_rank => {
        my ( $t, $q, $config ) = @_;
        return {
            uri     => 'zoffix.com',
            timeout => 20,
            agent   => 'Opera 9.6',
            host    => 'suggestqueries.google.com',
            cell    => 't',
            key     => 'plug_google_page_rank',
        };
    },

B<Mandatory>. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_google_page_rank> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
The C<plug_google_page_rank> first-level key can be set in either (or both)
ZofCMS Template and Main Config File files. If set in both, the values of keys that are set in
ZofCMS Template take precedence. Possible keys/values are as follows:

C<uri>

    uri => 'zoffix.com',

    uri => [
        'zoffix.com',
        'haslayout.net',
        'http://zofdesign.com',
    ],

    uri => sub {
        my ( $t, $q, $config ) = @_;
    },

B<Optional>. Takes a string, a coderef or an arrayref of strings each of which would specify
the page(s) for which to obtain Google Page Rank. If the value is a coderef, then it will
be exectued and its value will be assigned to C<uri>. The C<@_> will contain (in that order):
ZofCMS Template hashref, query parameters hashref, L<App::ZofCMS::Config> object.
B<Defaults to:> if not specified, then the URI of the current page will be calculated. Note
that this may depend on the server and is made up as:
C<< 'http://' . $ENV{HTTP_HOST} . $ENV{REQUEST_URI} >>

C<timeout>

    timeout => 20,

B<Optional>. Takes a positive integer as a value. Specifies a Page Rank request
timeout in seconds. B<Defaults to:> C<20>

C<agent>

    agent => 'Opera 9.6',

B<Optional>. Takes a string as a value that specifies the User-Agent string to use when
making the requests. B<Defaults to:> C<'Opera 9.6'>

C<host>

    host => 'suggestqueries.google.com',

B<Optional>. Specifies which google host to use for making requests.
B<Defaults to:> C<suggestqueries.google.com> (B<Note:> if all your queries failing try to set
this on to C<toolbarqueries.google.com>)

C<cell>

    cell => 't',

B<Optional>. Specifies the first-level key in ZofCMS Template hashref into which to store
the result. Must point to an C<undef> or a hashref. B<Defaults to:> C<t>

C<key>

    key => 'plug_google_page_rank',

B<Optional>. Specifies the second-level key inside C<cell> first-level key into which
to put the results. B<Defaults to:> C<plug_google_page_rank>

OUTPUT

Depending on whether the C<uri> argument was set to a string (or not set at all) or an
arrayref the output will be either a string indicating page's rank or an arrayref of
hashrefs - enabling you to use a simple C<< <tmpl_loop> >>, each of the hashrefs will contain two keys: C<rank> and C<uri> - the rank of
the page referenced by that URI.

If there was an error while obtaining the rank (i.e. request timeout) the rank will
be shown as string C<'N/A'>.

EXAMPLE DUMP 1

    plug_google_page_rank => {
        uri => [
            'zoffix.com',
            'haslayout.net',
            'http://zofdesign.com',
            'yahoo.com',
        ],
    },

    't' => {
        'plug_google_page_rank' => [
            {
                'rank' => '3',
                'uri' => 'http://zoffix.com'
            },
            {
                'rank' => '3',
                'uri' => 'http://haslayout.net'
            },
            {
                'rank' => '3',
                'uri' => 'http://zofdesign.com'
            },
            {
                'rank' => '9',
                'uri' => 'http://yahoo.com'
            }
        ]

EXAMPLE DUMP 2

    plug_google_page_rank => {
        uri => 'zoffix.com',
    },


    't' => {
        'plug_google_page_rank' => '3'
    }

EXAMPLE DUMP 3

    # URI became http://zcms/ which is a local address and not pageranked
    plug_google_page_rank => {},


    't' => {
        'plug_google_page_rank' => 'N/A'
    }


=head1 App::ZofCMS::Plugin::GoogleTime (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::GoogleTime>



App::ZofCMS::Plugin::GoogleTime - plugin to get times for different locations using Google

SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/GoogleTime/
    ],

    plug_google_time => {
        location => 'Toronto',
    },

In HTML::Template file:

    <tmpl_if name='plug_google_time_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_time_error'></p>
    <tmpl_else>
        <p>Time: <tmpl_var escape='html' name='plug_google_time'></p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to obtain times for different
locations using Google.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/GoogleTime/
    ],

B<Mandatory>. You must specify the plugin in the list of plugins to execute.

C<plug_google_time>

    plug_google_time => {
        location => 'Toronto',
        ua => LWP::UserAgent->new(
            agent    => "Opera 9.5",
            timeout  => 30,
            max_size => 2000,
        ),
    },

    plug_google_time => sub {
        my ( $t, $q, $config ) = @_;
        return {
            location => 'Toronto',
        }
    },

B<Mandatory>. Takes either a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_google_time> as if it was already there. If sub
returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Possible keys/values for the hashref
are as follows:

C<location>

    plug_google_time => {
        location => 'Toronto',
    }

    plug_google_time => {
        location => [
            'Toronto',
            'New York',
        ],
    }

    plug_google_time => {
        location => sub {
            my ( $t, $q, $config ) = @_;
            return 'Toronto';
        },
    }

B<Mandatory>. Specifies location(s) for which you wish to obtain times.
The value can be either a direct string, an arrayref or a subref.
When value is a subref, its C<@_> will contain
(in that order): ZofCMS Template hashref, query parameters hashref and L<App::ZofCMS::Config>
object. The return value of the sub will be assigned to C<location> argument
as if it was already there.

The single string vs. arrayref values affect the output format (see section below).

C<ua>

    plug_google_time => {
        ua => LWP::UserAgent->new(
            agent    => "Opera 9.5",
            timeout  => 30,
        ),
    },

B<Optional>. Takes an L<LWP::UserAgent> object as a value; this object will be used for
accessing Google. B<Defaults to:>

    LWP::UserAgent->new(
        agent    => "Opera 9.5",
        timeout  => 30,
    ),

PLUGIN'S OUTPUT

    # location argument set to a string
    <tmpl_if name='plug_google_time_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_time_error'></p>
    <tmpl_else>
        <p>Time: <tmpl_var escape='html' name='plug_google_time'></p>
    </tmpl_if>


    # location argument set to an arrayref
    <ul>
        <tmpl_loop name='plug_google_time'>
        <li>
            <tmpl_if name='error'>
                Got error: <tmpl_var escape='html' name='error'>
            <tmpl_else>
                Time: <tmpl_var escape='html' name='time'>
            </tmpl_if>
        </li>
        </tmpl_loop>
    </ul>

Plugin will set C<< $t->{t}{plug_google_time} >> (where C<$t> is ZofCMS Template
hashref) to either a string or an
arrayref when C<location> plugin's argument is set to a string or arrayref respectively. Thus,
for arrayref values you'd use a C<< <tmpl_loop> >> plugins will use three variables
inside that loop: C<error>, C<time> and C<hash>; the C<error> variable will be present when
an error occured during title fetching. The C<time> will be the formated string of the
time including the location. The C<hash> variable will contain a hashref that is the
output of C<data()> method of L<WWW::Google::Time> module. Order
for arrayrefs will be the same as the order in C<location> argument.

If C<location> argument was set to a single string, then C<{plug_google_time}> will contain
the formated time of the location, C<{plug_google_time_error}> will be set if an error
occured and C<{plug_google_time_hash}> will contain the
output of C<data()> method of L<WWW::Google::Time> module.


=head1 App::ZofCMS::Plugin::HTMLFactory (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::HTMLFactory>



App::ZofCMS::Plugin::HTMLFactory - notes for modules in App::ZofCMS::Plugin::HTMLFactory:: namespace

DESCRIPTION

This is not a module but explanation and suggestions for modules in
C<App::ZofCMS::Plugin::HTMLFactory::> namespace.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

WTF IS THIS ABOUT?

The C<App::ZofCMS::Plugin::HTMLFactory::> namespace is for L<App::ZofCMS> plugins that do
nothing special but provide some canned HTML codes that are used a lot and are a PITA to type
out over and over again.

NOTE FOR DEVS

The plugins in C<App::ZofCMS::Plugin::HTMLFactory::> typically would be run when they are
included in the list of plugins to run. No special keys in ZofCMS Template are expected.

The plugins would usually set keys in C<{t}> ZofCMS Template special key that would be replaced
with canned HTML codes.

These are not laws, however, feel free to experiment.


=head1 App::ZofCMS::Plugin::HTMLFactory::Entry (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::HTMLFactory::Entry>



App::ZofCMS::Plugin::HTMLFactory::Entry - plugin to wrap content in three divs used for styling boxes

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plugins => [ qw/HTMLFactory::Entry/ ],

In your L<HTML::Template> template:

    <tmpl_var name='entry_start'>
        <p>Some content</p>
    <tmpl_var name='entry_end'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. The module resides in
C<App::ZofCMS::Plugin::HTMLFactory::> namespace thus only provides some packed HTML code.

I use the HTML code provided by the plugin virtually on every site, and am sick and tired of
writing it! Hence the plugin.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/HTMLFactory::Entry/ ],

To run the plugin all you have to do is include it in the list of plugins to execute.

HTML::Template VARIABLES

    <tmpl_var name='entry_start'>
    <tmpl_var name='entry_end'>

The plugins creates two keys in C<{t}> ZofCMS Template special keys.

C<entry_start>

    <tmpl_var name='entry_start'>

The C<entry_start> will be replaced with the following HTML code:

    <div class="entry">
        <div class="entry_top">
            <div class="entry_bottom">

C<entry_end>

    <tmpl_var name='entry_end'>

The C<entry_end> will be replaced with the following HTML code:

            </div>
        </div>
    </div>


=head1 App::ZofCMS::Plugin::HTMLFactory::PageToBodyId (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::HTMLFactory::PageToBodyId>



App::ZofCMS::Plugin::HTMLFactory::PageToBodyId - plugin to automatically create id="" attributes on <body> depending on the current page

SYNOPSIS

In your Main Config file or ZofCMS Template:

    plugins => [ qw/HTMLFactory::PageToBodyId/ ],

    body_id => 'override', # including the key overrides the plugin's value

In your L<HTML::Template> template:

    <tmpl_var escape='html' name='body_id'>

DESCRIPTION

The module is a small plugin for L<App::ZofCMS>. Its purpose is to automatically generate a
value for an C<id=""> attribute that is to be put on C<< <body> >> HTML element; this value
would be used to differentiate different pages on the site and is generated from query C<dir>
and C<page> parameters.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config>
and L<App::ZofCMS::Template>

MAIN CONFIG FILE OR ZofCMS TEMPLATE

C<plugins>

    plugins => [ qw/HTMLFactory::PageToBodyId/ ],

You need to add the plugin to the list of plugins to execute. Unlike many other plugins,
the C<HTMLFactory::PageToBodyId> does not require an additional key in the template and
will run as long as it is included.

C<body_id>

The plugin first checks whether or not C<body_id> first-level key was set in either
ZofCMS Template or Main Config File. If it exists, plugin stuffs its value under
C<< $t->{t}{body_id} >> (where C<$t> is ZofCMS Template hashref)
otherwise, it creates its own from query's C<dir> and C<page> keys and uses that.

VALID C<id=""> / PLUGIN'S CHARACTER REPLACEMENT

To quote HTML specification:

    ID and NAME tokens must begin with a letter ([A-Za-z])
    and may be followed by any number of letters,
    digits ([0-9]), hyphens ("-"), underscores ("_"),
    colons (":"), and periods (".").

The plugin replaces any character that doesn't match the criteria with an underscore(C<_>).
Most of the time it will be the slashes (C</>) present in the full page URL.

GENERATED IDs

After doing invalid character replacement (see above) the plugin prefixes the generated value
with word "C<page>". Considering that any page URL would start with a slash, the resulting
values would be in the form of C<page_index>, C<page_somedir_about-us> and so on.

HTML::Template VARIABLES

The plugin sets C<body_id> key in C<t> ZofCMS Template special key, thus you can use
C<< <tmpl_var name='body_id'> >> in any of your L<HTML::Template> templates to obtain the
generated ID. The name of the key cannot be changed.

SEE ALSO

L<App::ZofCMS>, L<App::ZofCMS::Config>, L<App::ZofCMS::Template>, L<http://www.w3.org/TR/html401/types.html#type-name>


=head1 App::ZofCMS::Plugin::HTMLMailer (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::HTMLMailer>



App::ZofCMS::Plugin::HTMLMailer - ZofCMS plugin for sending HTML email

SYNOPSIS

    plugins => [
        { HTMLMailer => 2000, },
    ],

    plug_htmlmailer => {
        to          => 'cpan@zoffix.com',
        template    => 'email-template.tmpl',

        # everything below is optional
        template_params => [
            foo => 'bar',
            baz => 'ber',
        ],
        subject         => 'Test Subject',
        from            => 'Zoffix Znet <any.mail@fake.com>',
        template_dir    => 'mail-templates',
        precode         => sub {
            my ( $t, $q, $config, $plug_conf ) = @_;
            # run some code
        },
        mime_lite_params => [
            'smtp',
            'srvmail',
            Auth   => [ 'FOOBAR/foos', 'p4ss' ],
        ],
        html_template_object => HTML::Template->new(
            filename            => 'mail-templates/email-template.tmpl',
            die_on_bad_params   => 0,
        ),
    },

DESCRIPTION

The module is a ZofCMS plugin that provides means to easily create an 
email from an L<HTML::Template> template, fill it, and email it as an HTML 
email.

This documentation assumes you've read
L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    plugins => [ qw/HTMLMailer/ ],

First and obvious, you need to stick C<HTMLMailer> in the list of your
plugins.

C<plug_htmlmailer>

    plug_htmlmailer => {
        to          => 'cpan@zoffix.com',
        template    => 'email-template.tmpl',

        # everything below is optional
        template_params => [
            foo => 'bar',
            baz => 'ber',
        ],
        subject         => 'Test Subject',
        from            => 'Zoffix Znet <any.mail@fake.com>',
        template_dir    => 'mail-templates',
        precode         => sub {
            my ( $t, $q, $config, $plug_conf ) = @_;
            # run some code
        },
        mime_lite_params => [
            'smtp',
            'srvmail',
            Auth   => [ 'FOOBAR/foos', 'p4ss' ],
        ],
        html_template_object => HTML::Template->new(
            filename            => 'mail-templates/email-template.tmpl',
            die_on_bad_params   => 0,
        ),
    },

B<Mandatory>. Takes either a hashref or a subref as a value. If subref is
specified, its return value will be assigned to C<plug_htmlmailer> as if
it was already there. If sub returns an C<undef>, then plugin will stop
further processing. The C<@_> of the subref will contain (in that order):
ZofCMS Tempalate hashref, query parameters hashref and 
L<App::ZofCMS::Config> object. Possible keys/values for the hashref
are as follows:

C<to>

    plug_htmlmailer => {
        to => 'foo@bar.com',
    ...

    plug_htmlmailer => {
        to => [ 'foo@bar.com', 'ber@bar.com', ],
    ...

    plug_htmlmailer => {
        to => sub {
            my ( $t, $q, $config ) = @_;
            return [ 'foo@bar.com', 'ber@bar.com', ];
        }
    ...

B<Mandatory>. Specifies the email address(es) to which to send the email.
Takes a scalar, an arrayref or a subref as a value. If a scalar is
specified, plugin will create a single-item arrayref with it; if an
arrayref is specified, each of its items will be interpreted as an
email address to which to send email. If a subref is specified, its return
value will be assigned to the C<to> key and its C<@_> array will contain:
C<$t>, C<$q>, C<$config> (in that order) where C<$t> is ZofCMS Template
hashref, C<$q> is the query parameter hashref and C<$config> is the
L<App::ZofCMS::Config> object. B<Default:> if the C<to> key is not defined
(or the subref to which it's set returns undef) then the plugin will stop
further processing.

C<template>

    plug_htmlmailer => {
        template => 'email-template.tmpl',
    ...

B<Mandatory, unless> C<html_template_object> B<(see below) is specified>.
Takes a scalar as a value that represents the location of the
L<HTML::Template> template to use as the body of your email. If relative
path is specified, it will be relative to the location of C<index.pl> file.
B<Note:> if C<template_dir> is specified, it will be prepended to whatever
you specify here.

C<template_params>

    plug_htmlmailer => {
        template_params => [
            foo => 'bar',
            baz => 'ber',
        ],
    ...

    plug_htmlmailer => {
        template_params => sub {
            my ( $t, $q, $config ) = @_:
            return [ foo => 'bar', ];
        }
    ...

B<Optional>. Specifies key/value parameters for L<HTML::Template>'s
C<param()> method; this will be called on the L<HTML::Template> template
of your email body (specified by C<template> argument).
Takes an arrayref or a subref as a value. If subref is
specified, its C<@_> will contain C<$t>, C<$q>, and C<$config> (in that
order), where C<$t> is ZofCMS Template hashref, C<$q> is query parameter
hashref, and C<$config> is L<App::ZofCMS::Config> object. The subref must
return either an arrayref or an C<undef> (or empty list), and that will be 
assigned to C<template_params> as a true value. B<By default> is not
specified.

C<subject>

    plug_htmlmailer => {
        subject => 'Test Subject',
    ...

B<Optional>. Takes a scalar as a value that specifies the subject line
of your email. B<Default:> empty string.

C<from>

    plug_htmlmailer => {
        from => 'Zoffix Znet <any.mail@fake.com>',
    ...

B<Optional>. Takes a scalar as a value that specifies the C<From> field
for your email. If not specified, the plugin will simply not set the
C<From> argument in L<MIME::Lite>'s C<new()> method (which is what
this plugin uses under the hood). See L<MIME::Lite>'s docs for more
description. B<By default> is not specified.

C<template_dir>

    plug_htmlmailer => {
        template_dir => 'mail-templates',
    ...

B<Optional>. Takes a scalar as a value. If specified, takes either an
absolute or relative path to the directory that contains all your
L<HTML::Template> email templates (see C<template> above for more info). If
relative path is specified, it will be relative to the C<index.pl> file.
The purpose of this argument is to simply have a shortcut to save you the
trouble of specifying the directory every time you use C<template>.
B<By default> is not specified.

C<precode>

    plug_htmlmailer => {
        precode => sub {
            my ( $t, $q, $config, $plug_conf ) = @_;
            # run some code
        },
    ...

B<Optional>. Takes a subref as a value. This is just an "insertion point",
a place to run a piece of code if you really have to. The C<@_> of the 
subref will contain C<$t>, C<$q>, C<$config>, and C<$plug_conf> (in that
order), where C<$t> is ZofCMS Template hashref, C<$q> is query parameters
hashref, C<$config> is L<App::ZofCMS::Config> object, and C<$plug_conf>
is the configuration hashref of this plugin (that is the
C<plug_htmlmailer> hashref). You can use C<$plug_conf> to stick modified
configuration arguments to the I<current run> of this plugin (modifications
will not be saved past current run stage). The subref will be executed
B<after> the C<to> argument is processed, but before anything else is
done. B<Note:> if C<to> is not set (or set to subref that returns undef)
then the C<precode> subref will B<NOT> be executed at all. B<By default>
is not specified.

C<mime_lite_params>

    plug_htmlmailer => {
        mime_lite_params => [
            'smtp',
            'srvmail',
            Auth   => [ 'FOOBAR/foos', 'p4ss' ],
        ],
    ...

B<Optional>. Takes an arrayref as a value. If specified, the arrayref
will be directly dereferenced into C<< MIME::Lite->send() >>. Here you 
can set any special send arguments you need; see L<MIME::Lite> docs for
more info. B<By default> is not specified.

C<html_template_object>

    plug_htmlmailer => {
        html_template_object => HTML::Template->new(
            filename            => 'mail-templates/email-template.tmpl',
            die_on_bad_params   => 0,
        ),
    ...

B<Optional>. Takes an L<HTML::Template> object (or something that behaves
like one). If specified, the C<template> and C<template_dir> arguments
will be ignored and the object you specify will be used instead. B<Note:>
the default L<HTML::Template> object (used when C<html_template_object>
is B<not> specified) has C<die_on_bad_params> argument set to a false
value; using C<html_template_object> you can change that.
B<By default> is not specified.

OUTPUT

This plugin doesn't produce any output and doesn't set any keys.

A WARNING ABOUT ERRORS

This plugin doesn't have any error handling. The behaviour is completely
undefined in cases of: invalid email addresses, improper or
insufficient C<mime_lite_params> values, no C<from> set, etc. For example,
on my system, not specifying any C<mime_lite_params> makes it look
like plugin is not running at all. If things go awry: copy the plugin's
code into your projects dir
(C<zofcms_helper --nocore --site YOUR_PROJECT --plugins HTMLMailer>) and
mess around with code to see what's wrong (the code would be located in
C<YOUR_PROJECT_site/App/ZofCMS/Plugin/HTMLMailer.pm>)


=head1 App::ZofCMS::Plugin::ImageGallery (version 0.0203)

NAME


Link: L<App::ZofCMS::Plugin::ImageGallery>



App::ZofCMS::Plugin::ImageGallery - CRUD-like plugin for managing images.

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plugins => [ qw/ImageGallery/ ],

    plug_image_gallery => {
        dsn        => "DBI:mysql:database=test;host=localhost",
        user       => 'test',
        pass       => 'test',
        no_form    => 0,
        allow_edit => 1,
    },

In your L<HTML::Template> template:

    <tmpl_var name='plug_image_gallery_form'>
    <tmpl_var name='plug_image_gallery_list'>

Viola, now you can upload photos with descriptions, delete them and edit descriptions. \o/

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that allows one to add a CRUD-like functionality
for managing photos. The plugin automatically makes thumbnails and can also resize the
actual photos if you tell it to. So far, only
C<.jpg>, C<.png> and C<.gif> images are supported; however, plugin does not check
C<Content-Type> of the uploaded image.

The image file name and description are stored in a SQL database.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

USED SQL TABLE FORMAT

When C<create_table> option is turned on (see below) the plugin will create the following
table where C<table_name> is derived from C<table> argument in C<plug_image_gallery>
(see below).

    CREATE TABLE table_name (
        photo        TEXT,
        width        SMALLINT,
        height       SMALLINT,
        thumb_width  SMALLINT,
        thumb_height SMALLINT,
        description  TEXT,
        time         VARCHAR(10),
        id           TEXT
    );

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/ImageGallery/, ],

You obviously need to include the plugin in the list of plugins to execute.

C<plug_image_gallery>

    plug_image_gallery => {
        dsn             => "DBI:mysql:database=test;host=localhost",
        # everything below is optional
        user            => '',
        pass            => '',
        opt             => { RaiseError => 1, AutoCommit => 1 },
        table           => 'photos',
        photo_dir       => 'photos/',
        filename        => '[:rand:]',
        thumb_dir       => 'photos/thumbs/',
        create_table    => 0,
        t_name          => 'plug_image_gallery',
        no_form         => 1,
        no_list         => 0,
        no_thumb_desc   => 0,
        allow_edit      => 0,
        thumb_size      => { 200, 200 },
        # photo_size      => [ 600, 600 ],
        has_view        => 1,
        want_lightbox   => 0,
        lightbox_rel    => 'lightbox',
        lightbox_desc   => 1,
    }

    plug_image_gallery => sub {
        my ( $t, $q, $config ) = @_;
        return {
            dsn             => "DBI:mysql:database=test;host=localhost",
        };
    }

The plugin takes its configuration from C<plug_image_gallery> first-level key that takes
a hashref or a subref as a value and can be specified in either (or both) Main Config File and
ZofCMS Template file. If the same key in that hashref is specified in both, Main Config File
and ZofCMS Tempate file, then the value given to it in ZofCMS Template will take precedence.
If subref is specified,
its return value will be assigned to C<plug_image_gallery> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
    
The plugin will B<NOT> run if C<plug_image_gallery> is not set or if B<both> C<no_form>
B<and> C<no_list> arguments (see below) are set to true values.

The possible C<plug_image_gallery> hashref's keys/values are as follows:

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Takes a scalar as a value which must contain a valid
"$data_source" as explained in L<DBI>'s C<connect_cached()> method (which
plugin currently uses).

C<user>

    user => '',

B<Optional>. Takes a string as a value that specifies the user name to use when authorizing
with the database. B<Defaults to:> empty string

C<pass>

    pass => '',

B<Optional>. Takes a string as a value that specifies the password to use when authorizing
with the database. B<Defaults to:> empty string

C<opt>

    opt => { RaiseError => 1, AutoCommit => 1 },

B<Optional>. Takes a hashref as a value, this hashref contains additional L<DBI>
parameters to pass to C<connect_cached()> L<DBI>'s method. B<Defaults to:>
C<< { RaiseError => 1, AutoCommit => 1 } >>

C<table>

    table => 'photos',

B<Optional>. Takes a string as a value, specifies the name of the SQL table in which to
store information about photos. B<Defaults to:> C<photos>

C<create_table>

    create_table => 0,

B<Optional>. When set to a true value, the plugin will automatically create needed SQL table,
you can create it manually if you wish, see its format in C<USED SQL TABLE FORMAT> section
above. Generally you'd set this to a true value only once, at the start, and then you'd remove
it because there is no "IF EXISTS" checks. B<Defaults to:> C<0>

C<t_name>

    t_name => 'plug_image_gallery',

B<Optional>. Takes a string as a value. This string will be
used as a "base name" for two keys that plugin generates in C<{t}> special key.
The keys are C<plug_image_gallery_list> and C<plug_image_gallery_form>
(providing C<t_name> is set to
default) and are explained below in C<HTML::Template VARIABLES> section below. B<Defaults to:>
C<plug_image_gallery>

C<photo_dir>

    photo_dir => 'photos/',

B<Optional>. Takes a string that specifies the directory (relative to C<index.pl>) where
the plugin will store photos. B<Note:> plugin does B<not> automatically create this directory.
B<Defaults to:> C<photos/>

C<thumb_dir>

    thumb_dir => 'photos/thumbs/',

B<Optional>. Takes a string that specifies the directory (relative to C<index.pl>) where
the plugin will store thumbnails.
B<Note:> plugin does B<not> automatically create this directory. B<Note 2:> this directory
B<must NOT> be the same as C<photo_dir>.
B<Defaults to:> C<photos/thumbs/>

C<filename>

    filename => '[:rand:]',

B<Optional>. Specifies the name for the image file (and its thumbnail) without the extension
for when new image is uploaded. You'd obviously want to manipulate this value with some
other plugin (e.g. L<App::ZofCMS::Plugin::Sub>) to make sure it's not the same
as existing images. B<Special value> of C<[:rand:]> (value includes the brackets) will make
the plugin generate random filenames (along with check of whether the generated name
already exists). B<Defaults to:> C<[:rand:]>

C<thumb_size>

    thumb_size => { 200, 200 }, # resize only if larger
    thumb_size => [ 200, 200 ], # always resize

B<Optional>. Takes either an arrayref with two elements or a hashref with one key/value pair.
The plugin will generate thumbnails automatically. The C<thumb_size> specifies the dimensions
of the thumbnails. The proportions are always kept when resizing. When C<thumb_size> is set
to an I<arrayref>, the plugin will resize the image even if its smaller than the specified
size (i.e. a 50x50 image's thumb will be scaled to 200x200 when C<thumb_size> is set to
C<[200, 200]> ). The first element of the arrayref denotes the x (width) dimension and the
second element denotes the y (height) dimension. When the value for C<thumb_size> is a
I<hashref> then the key denotes the width and the value denotes the height; the image will
be resized only if one of its dimensions (width or height) is larger than the specified
values. In other words, when C<thumb_size> is set to C<{ 200, 200 }>, a 50x50 image's thumbnail
will be left at 50x50 while a 500x500 image's thumbnail will be scaled to 200x200.
B<Defaults to:> C<{ 200, 200 }>

C<photo_size>

    photo_size => { 600, 600 },
    photo_size => [ 600, 600 ],

B<Optional>. When specified takes either an arrayref or a hashref as a value. Everything is
the same (regarding values) as the values for C<thumb_size> argument described above except
that resizing is done on the original image. If C<photo_size> is not specified, no resizing
will be performed. B<Note:> the thumbnail will be generated first, thus it's possible to
have thumbnails that are larger than the original image even when hashrefs are used for
both C<photo_size> and C<thumb_size>. B<By default is not specified>

C<no_form>

    no_form => 1,

B<Optional>. Takes either true or false values. When
set to a B<false> value, the plugin will generate as well as process an HTML form that
is to be used for uploading new images or editing descriptions on existing ones.
B<Note:> even if you are making your own HTML form, the plugin will B<not> process
editing or deleting of items when C<no_form> is set to a true value. B<Defaults to:> C<1>

C<no_list>

    no_list => 0,

B<Optional>. Takes either true or false values. When set to a B<false> value, the plugin
will pull the data from the database and generate an HTML list with image thumbnails and their
descriptions (unless C<no_thumb_desc> argument described below is set to a true value).
B<Defaults to:> C<0>

C<no_thumb_desc>

    no_thumb_desc => 0,

B<Optional>. Takes either true or false values. Makes sense only when C<no_list> is set to
a false value. When C<no_thumb_desc> is set to a B<true> value, the plugin will not put
descriptions in the generated list of thumbnails. The description will be visible only when
the user clicks on the image to view it in large size (providing C<has_view> option that
is described below is set to a true value). B<Defaults to:> C<0>

C<has_view>

    has_view => 1,

B<Optional>. Takes either true or false values. Makes sense only when C<no_list> is set
to a false value. When set to a true value, plugin will generate links for each thumbnail
in the list; when user will click that link, he or she will be presented with an original
image and a link to go back to the list of thumbs. When set to a false value no link
will be generated. B<Defaults to:> C<1>

C<allow_edit>

    allow_edit => 0,

B<Optional>. Takes either true or false values. When set to a true value, B<both> C<no_list>
and B<no_form> must be set to false values.  When set to a true value, the plugin will
generate C<Edit> and C<Delete> buttons under each thumbnail in the list. Clicking "Delete" will
delete the image, thumbnail and entry in the database. Clicking "Edit" will fetch the
description into the "description" field in the form, allowing the user to edit it.
B<Defaults to:> C<0>

C<want_lightbox>

    want_lightbox => 0,

B<Optional>. The list of thumbs generated by the plugin can be generated for use with
"Lightbox" JavaScript crapolio. Takes true or false values. When set to a true value, the
thumb list will be formatted for use with "Lightbox". B<Note:> C<has_view> B<must> be set
to a true value as well. B<Defaults to:> C<0>

C<lightbox_rel>

    lightbox_rel => 'lightbox',

B<Optional>. Used only when C<want_lightbox> is set to a true value. Takes a string as a value,
this string will be used for C<rel=""> attribute on links. B<Defaults to:> C<lightbox>

C<lightbox_desc>

    lightbox_desc => 1,

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
stick image descriptions into C<title=""> attribute that makes them visible in the Lightbox.
B<Defaults to:> C<1>

HTML::Template VARIABLES

The plugin generates two keys in C<{t}> ZofCMS Template special key, thus making them
available for use in your L<HTML::Template> templates. Assuming C<t_name> is left at its
default value the following are the names of those two keys:

C<plug_image_gallery_form>

    <tmpl_var name='plug_image_gallery_form'>

This variable will contain HTML form generated by the plugin, the form also includes display
of errors.

C<plug_image_gallery_list>

    <tmpl_var name='plug_image_gallery_list'>

This variable will contain the list of photos generated by the plugin.

GENERATED HTML CODE

form

    <form action="" method="POST" id="plug_image_gallery_form" enctype="multipart/form-data">
    <div>
        <input type="hidden" name="page" value="photos">
        <input type="hidden" name="dir" value="/admin/">
        <ul>
            <li>
                <label for="plug_image_gallery_file">Image: </label
                ><input type="file" name="plug_image_gallery_file" id="plug_image_gallery_file">
            </li>
            <li>
                <label for="plug_image_gallery_description">Description: </label
                ><textarea name="plug_image_gallery_description" id="plug_image_gallery_description" cols="60" rows="5"></textarea>
            </li>
        </ul>
        <input type="submit" name="plug_image_gallery_submit" value="Upload">
    </div>
    </form>

form when "Edit" was clicked

    <form action="" method="POST" id="plug_image_gallery_form" enctype="multipart/form-data">
    <div>
        <input type="hidden" name="page" value="photos">
        <input type="hidden" name="dir" value="/admin/">
        <input type="hidden" name="plug_image_gallery_id" value="07537915760568812292592510718228816144752">
        <ul>
            <li>
                <label for="plug_image_gallery_description">Description: </label
                ><textarea name="plug_image_gallery_description" id="plug_image_gallery_description" cols="60" rows="5">Teh Descripshun!</textarea>
            </li>
        </ul>
        <input type="submit" name="plug_image_gallery_submit" value="Update">
    </div>
    </form>

form when upload or update was successful

    <p>Your image has been successfully uploaded.</p>
    <p><a href="/index.pl?page=photos&amp;amp;dir=/admin/">Upload another image</a></p>

list (when both C<allow_edit> and C<has_view> is set to true values)

    <ul class="plug_image_gallery_list">
        <li>
            <a href="/index.pl?page=photos&amp;dir=/admin/&amp;plug_image_gallery_photo_id=037142535745273312292651650508033404216754"><img src="/photos/thumbs/0029243203419358812292651650444418525180907.jpg" width="191" height="200" alt=""></a>
                <form action="" method="POST">
                <div>
                    <input type="hidden" name="plug_image_gallery_id" value="037142535745273312292651650508033404216754">
                    <input type="hidden" name="page" value="photos">
                    <input type="hidden" name="dir" value="/admin/">
                    <input type="submit" name="plug_image_gallery_action" value="Edit">
                    <input type="submit" name="plug_image_gallery_action" value="Delete">
                </div>
                </form>
        </li>
        <li class="alt">
            <a href="/index.pl?page=photos&amp;dir=/admin/&amp;plug_image_gallery_photo_id=07537915760568812292592510718228816144752"><img src="/photos/thumbs/058156553244134912292592510947564500241668.png" width="200" height="125" alt=""></a>
            <p>Teh Descripshun!</p>
                <form action="" method="POST">
                <div>
                    <input type="hidden" name="plug_image_gallery_id" value="07537915760568812292592510718228816144752">
                    <input type="hidden" name="page" value="photos">
                    <input type="hidden" name="dir" value="/admin/">
                    <input type="submit" name="plug_image_gallery_action" value="Edit">
                    <input type="submit" name="plug_image_gallery_action" value="Delete">
                </div>
                </form>
        </li>
    </ul>

original image view

    <a class="plug_image_gallery_return_to_image_list" href="/index.pl?page=photos&amp;dir=/admin/">Return to image list.</a>
    <div id="plug_image_gallery_photo"><img src="/photos/0029243203419358812292651650444418525180907.jpg" width="575" height="600" alt="">
        <p class="plug_image_gallery_description">Uber hawt chick</p>
    </div>


=head1 App::ZofCMS::Plugin::ImageResize (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::ImageResize>



App::ZofCMS::Plugin::ImageResize - Plugin to resize images

SYNOPSIS


    plugins => [
        qw/ImageResize/
    ],

    plug_image_resize => {
        images => [
            qw/3300 3300 frog.png/
        ],
        # below are all the default values
        inplace     => 1,
        only_down   => 1,
        cell        => 'd',
        key         => 'plug_image_resize',
        path        => 'thumbs',
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides simple image resize capabilities.
This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/ImageResize/
    ],

B<Mangatory>. You need to add the plugin to list of plugins to execute.

C<plug_image_resize>

    plug_image_resize => {
        images => [
            qw/3300 3300 frog.png/
        ],
        # optional options below; all are the default values
        inplace     => 1,
        only_down   => 1,
        cell        => 'd',
        key         => 'plug_image_resize',
        path        => 'thumbs',
    },

    plug_image_resize => sub {
        my ( $t, $q, $config ) = @_;
        return {
            images => [
                qw/3300 3300 frog.png/
            ],
        }
    },

B<Mandatory>. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_image_resize> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
The C<plug_image_resize> first-level key can be set in either (or both)
ZofCMS Template and Main Config File files. If set in both, the values of keys that are set in
ZofCMS Template take precedence. Possible keys/values are as follows:

C<images>

        images => [
            qw/3300 3300 frog.png/
        ],

        images => {
            image1 => {
                x           => 110,
                y           => 110,
                image       => 'frog.png',
                inplace     => 1,
                only_down   => 1,
                path        => 'thumbs',
            },
            image2 => [ qw/3300 3300 frog.png/ ],
        },

        images => [
            [ qw/1000 1000 frog.png/ ],
            [ qw/110 100 frog.png 0 1/ ],
            {
                x           => 110,
                y           => 110,
                image       => 'frog.png',
                inplace     => 1,
                only_down   => 1,
                path        => 'thumbs',
            },
        ],

        images => sub {
            my ( $t, $q, $config ) = @_;
            return [ qw/100 100 frog.png/ ];
        },

B<Mandatory>. The C<images> key is the only optional key. Its value can be either an
arrayref, an arrayref of arrayrefs/hashrefs, subref or a hashref.

If the value is a subref, the C<@_> will contain (in the following order): ZofCMS Template
hashref, query parameters hashref, L<App::ZofCMS::Config> object. The return value
of the sub will be assigned to C<images> key; if it's C<undef> then plugin will not execute
further.

When value is a hashref, it tells the plugin to resize several images and keys will represent
the names of the keys in the result (see OUTPUT section below) and values are the image
resize options. When value is an
arrayref of scalar values, it tells the plugin to resize only one image and that resize
options are in a "shortform" (see below). When the value is an arrayref of arrayrefs/hashrefs
it means there are several images to resize and each element of the arrayref is an
image to be resized and its resize options are set by each of those inner arrayrefs/hashrefs.

When resize options are given as an arrayref they correspond to the hashref-form keys
in the following order:

    x  y  image  inplace  only_down  path

In other words, the following resize options are equivalent:

    [ qw/100 200 frog.png 0 1 thumbs/ ],

    {
        x           => 110,
        y           => 110,
        image       => 'frog.png',
        inplace     => 1,
        only_down   => 1,
        path        => 'thumbs',
    },

The C<x>, C<y> and C<image> keys are mandatory. The rest of the keys are optional and their
defaults are whatever is set to the same-named keys in the plugin's configuration (see below).
The C<x> and C<y> keys specify the dimensions to which the image should be resized
(see also the C<only_down> option described below). The C<image> key contans the path to
the image, relative to C<index.pl> file.

C<inplace>

    inplace => 1,

B<Optional>. Takes either true or false values. When set to a true value, the plugin
will resize the images inplace (i.e. the resized version will be written over the original).
When set to a false value, the plugin will first copy the image into directory specified by
C<path> key and then resize it. B<Defaults to:> C<1>

C<only_down>

    only_down => 1,

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
only resize images if either of their dimensions is larger than what is set in C<x> or C<y>
parameters. When set to a false value, the plugin will scale small images up to meet
the C<x>/C<y> criteria. B<Note:> the plugin will always keep aspect ratio of the images.
B<Defaults to:> C<1>

C<cell>

    cell => 'd',

B<Optional>. Specifies the name of the first-level key of ZofCMS Template hashref into
which to put the results. Must point to either a non-existant key or a hashref.
B<Defaults to:> C<d>

C<key>

    key => 'plug_image_resize',

B<Optional>. Specifies the name of the second-level key (i.e. the name of the key inside
C<cell> hashref) where to put the results. B<Defaults to:> C<plug_image_resize>

C<path>

    path => 'thumbs',

B<Optional>. Specifies the name of the directory, relative to C<index.pl>, into which to
copy the resized images when C<inline> resize option is set to a false value. B<Defaults to:>
C<thumbs>.

ERRORS ON RESIZE

If an error occured during a resize, instead of a hashref you'll have an C<undef> and the
reason for error will be set to C<< $t->{t}{plug_image_resize_error} >> where C<$t> is the
ZofCMS Template hashref.

OUTPUT

The plugin will place the output into C<key> hashref key inside C<cell> first-level key
(see parameters above). The type of value of the C<key> will depend on how the C<images>
parameter was set (see dumps below for examples). In either case, each of the resized
images will result in a hashref inside the results. The C<x> and C<y> keys will contain
image's new size. The C<image> key will contain the path to the image relative to C<index.pl>
file. If the image was not resized then the C<no_resize> key will be present and its value
will be C<1>. The C<inplace>, C<path> and C<only_down> keys will be set to the values
that were set to be used in resize options.

    # `images` is set to a hashref with a key named `image1`
    'd' => {
        'plug_image_resize' => {
            'image1' => {
                'inplace' => '0',
                'y' => 2062,
                'path' => 'thumbs',
                'only_down' => '0',
                'x' => 3300,
                'image' => 'thumbs/frog.png'
        }
    }

    # `images` is set to one arrayref (i.e. no inner arrayrefs)
    'd' => {
        'plug_image_resize' => {
            'inplace' => '0',
            'y' => 2062,
            'path' => 'thumbs',
            'only_down' => '0',
            'x' => 3300,
            'image' => 'thumbs/frog.png'
        }
    },

    # `images` is set to one arrayref of arrayrefs
    'd' => {
        'plug_image_resize' => [
            {
                'inplace' => '0',
                'y' => 2062,
                'path' => 'thumbs',
                'only_down' => '0',
                'x' => 3300,
                'image' => 'thumbs/frog.png'
            }
        ],
    },


=head1 App::ZofCMS::Plugin::InstalledModuleChecker (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::InstalledModuleChecker>



App::ZofCMS::Plugin::InstalledModuleChecker - utility plugin to check for installed modules on the server

SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/InstalledModuleChecker/,
    ],

    plug_installed_module_checker => [
        qw/ Image::Resize
            Foo::Bar::Baz
            Carp
        /,
    ],

In HTML::Template template:

    <ul>
        <tmpl_loop name='plug_installed_module_checker'>
        <li>
            <tmpl_var escape='html' name='info'>
        </li>
        </tmpl_loop>
    </ul>

DESCRIPTION

The module is a utility plugin for L<App::ZofCMS> that provides means to check for whether
or not a particular module is installed on the server and get module's version if it is
installed.

The idea for this plugin came to me when I was constantly writing "little testing scripts"
that would tell me whether or not a particular module was installed on the crappy
server that I have to work with all the time.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/InstalledModuleChecker/,
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute.

C<plug_installed_module_checker>

    plug_installed_module_checker => [
        qw/ Image::Resize
            Foo::Bar::Baz
            Carp
        /,
    ],

B<Mandatory>. Takes an arrayref as a value.
Can be specified in either ZofCMS Template or Main Config File; if set in
both, the value in ZofCMS Template takes precedence. Each element of the arrayref
must be a module name that you wish to check for "installedness".

OUTPUT

    <ul>
        <tmpl_loop name='plug_installed_module_checker'>
        <li>
            <tmpl_var escape='html' name='info'>
        </li>
        </tmpl_loop>
    </ul>

Plugin will set C<< $t->{t}{plug_installed_module_checker} >> (where C<$t> is ZofCMS Template
hashref) to an arrayref of hashrefs; thus, you'd use a C<< <tmpl_loop> >> to view the info.
Each hashref will have only one key - C<info> - with information about whether or
not a particular module is installed.


=head1 App::ZofCMS::Plugin::JavaScriptMinifier (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::JavaScriptMinifier>



App::ZofCMS::Plugin::JavaScriptMinifier - plugin for minifying JavaScript files

SYNOPSIS

In your ZofCMS Template or Main Config File:

    plugins => [
        qw/JavaScriptMinifier/,
    ],

    plug_js_minifier => {
        file => 'main.js',
    },

Now, this page can be linked into your document as a JavaScript file (it 
will be minified)

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to send minified JavaScript files.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

WTF IS MINIFIED?

Minified means that all the useless stuff (which means whitespace, etc)
will be stripped off the JavaScript file to save a few bytes. See L<JavaScript::Minifier> for more info.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/JavaScriptMinifier/,
    ],

B<Mandatory>. You need to include the plugin to the list of plugins to execute.

C<plug_js_minifier>

    plug_js_minifier => {
        file        => 'main.js',
        auto_output => 1, # default value
        cache       => 1, # default value
    },

    plug_js_minifier => sub {
        my ( $t, $q, $config ) = @_;
        return {
            file        => 'main.js',
            auto_output => 1,
            cache       => 1,
        };
    },

B<Mandatory>. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_js_minifier> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Individual keys can be set in both Main Config
File and ZofCMS Template, if the same key set in both, the value in ZofCMS Template will
take precedence. The following keys/values are accepted:

C<file>

    plug_js_minifier => {
        file        => 'main.js',
    }

B<Mandatory>. Takes a string as an argument that specifies the name of the 
JavaScript file to minify. The filename is relative to C<index.pl> file.

C<cache>

    plug_js_minifier => {
        file        => 'main.js',
        cache       => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value the plugin will
send out an HTTP C<Expires> header that will say that this content expries in like 2038, thus
B<set this option to a false value while still developing your JavaScript>. This argument
has no effect when C<auto_output> (see below) is turned off (set to a false value).
B<Defaults to:> C<1>

C<auto_output>

    plug_js_minifier => {
        file        => 'main.js',
        auto_output => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value, plugin will
automatically send C<text/javascript> C<Content-type> header (along with C<Expires> header if
C<cache> argument is set to a true value), output the minified JavaScript file B<and exit()>.
Otherwise, the minified JavaScript file will be put into C<< $t->{t}{plug_js_minifier} >>
where C<$t> is ZofCMS Template hashref and you can do whatever you want with it.
B<Defaults to:> C<1>


=head1 App::ZofCMS::Plugin::LinkifyText (version 0.0110)

NAME


Link: L<App::ZofCMS::Plugin::LinkifyText>



App::ZofCMS::Plugin::LinkifyText - plugin to convert links in plain text into proper HTML <a> elements

SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/LinkifyText/,
    ],

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        encode_entities => 1, # this one and all below are optional; default values are shown
        new_lines_as_br => 1,
        cell => 't',
        key  => 'plug_linkify_text',
        callback => sub {
            my $uri = encode_entities $_[0];
            return qq|<a href="$uri">$uri</a>|;
        },
    },

In HTML::Template template:

    <tmpl_var name='plug_linkify_text'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means convert
URIs found in plain text into proper <a href=""> HTML elements.

This documentation assumes you've read L<App::ZofCMS>, 
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/LinkifyText/,
    ],

B<Mandatory>. You need to include the plugin to the list of plugins to execute.

C<plug_linkify_text>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        encode_entities => 1,
        new_lines_as_br => 1,
        cell => 't',
        key  => 'plug_linkify_text',
        callback => sub {
            my $uri = encode_entities $_[0];
            return qq|<a href="$uri">$uri</a>|;
        },
    },

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        encode_entities => 1,
        new_lines_as_br => 1,
        cell => 't',
        key  => 'plug_linkify_text',
        callback => sub {
            my $uri = encode_entities $_[0];
            return qq|<a href="$uri">$uri</a>|;
        },
    },

    plug_linkify_text => sub {
        my ( $t, $q, $config ) = @_;
        return {
            text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        }
    }

B<Mandatory>. Takes a hashref or a subref as a value; individual keys can be set in
both Main Config
File and ZofCMS Template, if the same key set in both, the value in ZofCMS 
Template will
take precedence. If subref is specified,
its return value will be assigned to C<plug_linkify_text> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
The following keys/values are accepted:

C<text>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
    }

    plug_linkify_text => {
        text => [
            qq|http://zoffix.com|,
            qq|foo\nbar\nhaslayout.net|,
        ]
    }

    plug_linkify_text => {
        text => sub {
            my ( $t, $q, $config ) = @_;
            return $q->{text_to_linkify};
        },
    }

    plug_linkify_text => {
        text  => \[ qw/replies  reply_text/ ],
        text2 => 'post_text',
        text3 => [ qw/comments  comment_text  comment_link_text/ ],
    }

B<Pseudo-Mandatory>; if not specified (or C<undef>) plugin will not run.
Takes a wide range of values:

subref

    plug_linkify_text => {
        text => sub {
            my ( $t, $q, $config ) = @_;
            return $q->{text_to_linkify};
        },
    }

If set to a subref, the sub's C<@_> will contain C<$t>, C<$q>,
and C<$config> (in that order), where C<$t> is ZofCMS Template hashref,
C<$q> is query parameter hashref, and C<$config> is L<App::ZofCMS::Config>
object. The return value from the sub can be any valid value accepted
by the C<text> argument (except the subref) and the plugin will proceed
as if the returned value was assigned to C<text> in the first place
(including the C<undef>, upon which the plugin will stop executing).

scalar

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
    }

If set to a scalar, the plugin will interpret the scalar as the string
that needs to be linkified (i.e. links in the text changed to HTML links).
Processed string will be stored into C<key> key under C<cell> first-level
key (see the description for these below).

arraref

    plug_linkify_text => {
        text => [
            qq|http://zoffix.com|,
            qq|http://zoffix.com|,
        ]
    }

    # output:
    $VAR1 = {
        't' => 'plug_linkify_text' => [
            { text => '<a href="http://zoffix.com/">http://zoffix.com/</a>' },
            { text => '<a href="http://zoffix.com/">http://zoffix.com/</a>' },
    };

If set to an arrayref, each element of that arrayref will be taken
as a string that needs to be linkified. The output will be stored 
into C<key> key under C<cell> first-level key, and that output will be
an arrayref of hashrefs. Each hashref will have only one key - C<text> -
value of which is the converted text (thus you can use this arrayref
directly in C<< <tmpl_loop> >>)

a ref of a ref

    plug_linkify_text => {
        text  => \[ qw/replies  reply_text/ ],
        text2 => 'post_text',
        text3 => [ qw/comments  comment_text  comment_link_text/ ],
    }

Lastly, C<text> can be set to a... ref of a ref (bare with me). I think
it's easier to understand the functionality when it's viewed as a
following sequential process:

When C<text> is set to a ref of a ref, the plugin enables the I<inplace>
edit mode. This is as far as this goes, and plugin dereferences this
ref of a ref into an arrayref or a scalarref. Along with a simple scalar,
these entities can be assigned to any I<extra> C<text> keys (see below).
What I<inplace> edit mode means is that C<text> no longer contains direct
strings of text to linkify, but rather an address of where to find,
and edit, those strings.

When I<inplace> mode is turned on, you can tell plugin to linkify
multiple places. In order to specify another address for a string to edit,
simply add another C<text> postfixed with a number (e.g. C<text4>; what
the actual number is does not matter, the key just needs to match 
C<qr/^text\d+$/>). The values of all the B<extra> C<text> keys do not have
to be refs of refs, but rather can be either scalars, scalarrefs
or arrayrefs.

A scalar and scalarref have same meaning here, i.e. the scalarref will
be automatically dereferenced into a scalar. A simple scalar tells the
plugin that the value of this scalar is the name of a key inside 
C<{t}> ZofCMS Template special key, value of which contains the text to
be linkified. The plugin will directly modify (linkify) that text. This
can be used, for example, when you use L<App::ZofCMS::Plugin::DBI> plugin's
"single" retrieval mode.

The arrayrefs have different meaning. Their purpose is to process
B<arrayrefs of hashrefs> (this will probably conjure up 
L<App::ZofCMS::Plugin::DBI> plugin's output in your mind). The first
item in the arrayref represents the name of the key inside the
C<{t}> ZofCMS Template special key's hashref; the value of that key is
the arrayref of hashrefs. All the following (one or more) items in the
arrayref represent hashref keys that point to data to linkify.

Let's take a look at actual code examples. Let's imagine your C<{t}>
special key contains the following arrayref, say, put there by DBI plugin;
this arrayref is referenced by a C<dbi_output> key here. Also in the
example, the C<dbi_output_single> is set to a scalar, a string of text that
we want to linkify:

    dbi_output => [
        { ex => 'foo', ex2 => 'bar' },
        { ex => 'ber', ex2 => 'beer' },
        { ex => 'baz', ex2 => 'craz' },
    ],
    dbi_output_single => 'some random text',

If you want to linkify all the texts inside C<dbi_output>
to which the C<ex> keys point, you'd set C<text> value as
C<< text => \[ qw/dbi_output  ex/ ] >>. If you want to linkify the C<ex2>
data as well, then you'd set C<text> as
C<< text => \[ qw/dbi_output  ex  ex2/ ] >>. Can you guess what the code
to linkify I<all> the text in the example above will be? Here it is:

    # note that we are assigning a REF of an arrayref to the first `text`
    plug_linkify_text => {
        text    => \[
            'dbi_output',  # the key inside {t}
            'ex', 'ex2'    # keys of individual hashrefs that point to data
        ],
        text2   => 'dbi_output_single', # note that we didn't have to make this a ref
    }
    
    # here's an alternative version that does the same thing:
    plug_linkify_text => {
        text    => \\'dbi_output_single', # note that this is a ref of a ref
        text554 => [  # this now doesn't have to be a ref of a ref
            'dbi_output',  # the key inside {t}
            'ex', 'ex2'    # keys of individual hashrefs that point to data
        ],
    }

C<encode_entities>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        encode_entities => 1,
    }

B<Optional>. Takes either true or false values. When set to a true
value, plugin will encode HTML entities in the provided text before
processing URIs. B<Defaults to:> C<1>

C<new_lines_as_br>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        new_lines_as_br => 1,
    }

B<Optional>. Applies only when C<encode_entities> (see above) is set
to a true value. Takes either true or false values. When set to
a true value, the plugin will convert anything that matches C</\r?\n/>
into HTML <br> element. B<Defaults to:> C<1>

C<cell>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        cell => 't',
    }

B<Optional>. Takes a literal string as a value. Specifies the name
of the B<first-level> key in ZofCMS Template hashref into which to put
the result; this key must point to either an undef value or a hashref.
See C<key> argument below as well.
B<Defaults to:> C<t>

C<key>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        key  => 'plug_linkify_text',
    }

B<Optional>. Takes a literal string as a value. Specifies the name
of the B<second-level> key that is inside C<cell> (see above) key - 
plugin's output will be stored into this key.
B<Defaults to:> C<plug_linkify_text>

C<callback>

    plug_linkify_text => {
        text => qq|http://zoffix.com foo\nbar\nhaslayout.net|,
        callback => sub {
            my $uri = encode_entities $_[0];
            return qq|<a href="$uri">$uri</a>|;
        },
    },

B<Optional>. Takes a subref as a value. This subref will be used
as the "callback" sub in L<URI::Find::Schemeless>'s C<find()> method.
See L<URI::Find::Schemeless> for details. B<Defaults to:>

    sub {
        my $uri = encode_entities $_[0];
        return qq|<a href="$uri">$uri</a>|;
    },


=head1 App::ZofCMS::Plugin::LinksToSpecs::CSS (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::LinksToSpecs::CSS>



App::ZofCMS::Plugin::LinksToSpecs::CSS - easily include links to properties in CSS2.1 specification

SYNOPSIS

In your ZofCMS template:

    plugins => [ qw/LinksToSpecs::CSS/ ],

In your L<HTML::Template> template:

    See: <tmpl_var name="css_text-align"> for text-align property<br>
    See: <tmpl_var name="css_display"> for display propery<br>
    <tmpl_var name="css_float_p"> is quite neat

DESCRIPTION

The module is a plugin for ZofCMS which allows you to easily link to
CSS properties in CSS2.1 specification. Personally, I use it when writing
my tutorials, hopefully it will be useful to someone else as well.

ZofCMS TEMPLATE

    plugins => [ qw/LinksToSpecs::CSS/ ],

The only thing you'd need in your ZofCMS template is to add the plugin
into the list of plugins to execute.

HTML::Template TEMPLATE

    See: <tmpl_var name="css_text-align"> for text-align property<br>
    See: <tmpl_var name="css_display"> for display propery<br>
    <tmpl_var name="css_float_p"> is quite neat

To include links to CSS properties in your HTML code you'd use
C<< <tmpl_var name=""> >>. The plugin provides four "styles" of links which
are presented below. The C<PROP> stands for any CSS property specified in
CSS2.1 specification, C<LINK> stands for the link pointing to the
explaination of the given property in CSS specification. B<Note:>
everything needs to be lowercased:

    <tmpl_var name="css_PROP">
    <a href="LINK" title="CSS Specification: 'PROP' property"><code>PROP</code></a>

    <tmpl_var name="css_PROP_p">
    <a href="LINK" title="CSS Specification: 'PROP' property"><code>PROP</code> property</a>

    <tmpl_var name="css_PROP_c">
    <a href="LINK" title="CSS Specification: 'PROP' property">PROP</a>

    <tmpl_var name="css_PROP_cp">
    <a href="LINK" title="CSS Specification: 'PROP' property">PROP property</a>

The plugin also has links for C<:after>, C<:hover>, etc. pseudo-classes and pseudo-elements;
in this case, the rules are the same except in the output word "property" would say
"pseudo-class" or "pseudo-element".

SEE ALSO

L<http://w3.org/Style/CSS/>


=head1 App::ZofCMS::Plugin::LinksToSpecs::HTML (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::LinksToSpecs::HTML>



App::ZofCMS::Plugin::LinksToSpecs::HTML - easily include links to elements in HTML 4.01 specification

SYNOPSIS

In your ZofCMS template:

    plugins => [ qw/LinksToSpecs::HTML/ ],

In your L<HTML::Template> template:

    See: <tmpl_var name="html_div"> for div element<br>
    See: <tmpl_var name="html_blockquote"> for blockquote element<br>
    <tmpl_var name="html_a_ce"> is used for links.

DESCRIPTION

The module is a plugin for ZofCMS which allows you to easily link to
HTML elements in HTML 4.01 specification. Personally, I use it when writing
my tutorials, hopefully it will be useful to someone else as well.

ZofCMS TEMPLATE

    plugins => [ qw/LinksToSpecs::HTML/ ],

The only thing you'd need in your ZofCMS template is to add the plugin
into the list of plugins to execute.

HTML::Template TEMPLATE

    See: <tmpl_var name="html_div"> for div element<br>
    See: <tmpl_var name="html_blockquote"> for blockquote element<br>
    <tmpl_var name="html_a_ce"> is used for links.

To include links to HTML elements in your HTML code you'd use
C<< <tmpl_var name=""> >>. The plugin provides four "styles" of links which
are presented below. The C<EL> stands for any HTML element specified in
HTML 4.01 specification, C<LINK> stands for the link pointing to the
explaination of the given element in HTML specification. B<Note:>
everything needs to be lowercased:

    <tmpl_var name="html_EL">
    <a href="LINK" title="HTML Specification: '&amp;lt;EL&amp;gt;' element"><code>&amp;lt;EL&amp;gt;</code></a>

    <tmpl_var name="html_EL_e">
    <a href="LINK" title="HTML Specification: '&amp;lt;EL&amp;gt;' element"><code>&amp;lt;EL&amp;gt;</code> element</a>

    <tmpl_var name="html_EL_c">
    <a href="LINK" title="HTML Specification: '&amp;lt;EL&amp;gt;' element">&amp;lt;EL&amp;gt;</a>

    <tmpl_var name="html_EL_ce">
    <a href="LINK" title="HTML Specification: '&amp;lt;EL&amp;gt;' element">&amp;lt;EL&amp;gt; element</a>

SEE ALSO

L<http://www.w3.org/TR/html4/>


=head1 App::ZofCMS::Plugin::NavMaker (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::NavMaker>



App::ZofCMS::Plugin::NavMaker - ZofCMS plugin for making navigation bars

SYNOPSIS

In your Main Config File or ZofCMS Template:

    nav_maker => [
        qw/Foo Bar Baz/,
        [ qw(Home /home) ],
        [ qw(Music /music) ],
        [ qw(foo /foo-bar-baz), 'This is the title=""', 'this_is_id' ],
    ],
    plugins => [ qw/NavMaker/ ],

In your L<HTML::Template> template:

    <tmpl_var name="nav_maker">

Produces this code:

    <ul id="nav">
            <li id="nav_foo"><a href="/foo" title="Visit Foo">Foo</a></li>
            <li id="nav_bar"><a href="/bar" title="Visit Bar">Bar</a></li>
            <li id="nav_baz"><a href="/baz" title="Visit Baz">Baz</a></li>
            <li id="nav_home"><a href="/home" title="Visit Home">Home</a></li>
            <li id="nav_music"><a href="/music" title="Visit Music">Music</a></li>
            <li id="this_is_id"><a href="/foo-bar-baz" title="This is the title=&quot;&quot;">foo</a></li>
    </ul>

DESCRIPTION

The plugin doesn't do much but after writing HTML code for hundreds of
navigation bars I was fed up... and released this tiny plugin.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST LEVEL KEYS

C<plugins>

    plugins => [ qw/NavMaker/ ],

The obvious one is that you'd want to add C<NavMaker> into the list of
your plugins.

C<nav_maker>

    nav_maker => [
        qw/Foo Bar Baz/,
        [ qw(Home /home) ],
        [ qw(Music /music) ],
        [ qw(foo /foo-bar-baz), 'This is the title=""', 'this_is_id' ],
    ],

    nav_maker => sub {
        my ( $template, $query, $config ) = @_;

        return [
            qw/Foo Bar Baz/,
            [ qw(Home /home) ],
            [ qw(Music /music) ],
            [ qw(foo /foo-bar-baz), 'This is the title=""', 'this_is_id' ],
        ];
    }

Can be specified in either Main Config File first-level key or ZofCMS template first-level
key. If specified in both, the one in ZofCMS Template will take precedence.
Takes an arrayref or a subref as a value. If the value is a B<subref>, it must return
an arrayref, which will be processed the same way as if the returned arrayref would be
assigned to C<nav_maker> key instead of the subref (see description further). The C<@_> of
the sub will contain the following: C<$template>, C<$query> and C<$config> (in that
order), where C<$template> is the ZofCMS Template hashref, C<$query> is the query parameters
(param names are keys and values are their values) and C<$config> is the
L<App::ZofCMS::Config> object.

The elements of the arrayref (whether directly assigned or returned from the subref)
can either be strings
or arrayrefs, element which is a string is the same as an arrayref with just
that string as an element. Each of those arrayrefs can contain from one
to four elements. They are interpreted as follows:

first element

    nav_maker => [ qw/Foo Bar Baz/ ],

    # same as

    nav_maker => [
        [ 'Foo' ],
        [ 'Bar' ],
        [ 'Baz' ],
    ],

B<Mandatory>. Specifies the text to use for the link.

second element

    nav_maker => [
        [ Foo => '/foo' ],
    ],

B<Optional>. Specifies the C<href=""> attribute for the link. If not
specified will be calculated from the first element (the text for the link)
in the following way:

    $text =~ s/[\W_]/-/g;
    return lc "/$text";

third element

    nav_maker => [
        [ 'Foo', '/foo', 'Title text' ],
    ],

B<Optional>. Specifies the C<title=""> attribute for the link. If not
specified the first element (the text for the link) will be used for the
title with word C<Visit > prepended.

fourth element

    nav_maker => [
        [ 'Foo', '/foo', 'Title text', 'id_of_the_li' ]
    ],

B<Optional>. Specifies the C<id=""> attribute for the C<< <li> >> element
of this navigation bar item. If not specified will be calculated from the
first element (the text of the link) in the following way:

    $text =~ s/\W/_/g;
    return lc "nav_$text";

USED HTML::Template VARIABLES

C<nav_maker>

    <tmpl_var name="nav_maker">

Plugin sets C<nav_maker> key in C<{t}> ZofCMS template special key, to
the generated HTML code, simply stick C<< <tmpl_var name="nav_maker"> >>
whereever you wish to have your navigation.


=head1 App::ZofCMS::Plugin::PreferentialOrder (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::PreferentialOrder>



App::ZofCMS::Plugin::PreferentialOrder - Display HTML snippets in user-controllable, savable order

EXTRA RESOURCES (BEYOND PERL)

This plugin was designed to be used in conjunction with JavaScript (JS)
code that controls the order of items on the page and submits that
information to the server.

If you wish to use a different, your own front-end, please study JS code
provided at the end of this documentation to understand what is required.

SYNOPSIS

In your L<HTML::Template> template:

    <tmpl_var name='plug_pref_order_form'>
    <tmpl_var name='plug_pref_order_list'>
    <tmpl_var name='plug_pref_order_disabled_list'>

In your ZofCMS template:

    plugins => [ qw/PreferentialOrder/, ],

    # except for the mandatory argument `items`, the default values are shown
    plug_preferential_order => {
        items => [ # four value type variations shown here
            forum3  => '<a href="#">Forum3</a>',
            forum4  => [ 'Last forum ":)"',   \'forum-template.tmpl', ],
            forum   => [ 'First forum ":)"',  '<a href="#">Forum</a>',  ],
            forum2  => [
                'Second forum ":)"',
                sub {
                    my ( $t, $q, $config ) = @_;
                    return '$value_for_the_second_element_in_the_arrayref';
                },
            ],
        ],
        dsn            => "DBI:mysql:database=test;host=localhost",
        user           => '',
        pass           => undef,
        opt            => { RaiseError => 1, AutoCommit => 1 },
        users_table    => 'users',
        order_col      => 'plug_pref_order',
        login_col      => 'login',
        order_login    => sub { $_[0]->{d}{user}{login} },
        separator      => ',',
        has_disabled   => 1,
        enabled_label  => q|<p class="ppof_label">Enabled items</p>|,
        disabled_label => q|<p class="ppof_label">Disabled items</p>|,
        submit_button  => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to have a 
sortable list of custom HTML snippets. The order can be defined by each
individual user to suit their needs. The order is defined using a form
provided by the plugin, the actual sorting is done by 
I<MooTools> (L<http://mootools.net>) JS framework. Use of this framework
is not a necessity; it's up to you what you'll use as a front-end. An
example of MooTools front-end is provided at the end of this documentation.

The plugin provides two modes: single sortable list, and double lists,
where the second list represents "disabled" items, although that can
well be used for having two lists with items being sorted between each of
them (e.g. primary and secondary navigations).

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/PreferentialOrder/ ],

B<Mandatory>. You need to include the plugin in the list of plugins to 
execute.

C<plug_preferential_order>

    # except for the mandatory argument `items`, the default values are shown
    plug_preferential_order => {
        items => [ # four value type variations shown here
            forum3  => '<a href="#">Forum3</a>',
            forum4  => [ 'Last forum ":)"',   \'forum-template.tmpl', ],
            forum   => [ 'First forum ":)"',  '<a href="#">Forum</a>',  ],
            forum2  => [
                'Second forum ":)"',
                sub {
                    my ( $t, $q, $config ) = @_;
                    return '$value_for_the_second_element_in_the_arrayref';
                },
            ],
        ],
        dsn            => "DBI:mysql:database=test;host=localhost",
        user           => '',
        pass           => undef,
        opt            => { RaiseError => 1, AutoCommit => 1 },
        users_table    => 'users',
        order_col      => 'plug_pref_order',
        login_col      => 'login',
        order_login    => sub { $_[0]->{d}{user}{login} },
        separator      => ',',
        has_disabled   => 1,
        enabled_label  => q|<p class="ppof_label">Enabled items</p>|,
        disabled_label => q|<p class="ppof_label">Disabled items</p>|,
        submit_button  => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    },

    # or
    plug_preferential_order => sub {
        my ( $t, $q, $config ) = @_;
        return $hashref_to_assign_to_the_plug_key;
    },

B<Mandatory>. Takes either an C<undef>, a hashref or a subref as a value.
If subref is
specified, its return value will be assigned to C<plug_preferential_order>
as if it was already there. If C<undef> is specified or the sub returns
one, then plugin will
stop further processing. The C<@_> of the subref will contain C<$t>,
C<$q>, and C<$config> (in that
order), where C<$t> is ZofCMS Tempalate hashref, C<$q> is query parameter
hashref and C<$config> is L<App::ZofCMS::Config> object. Possible
keys/values for the hashref are as follows:

C<items>

    plug_preferential_order => {
        items => [ # four value type variations shown here
            forum3  => '<a href="#">Forum3</a>',
            forum4  => [ 'Last forum ":)"',   \'forum-template.tmpl', ],
            forum   => [ 'First forum ":)"',  '<a href="#">Forum</a>',  ],
            forum2  => [
                'Second forum ":)"',
                sub {
                    my ( $t, $q, $config ) = @_;
                    return '$value_for_the_second_element_in_the_arrayref';
                },
            ],
        ],
    ...

    plug_preferential_order => {
        items => sub {
            my ( $t, $q, $config ) = @_;
            return $items_arrayref;
        },
    ...

B<Mandatory>. Takes an arrayref, a subref or C<undef> as a value. If set to
C<undef> (i.e. not specified), plugin will not execute. If a subref is
specified, its return value will be assigned to C<items> as if it was
already there. The C<@_> of the subref will contain C<$t>,
C<$q>, and C<$config> (in that order), where C<$t> is ZofCMS Tempalate
hashref, C<$q> is query parameter hashref and C<$config> is
L<App::ZofCMS::Config> object. This argument tells the plugin the items on
the list you want the user to sort and use.

The insides of the arrayref are best to be thought as keys/values of a
hashref; the reason for the arrayref is to preserve the original order. The
"keys" of the arrayref must B<NOT> contain C<separator> (see below) and
need to conform to HTML/Your-markup-language C<id> attribute
(L<http://xrl.us/bicips>). These keys are used by the plugin
to label the items in the form that the user uses to sort their lists, the
labels for the actual list items when they are displayed, as
well as labels stored in the SQL table for each user.

The "value" of the "key" in the arrayref can be a scalar, a scalarref,
a subref, as well as an arrayref with two items, first being a scalar and
the second one being either a scalar, a scalarref, or a subref.

When the value is a scalar, scalarref or subref, it will be internally
converted to an arrayref with the value being the second item, and the first
item being the "key" of this "value" in the arrayref. In other words, these
two codes are equivalent:

    items => [ foo => 'bar', ],

    items => [ foo => [ 'foo', 'bar', ], ],

The first item in the inner arrayref specifies the human readable name of
the HTML snippet. This will be presented to the user in the sorting form.
The second item represents the actual snippet and it can be specified
using one of the following three ways:

a subref

    items => [
        foo => [
            bar => sub {
                my ( $t, $q, $config ) = @_;
                return 'scalar or scalarref to represent the actual snippet';
            },
        ],
    ],

If the second item is a subref, its C<@_> will contain C<$t>, C<$q>, and
C<$config> (in that order) where C<$t> is ZofCMS Template hashref,
C<$q> is query parameter hashref, and C<$config> is L<App::ZofCMS::Config>
object. The sub must return either a scalar or a scalarref that will be
assigned to the "key" instead of this subref.

a scalar

    items => [
        foo => [
            bar => [ bez => '<a href="#"><tmpl_var name="meow"></a>', ],
        ],
    ],

If the second item is a scalar, it will be interpreted as a snippet of
L<HTML::Template> template. The parameters will be set into this snippet
from C<{t}> ZofCMS Template special key.

a scalarref

    items => [
        foo => [
            bar => [ bez => \'template.tmpl', ],
        ],
    ],

If the second item is a scalaref, its meaning and function is the same as
for the scalar value, except the L<HTML::Template> template snippet will be
read from the filename specified by the scalarref. Relative paths here
will be relative to C<index.pl> file.

C<dsn>

    plug_preferential_order => {
        dsn => "DBI:mysql:database=test;host=localhost",
    ...

B<Optional, but with useless default value>. The dsn key will be passed to 
L<DBI>'s C<connect_cached()> method, see documentation for L<DBI> and
C<DBD::your_database> for the correct syntax for this one. The example
above uses MySQL database called C<test> that is located on C<localhost>.
B<Defaults to:> C<DBI:mysql:database=test;host=localhost>

C<user>

    plug_preferential_order => {
        user => '',
    ...

B<Optional>. Specifies the user name (login) for the database. This can be
an empty string if, for example, you are connecting using SQLite driver.
B<Defaults to:> empty string

C<pass>

    plug_preferential_order => {
        pass => undef,
    ...

B<Optional>. Same as C<user> except specifies the password for the
database. B<Defaults to:> C<undef> (no password)

C<opt>

    plug_preferential_order => {
        opt => { RaiseError => 1, AutoCommit => 1 },
    ...

B<Optional>. Will be passed directly to L<DBI>'s C<connect_cached()>
method as "options". B<Defaults to:>
C<< { RaiseError => 1, AutoCommit => 1 } >>

C<users_table>

    plug_preferential_order => {
        users_table => 'users',
    ...
    
    # This is the minimal SQL table needed by the plugin:
    CREATE TABLE `users` (
        `login`           TEXT,
        `plug_pref_order` TEXT
    );

B<Optional>. Takes a scalar as a value that represents the table into which 
to store users' sort orders. The table can be anything you want, but must
at least contain two columns (see C<order_col> and C<login_col> below).
B<Defaults to:> C<users>

C<order_col>

    plug_preferential_order => {
        order_col => 'plug_pref_order',
    ...

B<Optional>. Takes a scalar as a value. Specifies the name of the column in 
the C<users_table> table into which to store users' sort orders. The
orders will be stored as strings, so the column must have appropriate type.
B<Defaults to:> C<plug_pref_order>

C<login_col>

    plug_preferential_order => {
        login_col => 'login',
    ...

B<Optional>. Takes a scalar as a value. Specifies the name of the column 
in the C<users_table> table in which users' logins are stored. The
plugin will use the values in this column only to look up appropriate 
C<order_col> columns, thus the data type can be anything you want.
B<Defaults to:> C<login>

C<order_login>

    plug_preferential_order => {
        order_login => sub {
            my ( $t, $q, $config ) = @_;
            return $t->{d}{user}{login};
        },
    ...

    plug_preferential_order => {
        order_login => 'zoffix',
    ...

B<Optional>. Takes a scalar, C<undef>, or a subref as a value. If
set to C<undef> (not specified) the plugin will not run.
If subref is specified, its return value will be assigned to 
C<order_login> as it was already there. The C<@_> will contain C<$t>, 
C<$q>, and C<$config> (in that order) where C<$t> is ZofCMS Template
hashref, C<$q> is query parameter hashref, and C<$config> is
L<App::ZofCMS::Config> object. The scalar value specifies the
"login" of the current user; this will be used to get and
store the C<order_col> value based on the C<order_login> present in the
C<login_col> column in the C<users_table> table.
B<Defaults to:> C<< sub { $_[0]->{d}{user}{login} } >>

C<separator>

    plug_preferential_order => {
        separator => ',',
    ...

B<Optional>. Specifies the separator that will be used to join together
sort order before sticking it into the database. B<IMPORTANT:> your JS
code must use the same separator to join together the sort order items
when user submits the sorting form. B<Defaults to:> C<,> (a comma)

C<has_disabled>

    plug_preferential_order => {
        has_disabled => 1,
    ...

B<Optional>. Takes either true or false values as a value. When set to a 
true value, the plugin will present the user with two lists, with the
items movable between the two. When set to a false value, the plugin
will show the user only one sortable list.

If the order was stored between the I<two> lists, but then the second list
becomes disabled, the previously disabled items will be appended to the end 
of the first list (both in the display list, and in the sorting form). If
the second list becomes enabled B<before the user saves the single-list
order>, the divisions between the two lists will be preserved.

Originally, this was designed to have "enabled" and "disabled" groups of
items, hence the naming of this and few other options; the "enabled" 
represents the list that is always shown, and the "disabled" represents
the list that is toggleable with C<has_disabled> argument. B<Defaults to:>
C<1> (second list is enabled)

C<enabled_label>

    plug_preferential_order => {
        enabled_label => q|<p class="ppof_label">Enabled items</p>|,
    ...

B<Optional>. Applies only when C<has_disabled> is set to a true value. 
Takes HTML code as a value that will be shown above the "enabled" list
of items inside the sorting form.
B<Defaults to:> C<< <p class="ppof_label">Enabled items</p> >>

C<disabled_label>

    plug_preferential_order => {
        disabled_label => q|<p class="ppof_label">Disabled items</p>|,
    ...

B<Optional>. Applies only when C<has_disabled> is set to a true value. 
Takes HTML code as a value that will be shown above the "disabled" list
of items inside the sorting form.
B<Defaults to:> C<< <p class="ppof_label">Disabled items</p> >>

C<submit_button>

    plug_preferential_order => {
        submit_button => q|<input type="submit" class="input_submit"|
                            . q| value="Save">|,
    ...

B<Optional>. Takes HTML code as a value that represents the submit
button on the sorting form. This was designed with the idea to allow
image button use; however, feel free to insert here any extra HTML code you
require in your form. B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Save"> >>

HTML::Template TEMPLATE VARIABLES

    <tmpl_var name='plug_pref_order_form'>
    <tmpl_var name='plug_pref_order_list'>
    <tmpl_var name='plug_pref_order_disabled_list'>

The plugin operates through three L<HTML::Template> variables that you
can use in any combination. These are as follows:

C<plug_pref_order_form>

    <tmpl_var name='plug_pref_order_form'>

This variable contains the sorting form.

C<plug_pref_order_list>

    <tmpl_var name='plug_pref_order_list'>

This variable contains the "enabled" list. If C<has_disabled> is turned
off while the user has some items in their "disabled" list; all of them
will be appended to the "enabled" list.

C<plug_pref_order_disabled_list>

    <tmpl_var name='plug_pref_order_disabled_list'>

This variable contains the "disabled" list. If C<has_disabled> is turned
off while the user has some items in their "disabled" list; all of them
will be appended to the "enabled" list, and this ("disabled") list will be
empty.

SAMPLE JavaScript CODE TO USED WITH THE PLUGIN

This code relies on I<MooTools> (L<http://mootools.net>) JS framework to 
operate. (I<Note:> this code also includes non-essential bit to make the
enabled and disabled lists of constant size)

    window.onload = function() {
        setup_sortables();
    }
    
    function setup_sortables() {
        var els_list = $$('.ppof_list li');
        var total_height = 0;
        for ( var i = 0, l = els_list.length; i < l; i++ ) {
            total_height += els_list[i].getSize().y;
        }
        $$('.ppof_list').set({'styles': {'min-height': total_height}});
    
        var mySortables = new Sortables('#ppof_order, #ppof_order_disabled', {
            'constraint': true,
            'clone': true,
            'opacity': 0.3
        });
    
        mySortables.attach();
        $('ppof_order').zof_sortables = mySortables;
        $('plug_preferential_order_form').onsubmit = add_sorted_list_input;
    }
    
    function add_sorted_list_input() {
        var result = $('ppof_order').zof_sortables.serialize(
            0,
            function(element, index){
                return element.getProperty('id').replace('ppof_order_item_','');
            }
        ).join(',');
    
        var result_el = new Element ('input', {
            'type': 'hidden',
            'name': 'ppof_order',
            'value': result
        });
        result_el.inject(this);
    
        var result_disabled = $('ppof_order').zof_sortables.serialize(
            1,
            function(element, index){
                return element.getProperty('id').replace('ppof_order_item_','');
            }
        ).join(',');
    
        var result_el_disabled = new Element ('input', {
            'type': 'hidden',
            'name': 'ppof_order_disabled',
            'value': result_disabled
        });
        result_el_disabled.inject(this);
        return true;
    }

SAMPLE CSS CODE USED BY THE PLUGIN

This is just a quick and ugly sample CSS code to give your lists some
structure for you to quickly play with the plugin to decide if you need it:

    #ppof_enabled_container,
    #ppof_disabled_container {
        width: 400px;
        float: left;
    }
    
    .ppof_label {
        text-align: center;
        font-size: 90%;
        font-weight: bold;
        letter-spacing: -1px;
        padding: 0;
        margin: 0;
    }
    
    .success-message {
        color: #aa0;
        font-weight: bold;
        font-size: 90%;
    }
    
    .ppof_list {
        list-style: none;
        border: 1px solid #ccc;
        min-height: 20px;
        padding: 0;
        margin: 0 0 7px;
        background: #ffd;
    }
    
    .ppof_list li {
        padding: 10px;
        background: #ddd;
        border: 1px solid #aaa;
        position: relative;
    }
    
    #plug_preferential_order_form .input_submit {
        clear: both;
        display: block;
    }

HTML CODE GENERATED BY THE PLUGIN

Sorting Form

    <!-- Double list (has_disabled is set to a true value) -->
    <form action="" method="POST" id="plug_preferential_order_form">
    <div>
        <input type="hidden" name="page" value="/index">
        <input type="hidden" name="ppof_save_order" value="1">

        <div id="ppof_enabled_container">
            <p class="ppof_label">Enabled items</p>
            <ul id="ppof_order" class="ppof_list">
                <li id="ppof_order_item_forum4">Last forum ":)"</li>
                <li id="ppof_order_item_forum">First forum ":)"</li>
            </ul>
        </div>

        <div id="ppof_enabled_container">
            <p class="ppof_label">Disabled items</p>
            <ul id="ppof_order_disabled" class="ppof_list">
                <li id="ppof_order_item_forum2">Second forum ":)"</li>
                <li id="ppof_order_item_forum3">forum3</li>
            </ul>
        </div>

        <input type="submit" class="input_submit" value="Save">
    </div>
    </form>

    <!-- Single list (has_disabled is set to a false value) -->
    <form action="" method="POST" id="plug_preferential_order_form">
    <div>
        <input type="hidden" name="page" value="/index">
        <input type="hidden" name="ppof_save_order" value="1">

        <div id="ppof_enabled_container">
            <ul id="ppof_order" class="ppof_list">
                <li id="ppof_order_item_forum4">Last forum ":)"</li>
                <li id="ppof_order_item_forum">First forum ":)"</li>
                <li id="ppof_order_item_forum2">Second forum ":)"</li>
                <li id="ppof_order_item_forum3">forum3</li>
            </ul>
        </div>

        <input type="submit" class="input_submit" value="Save">
    </div>
    </form>

This form shows the default arguments for C<enabled_label>,
C<disabled_label> and C<submit_button>. Note that C<id=""> attributes on
the list items are partially made out of the "keys" set in C<items>
argument. The value for C<page> hidden C<input> is derived by the 
plugin automagically.

"Enabled" Sorted List

    <ul class="plug_list_html_template">
        <li id="ppof_order_list_item_forum4">Foo:</li>
        <li id="ppof_order_list_item_forum"><a href="#">Forum</a></li>
    </ul>

The end parts of C<id=""> attributes on the list items are derived from
the "keys" in C<items> arrayref. Note that HTML in the values are
not escaped.

"Disabled" Sorted List

    <ul class="plug_list_html_template_disabled">
        <li id="ppof_order_list_disabled_item_forum2">Bar</li>
        <li id="ppof_order_list_disabled_item_forum3">Meow</li>
    </ul>

The end parts of C<id=""> attributes on the list items are derived from
the "keys" in C<items> arrayref. HTML in the values (innards of
C<< <li> >>s) are not escaped.

REQUIRED MODULES

This plugins lives on these modules:

    App::ZofCMS::Plugin::Base => 0.0106,
    DBI                       => 1.607,
    HTML::Template            => 2.9,


=head1 App::ZofCMS::Plugin::QueryToTemplate (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::QueryToTemplate>



App::ZofCMS::Plugin::QueryToTemplate - ZofCMS plugin to automagically make query parameters available in the template

SYNOPSIS

In your ZofCMS template, or in your main config file (under C<template_defaults>
or C<dir_defaults>):

    plugins => [ qw/QueryToTemplate/ ];

In any of your L<HTML::Template> templates:

    <tmpl_var name="query_SOME_QUERY_PARAMETER_NAME">

DESCRIPTION

Plugin can be run at any priority level and it does not take any input from
ZofCMS template.

Upon plugin's execution it will stuff the C<{t}> first level key (see
L<App::ZofCMS::Template> if you don't know what that key is) with all
the query parameters as keys and values being the parameter values. Each
query parameter key will be prefixed with C<query_>. In other words,
if your query looks like this:

    http://foo.com/index.pl?foo=bar&baz=beerz

In your template parameter C<foo> would be accessible as C<query_foo>
and parameter C<baz> would be accessible via C<query_baz>

    Foo is: <tmpl_var name="query_foo">
    Baz is: <tmpl_var name="query_baz">


=head1 App::ZofCMS::Plugin::QuickNote (version 0.0107)

NAME


Link: L<App::ZofCMS::Plugin::QuickNote>



App::ZofCMS::Plugin::QuickNote - drop-in "quicknote" form to email messages from your site

SYNOPSIS

In your ZofCMS template:

    # basic:
    quicknote => {
        to  => 'me@example.com',
    },

    # juicy
    quicknote => {
        mailer      => 'testfile',
        to          => [ 'foo@example.com', 'bar@example.com'],
        subject     => 'Quicknote from example.com',
        must_name   => 1,
        must_email  => 1,
        must_message => 1,
        name_max    => 20,
        email_max   => 20,
        message_max => 1000,
        success     => 'Your message has been successfuly sent',
        format      => <<'END_FORMAT',
    Quicknote from host {::{host}::} sent on {::{time}::}
    Name: {::{name}::}
    E-mail: {::{email}::}
    Message:
    {::{message}::}
    END_FORMAT
    },

In your L<HTML::Template> template:

    <tmpl_var name="quicknote">

DESCRIPTION

The module is a plugin for L<App::ZofCMS> which provides means to easily
drop-in a "quicknote" form which asks the user for his/her name, e-mail
address and a message he or she wants to send. After checking all of the
provided values plugin will e-mail the data which the visitor entered to
the address which you specified.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

HTML TEMPLATE

The only thing you'd want to add in your L<HTML::Template> is a
C<< <tmpl_var name="quicknote"> >> the data for this variable will be
put into special key C<{t}>, thus you can stick it in secondary templates.

USED FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    {
        plugins => [ qw/QuickNote/ ],
    }

First and obvious is that you'd want to include the plugin in the list
of C<plugins> to run.

C<quicknote>

    # basic:
    quicknote => {
        to  => 'me@example.com',
    },

    # juicy
    quicknote => {
        mailer      => 'testfile',
        to          => [ 'foo@example.com', 'bar@example.com'],
        subject     => 'Quicknote from example.com',
        must_name   => 1,
        must_email  => 1,
        must_message => 1,
        name_max    => 20,
        email_max   => 20,
        message_max => 1000,
        success     => 'Your message has been successfuly sent',
        format      => <<'END_FORMAT',
    Quicknote from host {::{host}::} sent on {::{time}::}
    Name: {::{name}::}
    E-mail: {::{email}::}
    Message:
    {::{message}::}
    END_FORMAT
    },

The C<quicknote> first-level ZofCMS template key is the only thing you'll
need to use to tell the plugin what to do. The key takes a hashref
as a value. The only mandatory key in that hashref is the C<to> key,
the rest have default values. Possible keys in C<quicknote> hashref are
as follows:

C<to>

    to => 'me@example.com'

    to => [ 'foo@example.com', 'bar@example.com'],

B<Mandatory>. Takes either a string or an arrayref as a value. Passing the
string is equivalent to passing an arrayref with just one element. Each
element of that arrayref must contain a valid e-mail address, upon
successful completion of the quicknote form by the visitor the data on that
form will be emailed to all of the addresses which you specify here.

C<mailer>

    mailer => 'testfile',

B<Optional>. Specifies which mailer to use for sending mail.
See documentation for L<Mail::Mailer> for possible mailers. When using the
C<testfile> mailer the file will be located in the same directory your
in which your C<index.pl> file is located. B<By default> plugin will
do the same thing L<Mail::Mailer> will (search for the first
available mailer).

C<subject>

    subject => 'Quicknote from example.com',

B<Optional>. Specifies the subject line of the quicknote e-mail.
B<Defaults to:> C<Quicknote>

C<must_name>, C<must_email> and C<must_message>

    must_name   => 1,
    must_email  => 1,
    must_message => 1,

B<Optional>. The C<must_name>, C<must_email> and C<must_message> arguments
specify whether or not the "name", "e-mail" and "message" form fields
are mandatory. When set to a true value indicate that the field is
mandatory. When set to a false value the form field will be filled with
C<N/A> unless specified by the visitor. Visitor will be shown an error
message if he or she did not specify some mandatory field.
B<By default> only the
C<must_message> argument is set to a true value (thus the vistior does
not have to fill in neither the name nor the e-mail).

C<name_max>, C<email_max> and C<message_max>

    name_max    => 20,
    email_max   => 20,
    message_max => 1000,

B<Optional>. Alike C<must_*> arguments, the
C<name_max>, C<email_max> and C<message_max> specify max lengths of
form fields. Visitor will be shown an error message if any of the
parameters exceed the specified maximum lengths. B<By default> the value
for C<name_max> is C<100>, value for C<email_max> is C<200> and
value for C<message_max> C<10000>

C<success>

    success => 'Your message has been successfuly sent',

B<Optional>. Specifies the text to display to your visitor when the
quicknote is successfuly sent. B<Defaults to:>
C<'Your message has been successfuly sent'>.

C<on_success>

    on_success => 'quicknote_success'

B<Optional>. Takes a string as a value that representes a key in C<{t}> special key. When
specified, the plugin will set the C<on_success> key in C<{t}> special key to a true value
when the quicknote has been sent; this can be used to display some special messages
when quick note succeeds. B<Defaults to:> C<quicknote_success>.

C<on_error>

    on_error => 'quicknote_error'

B<Optional>. Takes a string as a value that representes a key in C<{t}> special key. When
specified, the plugin will set the C<on_error> key in C<{t}> special key to a true value
when the quicknote has not been sent due to some error, e.g. user did not specify mandatory
parameters; this can be used to display some special messages
when quick note fails. B<By default> is not specified.

C<format>

        format      => <<'END_FORMAT',
    Quicknote from host {::{host}::} sent on {::{time}::}
    Name: {::{name}::}
    E-mail: {::{email}::}
    Message:
    {::{message}::}
    END_FORMAT

B<Optional>. Here you can specify the format of the quicknote e-mail which
plugin will send. The following special sequences will be replaced
by corresponding values:

    {::{host}::}        - the host of the person sending the quicknote
    {::{time}::}        - the time the message was sent ( localtime() )
    {::{name}::}        - the "Name" form field
    {::{email::}        - the "E-mail" form field
    {::{message}::}     - the "Message" form field

B<Default> format is shown above and in SYNOPSIS.

GENERATED HTML

Below is the HTML code generated by the plugin. Use CSS to style it.

    # on successful send
    <p class="quicknote_success"><tmpl_var name="success"></p>

    # on error
    <p class="quicknote_error"><tmpl_var name="error"></p>


    # the form itself
    <form class="quicknote" action="" method="POST">
    <div>
        <input type="hidden" name="quicknote_username" value="your full name">
        <input type="hidden" name="page" value="index">
        <ul>
            <li>
                <label for="quicknote_name">Name:</label
                ><input type="text" name="quicknote_name" id="quicknote_name"
                value="">
            </li>
            <li>
                <label for="quicknote_email">E-mail: </label
                ><input type="text" name="quicknote_email" id="quicknote_email"
                value="">
            </li>
            <li>
                <label for="quicknote_message">Message: </label
                ><textarea name="quicknote_message" id="quicknote_message"
                cols="40" rows="10"></textarea>
            </li>
        </ul>
        <input type="submit" id="quicknote_submit" value="Send">
    </div>
    </form>


=head1 App::ZofCMS::Plugin::RandomBashOrgQuote (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::RandomBashOrgQuote>



App::ZofCMS::Plugin::RandomBashOrgQuote - tiny plugin to fetch random quotes from http://bash.org/

SYNOPSIS

Include the plugin

    plugins => [
        qw/RandomBashOrgQuote/
    ],

In HTML::Template file:

    <pre><tmpl_var escape='html' name='plug_random_bash_org_quote'></pre>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to fetch a random
quote from L<http://bash.org/>.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

TO RUN THE PLUGIN

    plugins => [
        qw/RandomBashOrgQuote/
    ],

Unlike many other plugins, this plugin does not have any configuration options and will
run if it's included in the list of plugins to run.

OUTPUT

    <pre><tmpl_var escape='html' name='plug_random_bash_org_quote'></pre>

Plugin will set C<< $t->{t}{plug_random_bash_org_quote} >> to the fetched random quote
or to an error message if an error occured; in case of an error the message will be prefixed
with C<Error:> (in case you wanna mingle with that).


=head1 App::ZofCMS::Plugin::RandomPasswordGenerator (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::RandomPasswordGenerator>



App::ZofCMS::Plugin::RandomPasswordGenerator - easily generate random passwords with an option to use md5_hex from Digest::MD5 on them

SYNOPSIS

    # simple usage example; config values are plugin's defaults

    plugins => [ qw/RandomPasswordGenerator/ ],
    plug_random_password_generator => {
        length   => 8,
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
        cell     => 'd',
        key      => 'random_pass',
        md5_hex  => 0,
        pass_num => 1,
    },

    # generated password is now a string in $t->{d}{random_pass}
    # where $t is ZofCMS Template hashref

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to generate one or several
random passwords and optionally use md5_hex() from L<Digest::MD5> on them.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

Make sure to read C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section at the end of this
document.

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/RandomPasswordGenerator/ ],

Self-explanatory: you need to include the plugin in the list of plugins to run.

C<plug_random_password_generator>

    plug_random_password_generator => {
        length   => 8,
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
        cell     => 'd',
        key      => 'random_pass',
        md5_hex  => 0,
        pass_num => 1,
    },

    plug_random_password_generator => sub {
        my ( $t, $q, $config ) = @_;
        return {
            length   => 8,
            chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
            cell     => 'd',
            key      => 'random_pass',
            md5_hex  => 0,
            pass_num => 1,
        }
    },

B<Mandatory>. The plugin won't run unless C<plug_random_password_generator> first-level key
is present. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_random_password_generator> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run the plugin with all the defaults specify an
empty hashref as a value.
The C<plug_random_password_generator> key can be set in either (or both) Main
Config File and ZofCMS Template;
if set in both, the hashref keys that are set in ZofCMS Template will override the ones that
are set in Main Config File. Possible keys/values of the hashref are as follows:

C<length>

    plug_random_password_generator => {
        length   => 8,
    }

B<Optional>. Takes a positive integer as a value.
Specifies the length - in characters - of password(s) to generate.
B<Defaults to:> C<8>

C<chars>

    plug_random_password_generator => {
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
    }

B<Optional>. Takes an I<arrayref> as a value. Elements of this arrayref must be characters;
these characters specify the set of characters to be used in the generated password.
B<Defaults to:> C<[ 0..9, 'a'..'z', 'A'..'Z' ]>

C<cell>

    plug_random_password_generator => {
        cell     => 'd',
    }

B<Optional>. Takes a string specifying the name of the first-level ZofCMS Template key
into which to create key C<key> (see below) and place the results.
The key must be a hashref (or undef, in which case it will
be autovivified); why? see C<key> argument below.
B<Defaults to:> C<d>

C<key>

    plug_random_password_generator => {
        key      => 'random_pass',
    }

B<Optional>. Takes a string specifying the name of the ZofCMS Template key in hashref
specified be C<cell> (see above) into which to place the results. In other words, if C<cell>
is set to C<d> and C<key> is set to C<random_pass> then generated password(s) will be found
in C<< $t->{d}{random_pass} >> where C<$t> is ZofCMS Template hashref.
B<Defaults to:> C<random_pass>

C<md5_hex>

    plug_random_password_generator => {
        md5_hex  => 0,
    }

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
also generate string that is made from calling C<md5_hex()> from L<Digest::MD5> on the
generated password. See C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section below.
B<Defaults to:> C<0>

C<pass_num>

    plug_random_password_generator => {
        pass_num => 1,
    }

B<Optional>. Takes a positive integer as a value. Specifies the number of passwords to
generate. See C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section below.
B<Defaults to:> C<1>

FORMAT OF VALUES FOR GENERATED PASSWORDS

Examples below assume that C<cell> argument is set to C<d> and C<key> argument is set
to C<random_pass> (those are their defaults). The C<$VAR> is ZofCMS Template hashref, other
keys of this hashref were removed for brevity.

    # all defaults
    $VAR1 = {
        'd' => {
            'random_pass' => 'ETKSeRJS',
    ...

    # md5_hex option is set to a true value, the rest are defaults
    $VAR1 = {
        'd' => {
            'random_pass' => [
                                '3b6SY9LY',                         # generated password
                                '6e28112de1ff183966248d78a4aa1d7b'  # md5_hex() ran on it
                             ]
    ...

    # pass_num is set to 2, the rest are defaults
    $VAR1 = {
        'd' => {
            'random_pass' => [
                                'oqdQmwZ5', # first password
                                'NwzRv6q8'  # second password
                             ],
    ...

    # pass_num is set to 2 and md5_hex is set to a true value
    $VAR1 = {
        'd' => {
            'random_pass' => [
                [
                    '9itPzasC',                             # first password
                    '5f29eb2cf6dbccc048faa9666187ac22'      # md5_hex() ran on it
                ],
                [
                    'ytRRXqtq',                            # second password
                    '81a6a7836e1d08ea2ae1c43c9dbef941'     # md5_hex() ran on it
                ]
            ]
    ...

There are B<four different types> of values (depending on settings) that plugin will generate.
B<In the following text, word "output value" will be used to refer to the value of the key
refered to by> C<key> and C<cell> plugin's arguments; in other words, if C<cell> is
set to C<d> and C<key> is set to C<random_pass> then "output value" will be the value of
C<< $t->{d}{random_pass} >> where C<$t> is ZofCMS Template hashref.

With all the defaults output value will be a single string that is the generated password.

If C<md5_hex> option is set to a true value, instead of that string the plugin will generate
an I<arrayref> first element of which will be the generated password and second element will
be the string generated by running C<md5_hex()> on that password.

If C<pass_num> is set to a number greater than 1 then each generated password will be an
element of an arrayref instead and output value will be an arrayref.

See four examples in the beginning of this section if you are still confused.


=head1 App::ZofCMS::Plugin::RandomPasswordGeneratorPurePerl (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::RandomPasswordGeneratorPurePerl>



App::ZofCMS::Plugin::RandomPasswordGenerator - easily generate random passwords with an option to use md5_hex from Digest::MD5 on them | Pure perl solution

SYNOPSIS

    # simple usage example; config values are plugin's defaults

    plugins => [ qw/RandomPasswordGeneratorPurePerl/ ],
    plug_random_password_generator_pure_perl_pure_perl => {
        length   => 8,
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
        cell     => 'd',
        key      => 'random_pass',
        md5_hex  => 0,
        pass_num => 1,
    },

    # generated password is now a string in $t->{d}{random_pass}
    # where $t is ZofCMS Template hashref

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to generate one or several
random passwords and optionally use md5_hex() from L<Digest::MD5> on them.

B<This plugin is is a drop-in replacement of> L<App::ZofCMS::Plugin::RandomPasswordGenerator>
B<that requires modules that require C compiler> (this module got simpler logic
and does not require anything fancy)

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

Make sure to read C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section at the end of this
document.

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/RandomPasswordGeneratorPurePerl/ ],

Self-explanatory: you need to include the plugin in the list of plugins to run.

C<plug_random_password_generator_pure_perl>

    plug_random_password_generator_pure_perl => {
        length   => 8,
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
        cell     => 'd',
        key      => 'random_pass',
        md5_hex  => 0,
        pass_num => 1,
    },

    plug_random_password_generator_pure_perl => sub {
        my ( $t, $q, $config ) = @_;
        return {
            length   => 8,
        },
    },

B<Mandatory>. The plugin won't run unless C<plug_random_password_generator_pure_perl> first-level key
is present. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_random_password_generator_pure_perl>
as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run the plugin with all the defaults specify an
empty hashref as a value.
The C<plug_random_password_generator_pure_perl> key can be set in either (or both) Main
Config File and ZofCMS Template;
if set in both, the hashref keys that are set in ZofCMS Template will override the ones that
are set in Main Config File. Possible keys/values of the hashref are as follows:

C<length>

    plug_random_password_generator_pure_perl => {
        length   => 8,
    }

B<Optional>. Takes a positive integer as a value.
Specifies the length - in characters - of password(s) to generate.
B<Defaults to:> C<8>

C<chars>

    plug_random_password_generator_pure_perl => {
        chars    => [ 0..9, 'a'..'z', 'A'..'Z' ],
    }

B<Optional>. Takes an I<arrayref> as a value. Elements of this arrayref must be characters;
these characters specify the set of characters to be used in the generated password.
B<Defaults to:> C<[ 0..9, 'a'..'z', 'A'..'Z' ]>

C<cell>

    plug_random_password_generator_pure_perl => {
        cell     => 'd',
    }

B<Optional>. Takes a string specifying the name of the first-level ZofCMS Template key
into which to create key C<key> (see below) and place the results.
The key must be a hashref (or undef, in which case it will
be autovivified); why? see C<key> argument below.
B<Defaults to:> C<d>

C<key>

    plug_random_password_generator_pure_perl => {
        key      => 'random_pass',
    }

B<Optional>. Takes a string specifying the name of the ZofCMS Template key in hashref
specified be C<cell> (see above) into which to place the results. In other words, if C<cell>
is set to C<d> and C<key> is set to C<random_pass> then generated password(s) will be found
in C<< $t->{d}{random_pass} >> where C<$t> is ZofCMS Template hashref.
B<Defaults to:> C<random_pass>

C<md5_hex>

    plug_random_password_generator_pure_perl => {
        md5_hex  => 0,
    }

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
also generate string that is made from calling C<md5_hex()> from L<Digest::MD5> on the
generated password. See C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section below.
B<Defaults to:> C<0>

C<pass_num>

    plug_random_password_generator_pure_perl => {
        pass_num => 1,
    }

B<Optional>. Takes a positive integer as a value. Specifies the number of passwords to
generate. See C<FORMAT OF VALUES FOR GENERATED PASSWORDS> section below.
B<Defaults to:> C<1>

FORMAT OF VALUES FOR GENERATED PASSWORDS

Examples below assume that C<cell> argument is set to C<d> and C<key> argument is set
to C<random_pass> (those are their defaults). The C<$VAR> is ZofCMS Template hashref, other
keys of this hashref were removed for brevity.

    # all defaults
    $VAR1 = {
        'd' => {
            'random_pass' => 'ETKSeRJS',
    ...

    # md5_hex option is set to a true value, the rest are defaults
    $VAR1 = {
        'd' => {
            'random_pass' => [
                                '3b6SY9LY',                         # generated password
                                '6e28112de1ff183966248d78a4aa1d7b'  # md5_hex() ran on it
                             ]
    ...

    # pass_num is set to 2, the rest are defaults
    $VAR1 = {
        'd' => {
            'random_pass' => [
                                'oqdQmwZ5', # first password
                                'NwzRv6q8'  # second password
                             ],
    ...

    # pass_num is set to 2 and md5_hex is set to a true value
    $VAR1 = {
        'd' => {
            'random_pass' => [
                [
                    '9itPzasC',                             # first password
                    '5f29eb2cf6dbccc048faa9666187ac22'      # md5_hex() ran on it
                ],
                [
                    'ytRRXqtq',                            # second password
                    '81a6a7836e1d08ea2ae1c43c9dbef941'     # md5_hex() ran on it
                ]
            ]
    ...

There are B<four different types> of values (depending on settings) that plugin will generate.
B<In the following text, word "output value" will be used to refer to the value of the key
refered to by> C<key> and C<cell> plugin's arguments; in other words, if C<cell> is
set to C<d> and C<key> is set to C<random_pass> then "output value" will be the value of
C<< $t->{d}{random_pass} >> where C<$t> is ZofCMS Template hashref.

With all the defaults output value will be a single string that is the generated password.

If C<md5_hex> option is set to a true value, instead of that string the plugin will generate
an I<arrayref> first element of which will be the generated password and second element will
be the string generated by running C<md5_hex()> on that password.

If C<pass_num> is set to a number greater than 1 then each generated password will be an
element of an arrayref instead and output value will be an arrayref.

See four examples in the beginning of this section if you are still confused.


=head1 App::ZofCMS::Plugin::Search::Indexer (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Search::Indexer>



App::ZofCMS::Plugin::Search::Indexer - plugin that incorporates Search::Indexer module's functionality

SYNOPSIS

    plugins => [ qw/Search::Indexer/ ],
    plug_search_indexer => {
        # most of these values are optional
        dir         => 'index_files',
        cell        => 'd',
        key         => 'search_indexer',
        obj_args    => [],
        exact_match => 0,
        add   => { id1 => 'text to index', },
        remove => [ qw/id1 id2 id3/ ],
        search => 'foo bar baz',
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that incorporates (partial) L<Search::Indexer>
functionality in a form of ZofCMS plugin. In other words, plugin allows one to create a
search index from a bunch of data and later on perform search on that index. See
docs for L<Search::Indexer> for more details.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template> as well as familiar with L<Search::Indexer>, at least lightly.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/Search::Indexer/ ],

You need to add the plugin into the list of plugins to execute.

C<plug_search_indexer>

    plug_search_indexer => {
        # most of these values are optional
        dir         => 'index_files',
        cell        => 'd',
        key         => 'search_indexer',
        obj_args    => [],
        exact_match => 0,
        add   => { id1 => 'text to index', },
        remove => [ qw/id1 id2 id3/ ],
        search => 'foo bar baz',
    },

    plug_search_indexer => sub {
        my ( $t, $q, $conf ) = @_;
        return {
            add   => { id1 => 'text to index', },
        };
    },

B<Mandatory>. The C<plug_search_indexer> first-level key can be specified in either ZofCMS
Template or Main Config File (or both). Its value can be either a subref or a hashref; if the
value is a subref it will be evaluated and it must return a hashref (or undef/empty list). This
hashref will be treated as if you directly assigned it to C<plug_search_indexer> key. The
C<@_> of that subref will contain the following C<$t, $q, $conf> where C<$t> is ZofCMS
Template hashref, C<$q> is a hashref of query parameters and C<$conf> is L<App::ZofCMS::Config>
object. Possible keys/values of C<plug_search_indexer> hashref are as follows:

C<dir>

    dir         => 'index_files',

B<Optional>. Specifies the directory where index files are located. Corresponds to C<dir>
argument of L<Search::Indexer> C<new()> method. B<Defaults to:> C<index_files> (and is relative
to C<index.pl> file).

C<obj_args>

    obj_args    => [],

B<Optional>. Takes an arrayref as a value, this arrayref will be directly dereferenced into
L<Search::Indexer>'s constructor (C<new()> method). The C<writeMode> argument will be set
by the plugin to a true value if C<add> or C<remove> keys (see below) are set. The C<dir>
argument will be derived from plugin's C<dir> key. The arrayref will be dereferenced I<after>
the C<dir> and C<writeMode> arguments, thus you can use C<obj_args> to override them.
See documentation for L<Search::Indexer> for possible values that you can set in
C<obj_args>. B<Defaults to:> C<[]> (empty arrayref).

C<cell>

    cell => 'd',

B<Optional>. Specifies first-level ZofCMS Template key into which to put search results (when
search
is performed). See C<key> argument below. B<Defaults to:> C<d>

C<key>

    key => 'search_indexer',

B<Optional>. Specifies the name of the key inside C<cell> first-level key into which to put search results (when search
is performed). See C<cell> argument below. Basically, if C<cell> is set to C<d> and
C<key> is set to C<search_indexer> then search results will be stored in
C<< $t->{d}{search_indexer} >> where C<$t> is ZofCMS Template hashref. B<Defaults to:>
C<search_indexer>

C<exact_match>

    exact_match => 0,

B<Optional>. Takes either true or false values. Will be given as second parameter to
L<Search::Indexer>'s C<search()> method; thus if it is set to true all the search words without
prefix will have C<+> added to them. B<Defaults to:> C<0>

C<add>

    add   => {
        id1 => 'text to index',
        id2 => 'other text to index',
    },

B<Optional>. When specified, instructs the plugin to add stuff into index. Takes a hashref
as a value where keys are IDs and values are text to index under those IDs.

C<remove>

    remove => [ qw/id1 id2 id3/ ],

    remove => {
        id1     => 'containing text',
        id2     => 'other containing text'
    },

B<Optional>. Takes either a hashref or an arrayref as a value. Elements of the arrayref would
be IDs of records to remove from the index. You'd use the hashref form when C<positions>
argument in C<obj_args> arrayref would be set to a false value (by default it's true); when
that's the case, the keys of hashref would be IDs and values would be corresponding texts.
See C<remove()> method and C<positions> argument to C<new()> method in L<Search::Indexer>

C<search>

    search => 'foo bar baz',

B<Optional>. Takes a string as a value. This string will be given to
L<Search::Indexer>'s C<search()> method as a first argument, i.e. the text for which to search.
The return value will be the same as return value of L<Search::Indexer>'s C<search()> method
and it will be assigned to C<< $t->{ <cell> }{ <key> } >> where C<$t> is ZofCMS Template
hashref and C<< <cell> >> and C<< <key> >> are C<cell> and C<key> plugin's arguments
respectively.

SEE ALSO

L<App::ZofCMS>, L<Search::Indexer>


=head1 App::ZofCMS::Plugin::SendFile (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::SendFile>



App::ZofCMS::Plugin::SendFile - plugin for flexible sending of files as well as files outside of web-accessible directory

SYNOPSIS

In your ZofCMS Template or Main Config File:

    plugins => [ qw/SendFile/ ],

    plug_send_file => [
        '../zcms_site/config.txt',  # filename to send; this one is outside the webdir
        'attachment',               # optional to set content-disposition to attachment
        'text/plain',               # optional to set content-type instead of guessing one
        'LOL.txt',                  # optional to set filename instead of using same as original
    ],

In your HTML::Template template:

    <tmpl_if name='plug_send_file_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_send_file_error'></p>
    </tmpl_if>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means for flexible sending of files
(e.g. sending it as an attachment (for download) or changing the filename), most important
feature of the plugin is that you can use it to send files outside of web-accessible
directory which in conjunction with say L<App::ZofCMS::Plugin::UserLogin> can provide user
account restricted file sending.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins> and notes on exiting

    plugins => [ qw/SendFile/ ],

    plugins => [
        { UserLogin => 200 },
        { SendFile  => 300 },
    ],

We need to include the plugin in the list of plugins to execute; ensure to get the right
priority if you're using other plugins.

B<NOTE:> unless an error occurs, the plugins calls C<exit()> when it's done sending the file,
make sure that all the required plugins had their chance to execute BEFORE this one.

C<plug_send_file>

    plug_send_file => 'foo.txt', # file to send

    plug_send_file => [
        '../zcms_site/config.txt',  # filename to send; this one is outside the webdir
        'attachment',               # optional to set content-disposition to attachment
        'text/plain',               # optional to set content-type instead of guessing one
        'LOL.txt',                  # optional to set filename instead of using same as original
    ],

    plug_send_file => sub {
        my ( $t, $q, $conf ) = @_;
        return 'foo.txt';
    },

B<Mandatory>. Takes either a string, subref or an arrayref as a value, can be specified in
either ZofCMS Template or Main Config File; if set in both, the value in ZofCMS Template is
used.

When set to a subref, the sub will be executed and its return value will be assigned to the key; returning C<undef> will stop the plugin from execution. The C<@_> will contain
(in that order): ZofCMS Template hashref, query parameters hashref, L<App::ZofCMS::Config>
object.

When set to a string it's the same as setting to an arrayref with just one value in it.

Here are how arrayref elements are interpreted:

FIRST ELEMENT

    plug_send_file => [
        '../zcms_site/config.txt',
    ],

B<Mandatory>. Specifies the name of the file to send. The filename is relative to C<index.pl>
and can be outside of webroot. Note that if you're taking this name from the user, it's up
to you to ensure that it's safe.

SECOND ELEMENT

    plug_send_file => [
        '../zcms_site/config.txt',
        'attachment',
    ],

B<Optional>. Specifies C<Content-Disposition> type, which can be C<inline>, C<attachment> or
an extension-token. See RFC 2183 for details.
B<Note:> this parameter only takes the TYPE not the whole header (which isn't supported by
the plugin so you'll have to modify it if you need this). B<Defaults to:> C<inline>, you can
set this to C<undef> to take it's default value.

THIRD ELEMENT

    plug_send_file => [
        '../zcms_site/config.txt',
        undef,
        'text/plain',
    ]

B<Optional>. Specifies the C<Content-Type> to use. When set to C<undef>, the plugin will
try to guess the correct type to use using C<MIME::Types> module.
B<Defauts to:> C<undef>

FOURTH ELEMENT

    plug_send_file => [
        '../zcms_site/config.txt',
        undef,
        undef,
        'LOL.txt',
    ],

B<Optional>. Speficies the filename to use when sending the file. Note that this applies
even when content disposition type is set to C<inline> for when the user would want
to save the file. When set to C<undef>, the plugin will use the same name as the original
file. B<Defaults to:> C<undef>.

HTML::Template VARIABLES - ERROR HANDLING

C<plug_send_file_error>

    <tmpl_if name='plug_send_file_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_send_file_error'></p>
    </tmpl_if>

If the plugin cannot read the file you specified for sending, it will set the
C<plug_send_file_error> key inside C<t> ZofCMS Template special key to the error message (to
the value of C<$!> to be specific) and will stop processing (i.e. won't send any files
or C<exit()>).

"default" Content-Type

If plugin was told to derive the right Content-Type of the file, but it couldn't derive one,
it will use C<application/octet-stream>


=head1 App::ZofCMS::Plugin::Session (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Session>



App::ZofCMS::Plugin::Session - plugin for storing data across requests

SYNOPSIS

    plugins => [
        { Session => 2000 },
        { Sub     => 3000 },
    ],

    plugins2 => [
        qw/Session/,
    ],

    plug_session => {
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test',
        pass    => 'test',
    },

    plug_sub => sub {
        my $t = shift;
        $t->{d}{session}{time} = localtime;
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to store data across HTTP
requests.

B<The docs for this plugin are incomplete>

B<This plugin requires ZofCMS version of at least 0.0211 where multi-level plugin sets are implemented>

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        qw/Session/,
    ],

    plugins2 => [
        qw/Session/,
    ],

B<Important>. This plugin requires to be executed twice. On first execution [currently]
it will load the session data into C<< $t->{d}{session} >> where C<$t> is ZofCMS Template
hashref. On second execution, it will save that data into an SQL table.

C<plug_session>

    plug_session => {
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test',
        pass    => 'test',
        opt     => { RaiseError => 1, AutoCommit => 1 },
        create_table => 1,
    },

B<Mandatory>. The C<plug_session> key takes a hashref as a value. The possible keys/values of that hashref are described below. B<There are quite a few more options to come - see source
code - but those are untested and may be changed, thus use them at your own risk.>

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Specifies the DSN for database, see L<DBI> for more information on what to use
here.

C<user> and C<pass>

        user    => 'test',
        pass    => 'test',

B<Semi-optional>. The C<user> and C<pass> key should contain username and password for
the SQL database that plugin will use. B<Defaults are:> C<user> is C<root> and C<pass> is set
to C<undef>.

C<opt>

    opt => { RaiseError => 1, AutoCommit => 0 },

The C<opt> key takes a hashref of any additional options you want to
pass to C<connect_cached> L<DBI>'s method.

B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 0 }, >>

C<table>

    table   => 'session',

B<Optional>. Takes a string as a value. Specifies the name of the SQL table that plugin
will use to store data. B<Defaults to:> C<session>

C<create_table>

    create_table => 1,

B<Optional>. Takes either true or false values. When set to a true value, the plugin will
automatically create the database table that it nees for operation. B<Defaults to:> C<0>.
Here is the table that it creates (C<$conf{table}> is the C<table> plugin's argument):

    CREATE TABLE `$conf{table}` (
        `id`      TEXT,
        `time`    VARCHAR(10),
        `data`    TEXT
    );

USAGE

Currently just store your data in C<< $t->{d}{session} >>. I suggest you use it as a hashref.

More options to come soon!

MORE INFO

See source code, much of it is understandable (e.g. that session cookies last for 24 hours).
I'll write better documentation once I get more time.


=head1 App::ZofCMS::Plugin::SplitPriceSelect (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::SplitPriceSelect>



App::ZofCMS::Plugin::SplitPriceSelect - plugin for generating a <select> for "price range" out of arbitrary range of prices.

SYNOPSIS

In your Main Config File or ZofCMS Template:

    plugins => [ qw/SplitPriceSelect/ ],

    plug_split_price_select => {
        prices => [ 200, 300, 1000, 4000, 5000 ],
    },

In your L<HTML::Template> file:

    <form...
        <label for="plug_split_price_select">Price range: </label>
        <tmpl_var name='plug_split_price_select'>
    .../form>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that allows you to give several prices and plugin
will create a C<< <select> >> HTML element with its C<< <option> >>s containing I<ranges> of
prices. The idea is that you'd specify how many options you would want to have and plugin will
figure out how to split the prices to generate that many ranges.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/SplitPriceSelect/ ],

You need to add the plugin in the list of plugins to execute.

C<plug_split_price_select>

    plug_split_price_select => {
        prices      => [ qw/foo bar baz/ ],
        t_name      => 'plug_split_price_select',
        options     => 3,
        name        => 'plug_split_price_select',
        id          => 'plug_split_price_select',
        dollar_sign => 1,
    }

    plug_split_price_select => sub {
        my ( $t, $q, $config ) = @_;
        return {
            prices      => [ qw/foo bar baz/ ],
            t_name      => 'plug_split_price_select',
            options     => 3,
            name        => 'plug_split_price_select',
            id          => 'plug_split_price_select',
            dollar_sign => 1,
        };
    }

The C<plug_split_price_select> first-level key takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_split_price_select> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. If a certain key
in that hashref is specified in both, Main Config File and ZofCMS Template, then the
value given in ZofCMS Template will take precedence. Plugin will not run if
C<plug_split_price_select> is not specified (or if C<prices> key's arrayref is empty).
Possible keys/value of C<plug_split_price_select> hashref are as follows:

C<prices>

    prices => [ qw/foo bar baz/ ],

B<Mandatory>. Takes an arrayref as a value, plugin will not run if C<prices> arrayref is
empty or C<prices> is set to C<undef>. The arrayref's elements represent the prices for
which you wish to generate ranges. All elements must be numeric.

C<options>

    options => 3,

B<Optional>. Takes a positive integer as a value. Specifies how many price ranges (i.e.
C<< <option> >>s) you want to have. B<Note:> if there are not enough prices
in the C<prices> argument, expect to have ranges with the same price on both sides; with
evel smaller dataset, expect to have less than C<options> C<< <option> >>s generated.
B<Defaults to:> C<3>

C<t_name>

    t_name => 'plug_split_price_select',

B<Optional>. Plugin will put generated C<< <select> >> into C<{t}> ZofCMS Template special key,
the C<t_name> parameter specifies the name of that key. B<Defaults to:>
C<plug_split_price_select>

C<name>

    name => 'plug_split_price_select',

B<Optional>. Specifies the value of the C<name=""> attribute on the generated C<< <select> >>
element. B<Defaults to:> C<plug_split_price_select>

C<id>

    id => 'plug_split_price_select',

B<Optional>. Specifies the value of the C<id=""> attribute on the generated C<< <select> >>
element. B<Defaults to:> C<plug_split_price_select>

C<dollar_sign>

    dollar_sign => 1,

B<Optional>. Takes either true or false values. When set to a true value, the C<< <option> >>s
will contain a dollar sign in front of prices when displayed in the browser (the
C<value="">s will still B<not> contain the dollar sign, see C<PARSING QUERY> section below).
B<Defaults to:> C<1>

PARSING QUERY

    plug_split_price_select=500-14000

Now, the price ranges are generated and you completed your gorgeous form... how to parse
those ranges is the question. The C<value=""> attribute of each of generated C<< <option> >>
element will contain the starting price in the range followed by a C<-> (dash, rather minus
sign) followed by the ending price in the range. B<Note:> the price on each end of the
range may be the same if there are not enough prices available.
Thus you can do something along the lines of:

    my ( $start_price, $end_price ) = split /-/, $query->{plug_split_price_select};
    my @products_in_which_the_user_is_interested = grep {
        $_->{price} >= $start_price and $_->{price} <= $end_price
    } @all_of_the_products;

GENERATED HTML CODE

This is what the HTML code generated by the plugin looks like (providing all the optional
arguments are left at their default values):

    <select id="plug_split_price_select" name="plug_split_price_select">
        <option value="200-1000">$200 - $1000</option>
        <option value="4000-6000">$4000 - $6000</option>
        <option value="7000-7000">$7000 - $7000</option>
    </select>


=head1 App::ZofCMS::Plugin::StyleSwitcher (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::StyleSwitcher>



App::ZofCMS::Plugin::StyleSwitcher - CSS Style switcher plugin

SYNOPSIS

In your ZofCMS template but most likely in your Main Config File:

    plugins => [ qw/StyleSwitcher/ ],
    plug_style_switcher => {
        dsn                     => "DBI:mysql:database=test;host=localhost",
        user                    => 'test',
        pass                    => 'test',
        opt                     => { RaiseError => 1, AutoCommit => 1 },
        styles => {
            main => 'main.css',
            alt  => [ 'alt.css', '[IE]alt_ie.css' ],
        },
    },

In your L<HTML::Template> template:

    <head>
        <tmpl_var name="style_switcher_style">
    ...

    <body>
        <tmpl_var name="style_switcher_toggle">
    ....

DESCRIPTION

The module provides means to have what is known as "Style Switcher" thingie on your webpages.
In other words, having several CSS stylesheets per website.

The L<http://alistapart.com/stories/alternate/> describes the concept in more detail. It
also provides JavaScript based realization of the idea; this plugin does not rely on
javascript at all.

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [ qw/StyleSwitcher/ ],

You need to include the plugin in the list of plugins to execute.

C<plug_style_switcher>

    plug_style_switcher => {
        dsn                     => "DBI:mysql:database=test;host=localhost",
        user                    => 'test',
        pass                    => 'test',
        opt                     => { RaiseError => 1, AutoCommit => 1 },
        create_table            => 0,
        q_name                  => 'style',
        q_ajax_name             => 'plug_style_switcher_ajax',
        t_prefix                => 'style_switcher_',
        table                   => 'style_switcher',
        max_time                => 2678400, # one month
        default_style           => 'main',
        xhtml                   => 0,
        # styles => {}
        styles => {
            main => 'main.css',
            alt  => [ 'alt.css', '[IE]alt_ie.css' ],
        },
    },

    plug_style_switcher => sub {
        my ( $t, $q, $config ) = @_;
        return {
            dsn                     => "DBI:mysql:database=test;host=localhost",
            user                    => 'test',
            pass                    => 'test',
        }
    },

The plugin reads it's configuration from L<plug_style_switcher> first-level ZofCMS Template
or Main Config file template. Takes a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_style_switcher>
as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. Keys that are set in ZofCMS Template will override same
ones that are set in Main Config file. Considering that you'd want the CSS style settings
to be set on an entire site, it only makes sense to set this plugin up in your Main Config
file.

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>.
The plugin needs access to an SQL database supported by L<DBI> module. The C<dsn> key takes
a scalar as a value that contains the DSN for your database. See L<DBI> for details.

C<user> and C<pass>

    user => 'test',
    pass => 'test',

B<Mandatory>. The C<user> and C<pass> arguments specify the user name (login) and password
for your database.

C<opt>

    opt => { RaiseError => 1, AutoCommit => 1 },

B<Optional>. The C<opt> key takes a hashref as a value. This hashref will be directly
passed as "additional arguments" to L<DBI>'s C<connect_cached()> method. See L<DBI> for
details. B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 }, >>

C<table>

    table => 'style_switcher',

B<Optional>. Specifies the name of the table in which to store the style-user data.
B<Defaults to:> C<style_switcher>

C<create_table>

    create_table => 0,

B<Optional>. Takes either true or false values. B<Defaults to:> C<0> (false). When set to
a true value plugin will automatically create the SQL tables that is needed for the plugin.
Just set it to a true value, load any page that calls the plugin, and remove this setting.
Alternatively you can create the table yourself:
C<< CREATE TABLE style_switcher ( host VARCHAR(200), style TEXT, time VARCHAR(10) ); >>

C<q_name>

    q_name => 'style',

B<Optional>. Takes a string as a value that must contain the name of the query parameter
that will contain the name of the style to "activate". B<Defaults to:> C<style>

C<q_ajax_name>

    q_ajax_name => 'plug_style_switcher_ajax',

B<Optional>. Some of you may want to change styles with JS along with keeping style information
server-side. For this plugin supports the C<q_ajax_name>, it must contain the name of
a query parameter which you'd pass with your Ajax call (sorry to those who really dislike
calling it Ajax). The value of this parameter needs to be a true value. When plugin will see
this query parameter set to a true value, it will set the style (based on the value of
the query parameter referenced by C<q_name> plugin setting; see above) and will simply exit.
B<Defaults to:> C<plug_style_switcher_ajax>

C<t_prefix>

    t_prefix => 'style_switcher_',

B<Optional>. The plugin sets two keys in ZofCMS Template C<{t}> special key. The C<t_prefix>
takes a string as a value; that string will be prefixed to those two keys that are set.
See C<HTML::Template VARIABLES> section below for imformation on those two keys.
B<Defaults to:> C<style_switcher_> (note the underscore (C<_>) at the end).

C<max_time>

    max_time => 2678400, # one month

B<Optional>. Takes a positive integer as a value that indicates how long (in seconds) to
keep the style information for the user. The time is updated every time the user accesses
the plugin. The plugin identifies the "user" by contatenating user's L<User-Agent> HTTP
header and his/her/its host name. Note that old entries are deleted only when someone sets the
style; in other words, if you set C<max_time> to one month and no one ever changes their style
and that user comes back after two month the setting will be preserved.
B<Defaults to:> L<2678400> (one month)

C<default_style>

    default_style => 'main',

B<Optional>. Takes a string as a value that must be one of the keys in C<styles> hashref
(see below). This will be the "default" style. In other words, if the plugin does not
find the particular user in the database it will make the C<default_style> style active.

C<xhtml>

    xhtml => 0,

B<Optional>. Takes either true or false values. When set to a true value will close
C<< <link> >> elements with an extra C</> to keep it XHTML friendly. B<Defaults to>: C<0>

C<styles>

    styles => {
        main => 'main.css',
        alt  => [ 'alt.css', '[IE]alt_ie.css' ],
    },

B<Mandatory>. Takes a hashref as a value. The keys of a that hashref are the names of your
styles. The name of the key is what you'd pass as a value of a query parameter indicated by
plugin's C<q_name> parameter. The value can be either a string or an arrayref. If the value
is a string then it will be converted into an arrayref with just that element in it. Each
element of that arrayref will be converted into a C<< <link> >> element where the C<href="">
attribute will be set to that element of the arrayref. Each element can contain string
C<[IE]> (including the square brackets) as the first four characters, in that case
the C<href=""> will be wrapped in C<< <!--[if IE]> >> conditional comments (if you don't
know what those are, see: L<http://haslayout.net/condcom>).

HTML::Template VARIABLES

Note: examples include the default C<t_prefix> in names of C<< <tmpl_var> >>s.

C<style>


    <tmpl_var name="style_switcher_style">

The C<style> variable will contain appropriate C<< <link> >> elements. You'd want to put
this variable somewhere in HTML C<< <head> >>

C<toggle>

    <tmpl_var name="style_switcher_toggle">

The C<toggle> variable will contain a style toggle link. By clicking this link user can load
the next style (sorted alphabetically by its name). You don't have to use this one and
write your own instead.

SEE ALSO

L<http://alistapart.com/stories/alternate/>


=head1 App::ZofCMS::Plugin::Sub (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::Sub>



App::ZofCMS::Plugin::Sub - plugin to execute a subroutine, i.e. sub with priority setting

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plugins => [ { Sub => 1000 }, ], # set needed priority
    plug_sub => sub {
        my ( $template, $query, $config ) = @_;
        # do stuff
    }

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that allows you to execute a sub... by setting
plugin's priority setting you, effectively, can set the priority of the sub. Not much but I
need this.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ { Sub => 1000 }, ], # set the needed priority here

You obviously need to add the plugin in the list of plugins to exectute. Since the entire
purpose of this plugin is to execute the sub with a certain priority setting, you'd set
the appropriate priority in the plugin list.

C<plug_sub>

    plug_sub => sub {
        my ( $template, $query, $config ) = @_;
    }

Takes a subref as a value.
The plugin will not run unless C<plug_sub> first-level key is present in either Main Config
File or ZofCMS Template file. If the key is specified in both files, the sub set in
ZofCMS Template will take priority. The sub will be executed when plugin is run. The
C<@_> will contain (in that order): ZofCMS Template hashref, query parameters hashref
where keys are parameter names and values are their values, L<App::ZofCMS::Config> object.


=head1 App::ZofCMS::Plugin::Syntax::Highlight::CSS (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Syntax::Highlight::CSS>



App::ZofCMS::Plugin::Syntax::Highlight::CSS - provide syntax highlighted CSS code snippets on your site

SYNOPSIS

In ZofCMS template:

    {
        body        => \'index.tmpl',
        highlight_css => {
            foocss => '* { margin: 0; padding: 0; }',
            bar     => sub { return '* { margin: 0; padding: 0; }' },
            beer    => \ 'filename.of.the.file.with.CSS.in.datastore.dir',
        },
        plugins     => [ qw/Syntax::Highlight::CSS/ ],
    }

In L<HTML::Template> template:

    <tmpl_var name="foocss">
    <tmpl_var name="bar">
    <tmpl_var name="beer">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to include
CSS (Cascading Style Sheets) code snippets with syntax
highlights on your pages.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

USED FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    {
        plugins => [ qw/Syntax::Highlight::CSS/ ],
    }

First and obvious is that you'd want to include the plugin in the list
of C<plugins> to run.

C<highlight_css>

    {
        highlight_css => {
            foocss  => '* { margin: 0; padding: 0; }',
            bar     => sub { return '* { margin: 0; padding: 0; }' },
            beer    => \ 'filename.of.the.file.with.CSS.in.datastore.dir',
        },
    }

The C<highlight_css> is the heart key of the plugin. It takes a hashref
as a value. The keys of this hashref except for two special keys described
below are the name of C<< <tmpl_var name=""> >> tags in your
L<HTML::Template> template into which to stuff the syntax-highlighted
code. The value of those keys can be either a scalar, subref or a scalarref.
They are interpreted by the plugin as follows:

scalar

    highlight_css => {
        foocss => '* { margin: 0; padding: 0; }'
    }

When the value of the key is a scalar it will be interpreted as CSS code
to be highlighted. This will do it for short snippets.

scalarref

    highlight_css => {
        beer    => \ 'filename.of.the.file.with.CSS.in.datastore.dir',
    },

When the value is a scalarref it will be interpreted as the name of
a I<file> in the C<data_store> dir. That file will be read and its contents
will be understood as CSS code to be highlighted. If an error occured
during opening of the file, your C<< <tmpl_var name=""> >> tag allocated
for this entry will be populated with an error message.

subref

    highlight_css => {
        bar     => sub { return '* { margin: 0; padding: 0; }' },
    },

When the value is a subref, it will be executed and its return value will
be taken as CSS code to highlight. The C<@_> of that sub when called
will contain the following: C<< $template, $query, $config >> where
C<$template> is a hashref of your ZofCMS template, C<$query> is a hashref
of the parameter query whether it's a POST or a GET request, and
C<$config> is the L<App::ZofCMS::Config> object.

SPECIAL KEYS IN C<highlight_css>

    highlight_css => {
        nnn => 1,
        pre => 0,
    },

There are two special keys, namely C<nnn> and C<pre>, in
L<highlight_css> hashref. Their values will affect the resulting
highlighted CSS code.

C<nnn>

    highlight_css => {
        nnn => 1,
    }

Instructs the highlighter to activate line numbering.
B<Default value>: C<0> (disabled).

C<pre>

    highlight_css => {
        nnn => 0,
    }

Instructs the highlighter to surround result by <pre>...</pre> tags.
B<Default value>: C<1> (enabled).

C<highlight_css_before>

    {
        highlight_css_before => '<div class="my-highlights">',
    }

Takes a scalar as a value. When specified, every highlighted CSS code
will be prefixed with whatever you specify here.

C<highlight_css_after>

    {
        highlight_after => '</div>',
    }

Takes a scalar as a value. When specified, every highlighted CSS code
will be postfixed with whatever you specify here.

GENERATED CODE

Given C<'* { margin: 0; padding: 0; }'> as input plugin will generate
the following code (line-breaks were edited):

    <pre class="css-code">
        <span class="ch-sel">*</span> {
        <span class="ch-p">margin</span>:
        <span class="ch-v">0</span>;
        <span class="ch-p">padding</span>:
        <span class="ch-v">0</span>; }
    </pre>

Now you'd use CSS to highlight specific parts of CSS syntax.
Here are the classes that you can define in your stylesheet:

=over 6

=item *

C<css-code> - this is actually the class name that will be set on the
C<< <pre>> >> element if you have that option turned on.

=item *

C<ch-sel> - Selectors

=item *

C<ch-com> - Comments

=item *

C<ch-p> - Properties

=item *

C<ch-v> - Values

=item *

C<ch-ps> - Pseudo-selectors and pseudo-elements

=item *

C<ch-at> - At-rules

=item *

C<ch-n> - The line numbers inserted when C<nnn> key is set to a true value

=back


SAMPLE CSS CODE FOR HIGHLIGHTING

    .css-code {
        font-family: 'DejaVu Sans Mono Book', monospace;
        color: #000;
        background: #fff;
    }
        .ch-sel, .ch-p, .ch-v, .ch-ps, .ch-at {
            font-weight: bold;
        }
        .ch-sel { color: #007; } /* Selectors */
        .ch-com {                /* Comments */
            font-style: italic;
            color: #777;
        }
        .ch-p {                  /* Properties */
            font-weight: bold;
            color: #000;
        }
        .ch-v {                  /* Values */
            font-weight: bold;
            color: #880;
        }
        .ch-ps {                /* Pseudo-selectors and Pseudo-elements */
            font-weight: bold;
            color: #11F;
        }
        .ch-at {                /* At-rules */
            font-weight: bold;
            color: #955;
        }
        .ch-n {
            color: #888;
        }

PREREQUISITES

This plugin requires L<Syntax::Highlight::CSS>. You can use
C<zofcms_helper> script to locally place it into ZofCMS "core" directory:

    zofcms_helper --nocore --core your_sites_core --cpan Syntax::Hightlight::CSS


=head1 App::ZofCMS::Plugin::Syntax::Highlight::HTML (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::Syntax::Highlight::HTML>



App::ZofCMS::Plugin::Syntax::Highlight::HTML - provide HTML code snippets on your site

SYNOPSIS

In ZofCMS template:

    {
        body        => \'index.tmpl',
        highlight_html => {
            foohtml => '<div class="bar">beer</div>',
            bar     => sub { return '<div class="bar">beer</div>' },
            beer    => \ 'filename.of.the.file.with.HTML.in.datastore.dir',
        },
        plugins     => [ qw/Syntax::Highlight::HTML/ ],
    }

In L<HTML::Template> template:

    <tmpl_var name="foohtml">
    <tmpl_var name="bar">
    <tmpl_var name="beer">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to include
HTML (HyperText Markup Lanugage) code snippets with syntax
highlights on your pages.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

USED FIRST-LEVEL ZofCMS TEMPLATE KEYS

C<plugins>

    {
        plugins => [ qw/Syntax::Highlight::HTML/ ],
    }

First and obvious is that you'd want to include the plugin in the list
of C<plugins> to run.

C<highlight_html>

    {
        highlight_html => {
            foohtml => '<div class="bar">beer</div>',
            bar     => sub { return '<div class="bar">beer</div>' },
            beer    => \ 'filename.of.the.file.with.HTML.in.datastore.dir',
        },
    }

The C<highlight_html> is the heart key of the plugin. It takes a hashref
as a value. The keys of this hashref except for two special keys described
below are the name of C<< <tmpl_var name=""> >> tags in your
L<HTML::Template> template into which to stuff the syntax-highlighted
code. The value of those keys can be either a scalar, subref or a scalarref.
They are interpreted by the plugin as follows:

scalar

    highlight_html => {
        foohtml => '<div class="bar">beer</div>'
    }

When the value of the key is a scalar it will be interpreted as HTML code
to be highlighted. This will do it for short snippets.

scalarref

    highlight_html => {
        beer    => \ 'filename.of.the.file.with.HTML.in.datastore.dir',
    },

When the value is a scalarref it will be interpreted as the name of
a I<file> in the C<data_store> dir. That file will be read and its contents
will be understood as HTML code to be highlighted. If an error occured
during opening of the file, your C<< <tmpl_var name=""> >> tag allocated
for this entry will be populated with an error message.

subref

    highlight_html => {
        bar     => sub { return '<div class="bar">beer</div>' },
    },

When the value is a subref, it will be executed and its return value will
be taken as HTML code to highlight. The C<@_> of that sub when called
will contain the following: C<< $template, $query, $config >> where
C<$template> is a hashref of your ZofCMS template, C<$query> is a hashref
of the parameter query whether it's a POST or a GET request, and
C<$config> is the L<App::ZofCMS::Config> object.

SPECIAL KEYS IN C<highlight_html>

    highlight_html => {
        nnn => 1,
        pre => 0,
    },

There are two special keys, namely C<nnn> and C<pre>, in
L<highlight_html> hashref. Their values will affect the resulting
highlighted HTML code.

C<nnn>

    highlight_html => {
        nnn => 1,
    }

Instructs the highlighter to activate line numbering.
B<Default value>: C<0> (disabled).

C<pre>

    highlight_html => {
        nnn => 0,
    }

Instructs the highlighter to surround result by <pre>...</pre> tags.
B<Default value>: C<1> (enabled).

C<highlight_before>

    {
        highlight_before => '<div class="highlights">',
    }

Takes a scalar as a value. When specified, every highlighted HTML code
will be prefixed with whatever you specify here.

C<highlight_after>

    {
        highlight_after => '</div>',
    }

Takes a scalar as a value. When specified, every highlighted HTML code
will be postfixed with whatever you specify here.

GENERATED CODE

Given C<< '<foo class="bar">beer</foo>' >> as input plugin will generate
the following code:

    <pre>
        <span class="h-ab">&lt;</span><span class="h-tag">foo</span>
        <span class="h-attr">class</span>=<span class="h-attv">"bar</span>"
        <span class="h-ab">&gt;</span>beer<span class="h-ab">&lt;/</span>
        <span class="h-tag">foo</span><span class="h-ab">&gt;</span>
    </pre>

Now you'd use CSS to highlight specific parts of HTML syntax.
Here are the classes that you can define in your stylesheet (list
shamelessly stolen from L<Syntax::Highlight::HTML> documentation):

=over 4

=item *

C<.h-decl> - for a markup declaration; in a HTML document, the only 
markup declaration is the C<DOCTYPE>, like: 
C<< <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"> >>

=item *

C<.h-pi> - for a process instruction like C<< <?html ...> >>
or C<< <?xml ...?> >>

=item *

C<.h-com> - for a comment, C<< <!-- ... --> >>

=item *

C<.h-ab> - for the characters C<< '<' >> and C<< '>' >> as tag delimiters

=item *

C<.h-tag> - for the tag name of an element

=item *

C<.h-attr> - for the attribute name

=item *

C<.h-attv> - for the attribute value

=item *

C<.h-ent> - for any entities: C<&eacute;> C<&#171;>

=item *

C<.h-lno> - for the line numbers

=back

SAMPLE CSS CODE FOR HIGHLIGHTING

Sebastien Aperghis-Tramoni, the author of L<Syntax::Highlight::HTML>,
was kind enough to provide sample CSS code defining the look of each
element of HTML syntax. It is presented below:

    .h-decl { color: #336699; font-style: italic; }   /* doctype declaration  */
    .h-pi   { color: #336699;                     }   /* process instruction  */
    .h-com  { color: #338833; font-style: italic; }   /* comment              */
    .h-ab   { color: #000000; font-weight: bold;  }   /* angles as tag delim. */
    .h-tag  { color: #993399; font-weight: bold;  }   /* tag name             */
    .h-attr { color: #000000; font-weight: bold;  }   /* attribute name       */
    .h-attv { color: #333399;                     }   /* attribute value      */
    .h-ent  { color: #cc3333;                     }   /* entity               */

    .h-lno  { color: #aaaaaa; background: #f7f7f7;}   /* line numbers         */

PREREQUISITES

Despite the ZofCMS design this module uses L<Syntax::Highlight::HTML>
which in turn uses L<HTML::Parser> which needs a C compiler to install.

This module requires L<Syntax::Highlight::HTML> and L<File::Spec> (the
later is part of the core)


=head1 App::ZofCMS::Plugin::TagCloud (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::TagCloud>



App::ZofCMS::Plugin::TagCloud - generate "tag clouds"

SYNOPSIS

In your ZofCMS template or main config file:

    plug_tag_cloud => {
        unit => 'em',
        tags => [ qw(
                foo /foo 2
                bar /bar 1
                ber /ber 3
            )
        ],
    }

In your L<HTML::Template> template:

    <style type="text/css">
        <tmpl_var name="tag_cloud_css">
    </style>

    <tmpl_var name="tag_cloud">

DESCRIPTION

The module is a plugin for L<App::ZofCMS>; it generates "tag clouds" (bunch of different-sized
links).

This documentation assumes you have read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

ZofCMS TEMPLATE/MAIN CONFIG FILE KEYS

    plug_tag_cloud => {
        id          => 'tag_cloud_container',
        class       => 'tag_cloud_tag',
        unit        => 'em',
        shuffle     => 1,
        uri_prefix  => 'http://site.com/',
        fg          => '#00d',
        bg          => 'transparent',
        fg_hover    => '#66f',
        bg_hover    => 'transparent',
        fg_visited  => '#333',
        bg_visited  => 'transparent',
        tags => [ qw(
                foo /foo 2
                bar /bar 1
                ber /ber 3
            )
        ],
    }

Plugin gets its data through C<plug_tag_cloud> first-level key in either ZofCMS template
or main config file. Specifying this key in ZofCMS template will completely override whatever
you set under that key in main config file.

The key takes a hashref as a value. Possible keys/values of that hashref are as follows:

C<tags>

    tags => [ qw(
            foo /foo 2
            bar /bar 1
            ber /ber 3
        )
    ],

    # or 

    tags => [
        [ qw(foo /foo 2) ],
        [ qw(bar /bar 1) ],
        [ qw(ber /ber 3) ],
    ],

B<Mandatory>.
The C<tags> key takes an arrayref as a value. Elements of that arrayref can be either
either plain strings or arrayrefs. You cannot mix the two. If elements are plain strings
they will be converted internally into the "arrayref form" by grouping by three
(see examples above, they are equivalent).

The elements of the inner arrayrefs are as follows: B<first element> is the text for the
link in the tag cloud. B<Second element> is the URI to which the tag points.
B<Third element> is the "weight" of the tag, the larger the number the larger the tag will be.
The third element actually also serves for the C<font-size> value in the CSS code generated
by the plugin.

C<id>

    id => 'tag_cloud_container',

B<Optional>.
The C<id> key takes a string as a value. This sting will be used for the C<id=""> attribute
of the tag cloud C<< <ul> >> element. B<Defaults to:> C<zofcms_tag_cloud>

C<class>

    class => 'tag_cloud_tag',

B<Optional>.
The C<class> key takes a string as a value. This sting will be used to generate class names
for cloud tags. B<Defaults to:> C<zofcms_tag_cloud>

C<unit>

    unit => 'em',

B<Optional>.
The C<unit> key takes a string as a value. This string must be a valid CSS unit for
C<font-size> property. Whatever you pass in here will be directly used in the generated
CSS code and the number for that unit will be taken from the "weight" of the cloud tag
(see C<tags> key above). B<Defaults to:> C<%>

C<shuffle>

    shuffle => 1,

B<Optional>.
Takes either true or false value. When set to a true value the elements of your tag cloud
will be shuffled each and every time. B<Default to:> C<0>

C<uri_prefix>

    uri_prefix  => 'http://site.com/',

B<Optional>.
The C<uri_prefix> takes a string as a value. This string will be prepended to all of the
URIs to which your tags are pointing. B<Defaults to:> empty string.

C<fg>

    fg => '#00d',

B<Optional>.
Specifies the color to use for foreground on C<< <a href=""> >> elements;
will be directly used for C<color> property in 
generated CSS code. B<Defaults to:> C<#00d>.

C<bg>

    bg => 'transparent',

B<Optional>.
Specifies the color to use for background on C<< <a href=""> >> elements;
will be directly used for C<background> property in
generated CSS code. B<Defaults to:> C<transparent>.

C<fg_hover>

    fg_hover => '#66f',

B<Optional>.
Same as C<fg> except this one is used for C<:hover> pseudo-selector. B<Defaults to:> C<#66f>

C<bg_hover>

    bg_hover => 'transparent',

B<Optional>.
Same as C<bg> except this one is used for C<:hover> pseudo-selector. B<Defaults to:>
C<transparent>

C<fg_visited>

    fg_visited  => '#333',

B<Optional>.
Same as C<fg> except this one is used for C<:visited> pseudo-selector. B<Defaults to:> C<#333>

C<bg_visited>

B<Optional>.
Same as C<bg> except this one is used for C<:visited> pseudo-selector. B<Defaults to:>
C<transparent>

HTML::Template TEMPLATE VARIABLES

The plugin will stuff two keys into C<{t}> special key in your ZofCMS templates. This means
that you can use them in your L<HTML::Template> templates.

C<tag_cloud>

    <tmpl_var name="tag_cloud">

This one will contain the HTML code for your tag cloud.

C<tag_cloud_css>

    <style type="text/css">
        <tmpl_var name="tag_cloud">
    </style>

This one will contain the CSS code for your tag cloud. You obviously don't have to use this
one and instead code your own CSS.

EXAMPLE OF GENERATED HTML CODE

    <ul id="tag_cloud">
        <li class="tag_cloud_tag3"><a href="http://site.com/ber">ber</a></li>
        <li class="tag_cloud_tag2"><a href="http://site.com/foo">foo</a></li>
        <li class="tag_cloud_tag1"><a href="http://site.com/bar">bar</a></li>
    </ul>

EXAMPLE OF GENERATED CSS CODE

    #tag_cloud li {
        display: inline;
    }
        #tag_cloud a {
            color: #f00;
            background: #00f;
        }
        #tag_cloud a:visited {
            color: #000;
            background: transparent;
        }
        #tag_cloud a:hover {
            color: #FFf;
            background: transparent;
        }
        .tag_cloud_tag1 { font-size: 1em; }
        .tag_cloud_tag2 { font-size: 2em; }
        .tag_cloud_tag3 { font-size: 3em; }


=head1 App::ZofCMS::Plugin::Tagged (version 0.0252)

NAME


Link: L<App::ZofCMS::Plugin::Tagged>



App::ZofCMS::Plugin::Tagged - ZofCMS plugin to fill templates with data from query, template variables and configuration using <TAGS>

SYNOPSIS

Your ZofCMS template:

    {
        cookie_foo  => '<TAG:TNo cookies:{d}{cookies}{foo}>',
        query_foo   => '[<TAG:Q:{foo}>]',
        set_cookies => [ ['foo', 'bar' ]],
        plugins     => [ { Cookies => 10 }, { Tagged => 20 } ],
        conf => {
            base => 'test.tmpl',
        },
    }

In your 'test.tmpl' base L<HTML::Template> template:

    Cookie 'foo' is set to: <tmpl_var name="cookie_foo"><br>
    Query 'foo' is set to: <tmpl_var name="query_foo">

In ZofCMS template the Cookies plugin is set to run before Tagged plugin,
thus on first page access cookies will not be set, and we will access
the page without setting the 'foo' query parameter. What do we see:

    Cookie 'foo' is set to: No cookies
    Query 'foo' is set to: []

No, if we run the page the second time it (now cookies are set with
L<App::ZofCMS::Plugin::Cookies> plugin) will look like this:

    Cookie 'foo' is set to: bar
    Query 'foo' is set to: []

If we pass query parameter 'foo' to the page, setting it to 'beer'
our page will look like this:

    Cookie 'foo' is set to: bar
    Query 'foo' is set to: [beer]

That's the power of Tagged plugin... now I'll explain what those weird
looking tags mean.

DESCRIPTION

The module provides means to the user to use special "tags" in B<scalar>
values inside ZofCMS template. This provides the ability to display
data generated by templates (i.e. stored in C<{d}> first level key), access
query or configuration hashref. Possibilities are endless.

B<This documentation assumes you have read documentation for>
L<App::ZofCMS> B<including> L<App::ZofCMS::Config> B<and>
L<App::ZofCMS::Template>

STARTING WITH THE PRIORITY

First of all, when using App::ZofCMS::Plugin::Tagged with other plugins
make sure to set the correct priority. In our example above, we used
L<App::ZofCMS::Plugin::Cookies> which reads currently set cookies into
C<{d}> special key in ZofCMS template. That's why we set priority of C<10>
to Cookies plugin and priority of C<20> to Tagged plugin - to insure
Tagged runs after C<{d}{cookies}> have been filled in.

B<Note:> currently there is no support to run Tagged plugin twice,
I'm not sure that will ever be needed, but if you do come across such
situation, you can easily cheat. Just copy Tagged.pm in your
C<$core/App/ZofCMS/Plugin/Tagged.pm> to Tagged2.pm (and ajust the name
accordingly in the C<package> line inside the file). Now you have two
Tagged plugins, and you can do stuff like
C<< plugins => [ {Tagged => 10}, { SomePlugin => 20 }, { Tagged2 => 30 } ] >>

THE TAG

    foo => '<TAG:Q:{foo}>',
    bar => 'beeer <TAG:Qdefault:{bar}>  baz',
    baz => 'foo <TAG:T:{d}{baz}[1]{beer}[2]> bar',
    nop => "<TAG:NOOP><TAG:T:I'm NOT a tag!!!>",
    random => '<TAG::RAND I 100>',

B<NOTE: everything in the tag is CASE-SENSITIVE>

First of all, the tag starts with C<< '<TAG:' >> and ends with with a
closing angle bracket (C<< '>' >>). The first character that follows
C<< '<TAG:' >> is a I<cell>. It can be either C<'Q>', C<'T'> or C<'C'>,
which
stand for B<Q>uery, B<T>emplate and B<C>onfiguration file. Each of those
three cells is a hashref: a hashref of query parameters, your ZofCMS
template hashref and your main configuration file hashref.

What follows the cell letter until the colon (C<':'>) is the I<default
value>, it will be used if whatever your tag references is undefined. Of
course, you don't have to define the default value; if you don't - the
tag value will be an empty string (not undef). B<Note:> currently you
can't use the actual colon (C<':'>) in your default variable. Currently
it will stay that way, but there are plans to add custom delimiters in the
future.

After the colon (C<':'>) which signifies the end of the I<cell> and possible
I<default value> follows a sequence which would access the value which
you are after. This sequence is exactly how you would write it in perl.
Let's look at some examples. First, let's define C<$template>, C<$query>
and C<$config> variables as C<T>, C<Q> and C<C> "cells", these variables
hold respective hashrefs (same as "cells"):

    <TAG:Q:{foo}>              same as   $query->{foo}
    <TAG:T:{d}{foo}>           same as   $template->{d}{foo}
    <TAG:C:{ fo o }{ b a r }>  same as   $config->{"fo o"}{"b a r"}
    <TAG:Qnone:{foo}>          same as   $query->{foo} // 'none'
    <TAG:Txxx:{t}{bar}>        same as   $template->{t}{bar} // 'xxx'

    # arrayrefs are supported as well
    
    <TAG:T:{d}{foo}[0]>        same as   $template->{d}{foo}[0]
    <TAG>C:{plugins}[1]>       same as   $config->{plugins}[1]

THE RAND TAG

    rand1 => '<TAG:RAND>',
    rand2 => '<TAG:RAND 100>',
    rand3 => '<TAG:RAND I 200>',
    rand4 => '<TAG:RAND100>',
    rand5 => '<TAG:RANDI100>',

The I<RAND tag> will be replaced by a pseudo-random number (obtained from
perl's rand() function). In it's plainest form, C<< <TAG:RAND> >>, it
will be replaced by exactly what comes out from C<rand()>, in other
words, same as calling C<rand(1)>. If a letter C<'I'> follows word
C<'RAND'> in the tag, then C<int()> will be called on the result of
C<rand()>. When a number follows word C<RAND>, that number will be used
in the call to C<rand()>. In other words, tag C<< <TAG:RAND 100> >>
will be replaced by a number which is obtained by the call to
C<rand(100)>. Note: the number must be B<after> the letter C<'I'> if you
are using it. You can have spaces between the letter C<'I'> or the number
and the word C<RAND>. In other words, these tags are equal:
C<< <TAG:RANDI100> >> and C<< <TAG:RAND I 100> >>.

THE NOOP TAG

    nop => "<TAG:NOOP><TAG:T:I'm NOT a tag!!!>",

The I<NOOP tag> (read B<no> B<op>eration) is a special tag which tells
Tagged plugin to stop processing this string as soon as it sees this tag.
Tagged will remove the noop tag from the string. The above example would
end up looking as C<< nop => "<TAG:T:I'm NOT a tag!!!>", >>

B<Note:> any tags I<before> the noop tag B<WILL> be parsed.

OPTIONS

    {
        tagged_options => { no_parse => 1 },
    }

Behaviour options can be set for App::ZofCMS::Plugin::Tagged via
C<tagged_options> first level ZofCMS template key. This key takes a
hashref as a value. The only currently supported key in that hashref
is C<no_parse> which can be either a true or a false value. If it's set
to a true value, Tagged will not parse this template.

NOTE ON DEPLOYMENT

This plugin requires L<Data::Transformer> module which is not in Perl's
core. If your webserver does not allow instalation of modules from CPAN,
run the helper script to copy this module into your $core_dir/CPAN/
directory

    zofcms_helper --nocore --core your_sites_core --cpan Data::Transformer

CAVEATS

If your tag references some element of ZofCMS template which itself contains
a tag the behaviour is undefined.

SEE ALSO

L<App::ZofCMS>, L<App::ZofCMS::Config>, L<App::ZofCMS::Template>


=head1 App::ZofCMS::Plugin::TOC (version 0.0103)

NAME


Link: L<App::ZofCMS::Plugin::TOC>



App::ZofCMS::Plugin::TOC - Table of Contents building plugin for ZofCMS

SYNOPSIS

In your ZofCMS template, or in your main config file (under
C<template_defaults> or C<dir_defaults>):

    page_toc    => [
        qw/
            #overview
            #beginning
            #something_else
            #conclusion
        /,
    ],
    plugins     => [ qw/TOC/ ],

    # OR

    page_toc    => [
        [ qw/#overview Overview class_overview/ ],
        [ qw/#beginning Beginning/ ],
        qw/
            #something_else
            #conclusion
        /,
    ],
    plugins     => [ qw/TOC/ ],

In your L<HTML::Template> template:

    <tmpl_var name="page_toc">

DESCRIPTION

This plugin provides means to generate "table of contents" lists. For
example, the second example in the SYNOPSYS would replace
C<< <tmpl_var name="page_toc"> >> with this:

    <ul class="page_toc">
        <li class="class_overview"><a href="#overview">Overview</a></li>
        <li><a href="#beginning">Beginning</a></li>
        <li><a href="#something_else">Something Else</a></li>
        <li><a href="#conclusion">Conclusion</a></li>
    </ul>

HOW TO USE

Aside from sticking C<TOC> in your arrayref of plugins in your
ZofCMS template (C<< plugins => [ qw/TOC/ ] >>) and placing
C<< <tmpl_var name="page_toc"> >> in your L<HTML::Template> template
you also need to create
a C<page_toc> first level key in ZofCMS template. That key's value is an
arrayref each element of which can be either an arrayref or a scalar.
B<If the element is a scalar it is the same as it being an arrayref with one
element>. The element which is an arrayref can contain either one, two or
three elements itself. Which represent the following:

arrayref which contains only one element

    page_toc => [
        '#foo',
        '#bar-baz',
    ],

    # OR
    
    page_toc => [
        [ '#foo' ],
        [ '#bar-baz' ],
    ],

The first (and only) element will be used in C<href=""> attribute
of the generated link. The text of the link will be determined
automatically, in particular the C<'#'> will be removed, first letter
will be capitalized and any dashes C<'-'> or underscores C<'_'> will
be replaced by a space with the letter following them capitalized. The
example above will place the following code in
C<< <tmpl_var name="page_toc"> >>:

    <ul class="page_toc">
        <li><a href="#foo">Foo</a></li>
        <li><a href="#bar-baz">Bar Baz</a></li>
    </ul>

arrayref which contains two elements

    page_toc => [
        [ '#foo', 'Foos Lots of Foos!' ],
        [ '#bar-baz', 'Bar-baz' ],
    ],

The first element will be used in C<href=""> attribute
of the generated link. The second element will be used as text for the
link. The example above will generate the following code:

    <ul class="page_toc">
        <li><a href="#foo">Foos Lots of Foos!</a></li>
        <li><a href="#bar-baz">Bar-baz</a></li>
    </ul>

arrayref which contains three elements

    page_toc => [
        [ '#foo', 'Foos Lots of Foos!', 'foos' ],
        [ '#bar-baz', 'Bar-baz', 'bars' ],
    ],

The first element will be used in C<href=""> attribute
of the generated link. The second element will be used as text for the
link. The third elemenet will be used to create a C<class=""> attribute
on the C<< <li> >> element for the corresponding entry.
The example above will generate the following code:

    <ul class="page_toc">
        <li class="foos"><a href="#foo">Foos Lots of Foos!</a></li>
        <li class="bars"><a href="#bar-baz">Bar-baz</a></li>
    </ul>

Note: the class of the C<< <ul> >> element is always C<page_toc>


=head1 App::ZofCMS::Plugin::UserLogin (version 0.0212)

NAME


Link: L<App::ZofCMS::Plugin::UserLogin>



App::ZofCMS::Plugin::UserLogin - restrict access to pages based on user accounts

SYNOPSIS

In $your_database_of_choice that is supported by L<DBI> create a table.
You can have extra columns in it, but the first five must be named as appears
below. C<login_time> is the return of Perl's C<time()>. Password will be
C<md5_hex()>ed (with L<Digest::MD5>,
C<session_id> is C<rand() . rand() . rand()> and role depends
on what you set the roles to be:

    create TABLE users (
        login TEXT,
        password VARCHAR(32),
        login_time VARCHAR(10),
        session_id VARCHAR(55),
        role VARCHAR(20)
    );

Main config file:

    template_defaults => {
        plugins => [ { UserLogin => 10000 } ],
    },
    plug_login => {
        dsn                     => "DBI:mysql:database=test;host=localhost",
        user                    => 'test', # user,
        pass                    => 'test', # pass
        opt                     => { RaiseError => 1, AutoCommit => 0 },
        table                   => 'users',
        login_page              => '/login',
        redirect_on_restricted  => '/login',
        redirect_on_login       => '/',
        redirect_on_logout      => '/',
        not_restricted          => [ qw(/ /index) ],
        restricted              => [ qr/^/ ],
        smart_deny              => 'login_redirect_page',
        preserve_login          => 'my_site_login',
        login_button => '<input type="submit"
            class="input_submit" value="Login">',
        logout_button => '<input type="submit"
            class="input_submit" value="Logout">',
    },

In L<HTML::Template> template for C<'/login'> page:

    <tmpl_var name="plug_login_form">
    <tmpl_var name="plug_login_logout">


DESCRIPTION

The module is a plugin for L<App::ZofCMS>; it provides functionality to
restrict access to some pages based on user accounts (which support "roles")

Plugin uses HTTP cookies to set user sessions.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

NOTE ON LOGINS

Plugin makes the logins B<lowercased> when doing its processing; thus C<FooBar> login
is the same as C<foobar>.

NOTE ON REDIRECTS

There are quite a few options that redirect the user upon a certain event.
The C<exit()> will be called upon a redirect so keep that
in mind when setting plugin's priority setting.

DATABASE

Plugin needs access to the database that is supported by L<DBI> module.
You'll need to create a table the format of which is described in the
first paragraph of L<SYNOPSYS> section above. B<Note>: plugin does not
support I<creation> of user accounts. That was left for other plugins
(e.g. L<App::ZofCMS::Plugin::FormToDatabase>)
considering that you are flexible in what the entry for each user in the
database can contain.

ROLES

The "role" of a user can be used to limit access only to certain users.
In the database the user can have several roles which are to be separated
by commas (C<,>). For example:

    foo,bar,baz

The user with that role is member of role "foo", "bar" and "baz".

TEMPLATE/CONFIG FILE SETTINGS

    plug_login => {
        dsn                     => "DBI:mysql:database=test;host=localhost",
        user                    => 'test',
        pass                    => 'test',
        opt                     => { RaiseError => 1, AutoCommit => 0 },
        table                   => 'users',
        user_ref    => sub {
            my ( $user_ref, $template ) = @_;
            $template->{d}{plug_login_user} = $user_ref;
        },
        login_page              => '/login',
        redirect_on_restricted  => '/login',
        redirect_on_login       => '/',
        redirect_on_logout      => '/',
        not_restricted          => [ qw(/ /index) ],
        restricted              => [ qr/^/ ],
        smart_deny              => 'login_redirect_page',
        preserve_login          => 'my_site_login',
        login_button => '<input type="submit"
            class="input_submit" value="Login">',
        logout_button => '<input type="submit"
            class="input_submit" value="Logout">',
    },

These settings can be set via C<plug_login> first-level key in ZofCMS
template, but you probably would want to set all this in main config file via
C<plug_login> first-level key.

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. The C<dsn> key will be passed to L<DBI>'s C<connect_cached()>
method, see documentation for L<DBI> and C<DBD::your_database> for the
correct syntax of this one. The example above uses MySQL database called
C<test> which is location on C<localhost>

C<user>

    user => 'test',

B<Mandatory>. Specifies the user name (login) for the database. This can
be an empty string if, for example, you are connecting using SQLite driver.

C<pass>

    pass => 'test',

B<Mandatory>. Same as C<user> except specifies the password for the database.

C<table>

    table => 'users',

B<Optional>. Specifies which table in the database stores user accounts.
For format of this table see L<SYNOPSYS> section. B<Defaults to:> C<users>

C<opt>

    opt => { RaiseError => 1, AutoCommit => 0 },

B<Optional>. Will be passed directly to C<DBI>'s C<connect_cached()> method
as "options". B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 0 } >>

C<user_ref>

    user_ref => sub {
        my ( $user_ref, $template ) = @_;
        $template->{d}{plug_login_user} = $user_ref;
    },

B<Optional>. Takes a subref as an argument. When specified the subref will be called and
its C<@_> will contain the following: C<$user_ref>, C<$template_ref>, C<$query_ref>,
C<$config_obj>, where C<$user_ref> will be either C<undef> (e.g. when user is not logged on)
or will contain an arrayref with user data pulled from the SQL table, i.e. an arrayref
with all the columns in a table that correspond to the currently logged in user.
The C<$template_ref> is
the reference to your ZofCMS template, C<$query_ref> is the reference to a query hashref as
is returned from L<CGI>'s C<Vars()> call. Finally, C<$config_obj> is the L<App::ZofCMS::Config>
object. Basically you'd use C<user_ref> to stick user's data into your ZofCMS template for
later processing, e.g. displaying parts of it or making it accessible to other plugins.
B<Defaults to:> (will stick user data into C<{d}{plug_login_user}> in ZofCMS template)

    user_ref    => sub {
        my ( $user_ref, $template ) = @_;
        $template->{d}{plug_login_user} = $user_ref;
    },

C<login_page>

    login_page => '/login',

    login_page => qr|^/log(?:in)?|i;

B<Optional>. Specifies what page is a page with a login form. The check will
be done against a "page" that is constructed by C<$query{dir} . $query{page}>
(the C<dir> and C<page> are discussed in ZofCMS's core documentation).
The value for the C<login_page> key can be either a string or a regex.
B<Note:> the access is B<NOT> restricted to pages matching C<login_page>.
B<Defaults to:> C</login>

C<redirect_on_restricted>

    redirect_on_restricted => '/uri',

B<Optional>. Specifies the URI to which to redirect if access to the page
is denied, e.g. if user does not have an appropriate role or is not logged
in. B<Defaults to:> C</>

C<redirect_on_login>

    redirect_on_login  => '/uri',

B<Optional>. Specifies the URI to which to redirect after user successfully
logged in. B<By default> is not specified.

C<smart_deny>

    smart_deny => 'login_redirect_page',

B<Optional>. Takes a scalar as a value that represents a query parameter
name into which to store the URI of the page that not-logged-in  user
attempted to access. This option works only when C<redirect_on_login> is
specified. When specified, plugin enables the magic to "remember" the page
that a not-logged-in user tried to access, and once the user enters correct
login credentials, he is redirected to said page automatically; thereby
making the login process transparent. B<By default> is not specified.

C<preserve_login>

    preserve_login => 'my_site_login',

B<Optional>. Takes a scalar that represents the name of a cookie
as a value. When specified, the plugin will automatically
(via the cookie, name of which you specify here) remember, and fill
out, the username from last successfull login. This option only works
when C<no_cookies> is set to a false value (that's the default).
B<By default> is not specified

C<login_button>

    login_button => '<input type="submit"
            class="input_submit" value="Login">',

B<Optional>. Takes HTML code for the login button, though, feel free to
use it as an insertion point for any extra code you might want in your
login form. B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Login"> >>

C<logout_button>

    logout_button => '<input type="submit"
        class="input_submit" value="Logout">'

B<Optional>. Takes HTML code for the logout button, though, feel free to
use it as an insertion point for any extra code you might want in your
logout form. B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Logout"> >>

C<redirect_on_logout>

    redirect_on_logout => '/uri',

B<Optional>. Specifies the URI to which to redirect the user after he or
she logged out.

C<restricted>

    restricted => [
        qw(/foo /bar /baz),
        qr|^/foo/|i,
        { page => '/admin', role => 'admin' },
        { page => qr|^/customers/|, role => 'customer' },
    ],

B<Optional> but doesn't make sense to not specify this one.
B<By default> is not specified. Takes an arrayref
as a value. Elements of this arrayref can be as follows:

a string

    restricted => [ qw(/foo /bar) ],

Elements that are plain strings represent direct pages ( page is made out of
$query{dir} . $query{page} ). The example above will restrict access
only to pages C<http://foo.com/index.pl?page=foo> and
C<http://foo.com/index.pl?page=bar> for users that are not logged in.

a regex

    restricted => [ qr|^/foo/| ],

Elements that are regexes (C<qr//>) will be matched against the page. If
the page matches the given regex access will be restricted to any user
who is not logged in.

a hashref

    restricted => [
        { page => '/secret', role => \1 },
        { page => '/admin', role => 'customer' },
        { page => '/admin', role => 'not_customer' },
        { page => qr|^/customers/|, role => 'not_customer' },
    ],

Using hashrefs you can set specific roles that are restricted from a given
page. The hashref must contain two keys: the C<page> key and C<role> key.
The value of the C<page> key can be either a string or a regex which will
be matched against the current page the same way as described above. The
C<role> key must contain a role of users that B<are restricted> from
accessing the page specified by C<page> key or a scalarref
(meaning "any role"). B<Note> you can specify only
B<one> role per hashref. If you want to have several roles you need to
specify several hashrefs or use C<not_restricted> option described below.

In the example above only logged in users who are B<NOT> members of role
C<customer> or C<not_customer> can access C</admin> page and
only logged in users who are B<NOT> members of role C<not_customer>
can access pages that begin with C</customers/>. The page C</secret> is
restricted for B<everyone> (see note on scalarref below).

B<IMPORTANT NOTE:> the restrictions will be checked until the first one
matching the page criteria found. Therefore, make sure to place
the most restrictive restrictions first. In other words:

    restricted => [
        qr/^/,
        { page => '/foo', role => \1 },
    ],

Will B<NOT> block logged in users from page C</foo> because C<qr/^/> matches
first. Proper way to write this restriction would be:

    restricted => [
        { page => '/foo', role => \1 },
        qr/^/,
    ],

B<Note:> the role can also be a I<scalarref>; if it is, it means "any role".
In other words:

    restricted => [ qr/^/ ],

Means "all the pages are restricted for users who are not logged in". While:

    restricted => [ { page => qr/^/, role \1 } ],

Means that "all pages are restricted for everyone" (in this case you'd use
C<not_restricted> option described below to ease the restrictions).


C<not_restricted>

    not_restricted => [
        qw(/foo /bar /baz),
        qr|^/foo/|i,
        { page => '/garbage', role => \1 },
        { page => '/admin', role => 'admin' },
        { page => qr|^/customers/|, role => 'customer' },
    ],

B<Optional>. The value is the exact same format as for C<restricted> option
described above. B<By default> is not specified.
The purpose of C<not_restricted> is the reverse of
C<restricted> option. Note that pages that match anything in
C<not_restricted> option will not be checked against C<restricted>. In other
words you can construct rules such as this:

    restricted => [
        qr/^/,
        { page => qr|^/admin|, role => \1 },
    ],
    not_restricted => [
        qw(/ /index),
        { page => qr|^/admin|, role => 'admin' },
    ],

The example above will restrict access to every page on the site that is
not C</> or C</index> to any user who is not logged in. In addition, pages
that begin with C</admin> will be accessible only to users who are members
of role C<admin>.

C<limited_time>

    limited_time => 600,

B<Optional>. Takes integer values greater than 0. Specifies the amount
of seconds after which user's session expires. In other words, if you
set C<limited_time> to 600 and user went to the crapper for 10 minutes, then
came back, he's session would expire and he would have to log in again.
B<By default> not specified and sessions expire when the cookies do so
(which is "by the end of browser's session", let me know if you wish to
control that).

C<no_cookies>

    no_cookies => 1,

B<Optional>. When set to a false value plugin will set two cookies:
C<md5_hex()>ed user login and session ID. When set to a true value plugin
will not set any cookies and instead will put session ID into
C<plug_login_session_id> key under ZofCMS template's C<{t}> special key.
B<By default> is not specified (false).

HTML::Template TEMPLATE

There are two (or three, depending if you set C<no_cookies> to a true value)
keys created in ZofCMS template C<{t}> special key, thus are available in
your L<HTML::Template> templates:

C<plug_login_form>

    <tmpl_var name="plug_login_form">

The C<plug_login_form> key will contain the HTML code for the "login form".
You'd use C<< <tmpl_var name="plug_login_form"> >> on your "login page".
Note that login errors, i.e. "wrong login or password" will be automagically
display inside that form in a C<< <p class="error"> >>.

C<plug_login_logout>

    <tmpl_var name="plug_login_logout">

This one is again an HTML form except for the "logout" button. Drop it
anywhere you want.

C<plug_login_user>

    <tmpl_if name="plug_login_user">
        Logged in as <tmpl_var name="plug_login_user">.
    </tmpl_if>

The C<plug_login_user> will contain the login name of the currently logged in
user.

C<plug_login_session_id>

If you set C<no_cookies> argument to a true value, this key will contain
session ID.

GENERATED HTML CODE

Below are the snippets of HTML code generated by the plugin; here for the
reference when styling your login/logout forms.

login form

    <form action="" method="POST" id="zofcms_plugin_login">
    <div>
        <input type="hidden" name="page" value="/login">
        <input type="hidden" name="zofcms_plugin_login" value="login_user">
        <ul>
            <li>
                <label for="zofcms_plugin_login_login">Login: </label
                ><input type="text" name="login" id="zofcms_plugin_login_login">
            </li>
            <li>
                <label for="zofcms_plugin_login_pass">Password: </label
                ><input type="password" name="pass" id="zofcms_plugin_login_pass">
            </li>
        </ul>
        <input type="submit" value="Login">
    </div>
    </form>

login form with a login error

    <form action="" method="POST" id="zofcms_plugin_login">
    <div><p class="error">Invalid login or password</p>
        <input type="hidden" name="page" value="/login">
        <input type="hidden" name="zofcms_plugin_login" value="login_user">
        <ul>
            <li>
                <label for="zofcms_plugin_login_login">Login: </label
                ><input type="text" class="input_text" name="login" id="zofcms_plugin_login_login">
            </li>
            <li>
                <label for="zofcms_plugin_login_pass">Password: </label
                ><input type="password" class="input_password" name="pass" id="zofcms_plugin_login_pass">
            </li>
        </ul>
        <input type="submit" class="input_submit" value="Login">
    </div>
    </form>

logout form

    <form action="" method="POST" id="zofcms_plugin_login_logout">
    <div>
        <input type="hidden" name="page" value="/login">
        <input type="hidden" name="zofcms_plugin_login" value="logout_user">
        <input type="submit" class="input_submit" value="Logout">
    </div>
    </form>


=head1 App::ZofCMS::Plugin::UserLogin::ChangePassword (version 0.0110)

NAME


Link: L<App::ZofCMS::Plugin::UserLogin::ChangePassword>



App::ZofCMS::Plugin::UserLogin::ChangePassword - UserLogin plugin suppliment for changing user passwords

SYNOPSIS

In your Main Config File or ZofCMS Template:

    plugins => [
        { UserLogin                   => 200  },
        { 'UserLogin::ChangePassword' => 1000 },
    ],

    plug_user_login_change_password => {
        dsn     => "DBI:mysql:database=hl;host=localhost",
        login   => 'test',
        pass    => 'test',
    },

    # UserLogin plugin's configuration skipped for brevity

In your HTML::Template template:

    <tmpl_var name='change_pass_form'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to display and process the
"change password" form. This plugin was designed with an assumption that you are using
L<App::ZofCMS::Plugin::UserLogin>, but that's not a requirement.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        { 'UserLogin::ChangePassword' => 2000 },
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute. By default
this plugin is configured to interface with L<App::ZofCMS::UserLogin> plugin, thus you'd
include UserLogin plugin with lower priority sequence to execute earlier.

C<plug_user_login_change_password>

    plug_user_login_change_password => {
        dsn     => "DBI:mysql:database=test;host=localhost",
        user    => 'test',
        pass    => 'test',
        opt     => { RaiseError => 1, AutoCommit => 1 },
        table   => 'users',
        login   => sub { $_[0]{d}{user}{login} },
        key     => 'change_pass_form',
        min     => 4,
        submit_button => q|<input type="submit" class="input_submit"|
            . q| name="plug_user_login_change_password_submit"|
            . q| value="Change password">|,
    },

    # or set arguments via a subref
    plug_user_login_change_password => sub {
        my ( $t, $q, $config ) = @_;
        return {
            dsn => "DBI:mysql:database=test;host=localhost",
        },
    },

B<Mandatory>. Takes either a hashref or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_user_login_change_password> as if it was already
there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object. To run with all the defaults (which won't be the case for
nearly everything but testing environment) set to empty hashref.
Possible keys/values for the hashref are as follows:

C<dsn>

    plug_user_login_change_password => sub {
        dsn => "DBI:mysql:database=test;host=localhost",
    },

B<Optional>. Specifies L<DBI>'s "dsn" (driver, database and host) for the plugin to use.
See L<App::ZofCMS::UserLogin> for more details; this one needs to point to the
same database that UserLogin plugin uses so the right password could be changed.
B<Defaults to:> C<DBI:mysql:database=test;host=localhost>  (as I've said, useful only for
testing enviroment)

C<user>

    plug_user_login_change_password => sub {
        user    => 'test',
    },

B<Optional>. Specifies the username for database access. B<Defaults to:> C<test>

C<pass>

    plug_user_login_change_password => sub {
        pass    => 'test',
    },

B<Optional>. Specifies the password for database access. B<Defaults to:> C<test>

C<opt>

    plug_user_login_change_password => sub {
        opt => { RaiseError => 1, AutoCommit => 1 },
    },

B<Optional>. Specifies additional L<DBI> options. See L<App::ZofCMS::Plugin::UserLogin>'s
C<opt> argument for more details. B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 } >>

C<table>

    plug_user_login_change_password => sub {
        table   => 'users',
    },

B<Optional>. Specifies the SQL table used in L<App::ZofCMS::Plugin::UserLogin>. Actually,
you do not have to use UserLogin plugin, but the passwords must be stored in a column
named C<password>. B<Defaults to:> C<users>

C<login>

    plug_user_login_change_password => sub {
        login   => 'admin',
    },

    plug_user_login_change_password => sub {
        login   => sub { $_[0]{d}{user}{login} },
    },

B<Optional>. Specifies the login of the user whose password to chagne.
Takes either a string or a subref as a value. If subref is specified, its
return value will be assigned to C<login> as if it was already there.
The C<@_> of the subref will contain (in that order): ZofCMS Template hashref, query
parameters hashref and L<App::ZofCMS::Config> object.
B<Defaults to:> C<sub { $_[0]{d}{user}{login} }> (my common way of storing C<$user_ref> from
UserLogin plugin)

C<key>

    plug_user_login_change_password => sub {
        key     => 'change_pass_form',
    },

B<Optional>. Specifies the name of the key inside C<{t}> special key into which
the plugin will put the password change form (see PLUGIN'S HTML AND OUTPUT section for
details).
B<Defaults to:> C<change_pass_form>

C<min>

    plug_user_login_change_password => sub {
        min     => 4,
    },

B<Optional>. Takes a positive intereger or zero as a value. Specifies
the minimum C<length()> of the new password. B<Defaults to:> C<4>

C<submit_button>

    plug_user_login_change_password => sub {
        submit_button => q|<input type="submit" class="input_submit"|
            . q| name="plug_user_login_change_password_submit"|
            . q| value="Change password">|,
    },

B<Optional>. Takes a string of HTML code as a value. Specifies the
code for the submit button of the form; feel free to add any extra
code you might require as well. B<Defaults to:>
C<< <input type="submit" class="input_submit"  name="plug_user_login_change_password_submit" value="Change password"> >>

PLUGIN'S HTML AND OUTPUT

The plugin uses key in C<{t}> special key that is specified via C<key> plugin's configuration
argument (defaults to C<change_pass_form>). That key will contain either the HTML
form for password changing or the message that password was successfully changed.

If an error occured (such as mismatching passwords), plugin will set 
C<< $t->{t}{plug_user_login_change_password_error} >> to a true value (where C<$t> is
ZofCMS Template hashref). If password was successfully changed, plugin will set
C<< $t->{t}{plug_user_login_change_password_ok} >> to a true value (where C<$t> is
ZofCMS Template hashref). You do not have to use these, as they are set only if you have
a large page and want to hide/show different bits depending on what is going on.

Below is the HTML::Template template that plugin uses for the form as well as successfully
password changes. It is shown here for you to know how to style your password changing
form/success message properly:

    <tmpl_if name='change_ok'>
        <p id="plug_user_login_change_password_ok" class="success-message">Your password has been successfully changed</p>
    <tmpl_else>
        <form action="" method="POST" id="plug_user_login_change_password_form">
        <div>
            <tmpl_if name='error'>
                <p class="error"><tmpl_var escape='html' name='error'></p>
            </tmpl_if>
            <input type="hidden" name="page" value="<tmpl_var escape='html' name='page'>">
            <input type="hidden" name="dir" value="<tmpl_var escape='html' name='dir'>">
            <ul>
                <li>
                    <label for="plug_user_login_change_password_pass">Current password: </label
                    ><input type="password" class="input_password" name="plug_user_login_change_password_pass" id="plug_user_login_change_password_pass">
                </li>
                <li>
                    <label for="plug_user_login_change_password_newpass">New password: </label
                    ><input type="password" class="input_password" name="plug_user_login_change_password_newpass" id="plug_user_login_change_password_newpass">
                </li>
                <li>
                    <label for="plug_user_login_change_password_repass">Retype new password: </label
                    ><input type="password" class="input_password" name="plug_user_login_change_password_repass" id="plug_user_login_change_password_repass">
                </li>
            </ul>
            <input type="submit" class="input_submit" name="plug_user_login_change_password_submit" value="Change password">
        </div>
        </form>
    </tmpl_if>

SEE ALSO

L<DBI>, L<App::ZofCMS::Plugin::UserLogin>


=head1 App::ZofCMS::Plugin::UserLogin::ForgotPassword (version 0.0112)

NAME


Link: L<App::ZofCMS::Plugin::UserLogin::ForgotPassword>



App::ZofCMS::Plugin::UserLogin::ForgotPassword - addon plugin that adds functionality to let users reset passwords

SYNOPSIS

In your L<HTML::Template> template:

    <tmpl_var name='plug_forgot_password'>

In your Main Config File or ZofCMS Template:

    plugins => [ qw/UserLogin::ForgotPassword/ ],

    plug_user_login_forgot_password => {
        # mandatory
        dsn                  => "DBI:mysql:database=test;host=localhost",

        # everything below is optional...
        # ...arguments' default values are shown
        user                 => '',
        pass                 => undef,
        opt                  => { RaiseError => 1, AutoCommit => 1 },
        users_table          => 'users',
        code_table           => 'users_forgot_password',
        q_code               => 'pulfp_code',
        max_abuse            => '5:10:60', # 5 min. intervals, max 10 attempts per 60 min.
        min_pass             => 6,
        code_expiry          => 24*60*60, # 1 day
        code_length          => 6,
        subject              => 'Password Reset',
        email_link           => undef, # this will be guessed
        from                 => undef,
        email_template       => undef, # use plugin's default template
        create_table         => undef,
        login_page           => '/',
        mime_lite_params     => undef,
        email                => undef, # use `email` column in users table
        button_send_link => q|<input type="submit" class="input_submit"|
            . q| value="Send password">|,
        button_change_pass => q|<input type="submit" class="input_submit"|
            . q| value="Change password">|,
        use_stage_indicators => 1,
        no_run               => undef,
    },

DESCRIPTION

The module is a plugin for L<App::ZofCMS> that adds functionality to
L<App::ZofCMS::Plugin::UserLogin> plugin; that being the "forgot password?"
operations. Namely, this involves showing the user the form to ask for
their login, emailing the user special link which to follow (this is to
establish ligitimate reset) and, finally, to provide a form where a user
can enter their new password (and of course, the plugin will update
the password in the C<users> table). Wow, a mouthful of functionality! :)

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>. Whilst not necessary,
being familiar with L<App::ZofCMS::Plugin::UserLogin> might be helpful.

GENERAL OUTLINE OF THE WAY PLUGIN WORKS

Here's the big picture of what the plugin does: user visits a page, plugin
shows the HTML form that asks the user to enter their login in order to
request password reset.

Once the user does that, the plugin checks that the provided login indeed
exists, checks that there's no abuse going on (flooding with reset
requests), generates a special "code" that, as part of a full
link-to-follow, is sent to the user inviting them to click it to proceed
with the reset.

Once the user clicks the link in their email (and thus ends up back on your
site), the plugin will invite them to enter (and reenter to confirm)
their new password. Once the plugin ensures the password looks good,
it will update user's password in the database.

All this can be enabled on your site with a few keystroke, thanks to this
plugin :)

FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

C<plugins>

    plugins => [
        { 'UserLogin::ForgotPassword' => 2000 },
    ],

B<Mandatory>. You need to include the plugin in the list of plugins
to execute.

C<plug_user_login_forgot_password>

    plug_user_login_forgot_password => {
        # mandatory
        dsn                  => "DBI:mysql:database=test;host=localhost",

        # everything below is optional...
        # ...arguments' default values are shown
        user                 => '',
        pass                 => undef,
        opt                  => { RaiseError => 1, AutoCommit => 1 },
        users_table          => 'users',
        code_table           => 'users_forgot_password',
        q_code               => 'pulfp_code',
        max_abuse            => '5:10:60', # 5 min. intervals, max 10 attempts per 60 min.
        min_pass             => 6,
        code_expiry          => 24*60*60, # 1 day
        code_length          => 6,
        subject              => 'Password Reset',
        email_link           => undef, # this will be guessed
        from                 => undef,
        email_template       => undef, # use plugin's default template
        create_table         => undef,
        login_page           => '/',
        mime_lite_params     => undef,
        email                => undef, # use `email` column in users table
        button_send_link => q|<input type="submit" class="input_submit"|
            . q| value="Send password">|,
        button_change_pass => q|<input type="submit" class="input_submit"|
            . q| value="Change password">|,
        use_stage_indicators => 1,
        no_run               => undef,
    },

    # or
    plug_user_login_forgot_password => sub {
        my ( $t, $q, $config ) = @_;
        ...
        return $hashref_to_assign_to_plug_user_login_forgot_password_key;
    },

B<Mandatory>. Takes either a hashref or a subref as a value.
If subref is specified, its return value will be assigned to
C<plug_user_login_forgot_password> key as if it was already there.
If sub returns an C<undef>, then plugin will stop further processing.
The C<@_> of the subref will contain C<$t>, C<$q>, and C<$config>
(in that order), where C<$t> is ZofCMS Tempalate hashref,
C<$q> is query parameters hashref, and C<$config> is the
L<App::ZofCMS::Config> object. The hashref has a whole ton of possible
keys/values that control plugin's behavior; luckily, virtually all of them
are optional with sensible defaults. Possible keys/values for the hashref
are as follows:

C<dsn>

    plug_user_login_forgot_password => {
        dsn => "DBI:mysql:database=test;host=localhost",
    ...

B<Mandatory>. The C<dsn> key will be passed to L<DBI>'s
C<connect_cached()> method, see documentation for L<DBI> and
C<DBD::your_database> for the correct syntax for this one.
The example above uses MySQL database called C<test> which is
located on C<localhost>.
B<Defaults to:> C<"DBI:mysql:database=test;host=localhost">, which is
rather useless, so make sure to set your own :)

C<user>

    plug_user_login_forgot_password => {
        user => '',
    ...

B<Optional>. Specifies the user name (login) for the database. This can be 
an empty string if, for example, you are connecting using SQLite 
driver. B<Defaults to:> C<''> (empty string)

C<pass>

    plug_user_login_forgot_password => {
        pass => undef,
    ...

B<Optional>. Same as C<user> except specifies the password for the
database. B<Defaults to:> C<undef> (no password)

C<opt>

    plug_user_login_forgot_password => {
        opt => { RaiseError => 1, AutoCommit => 1 },
    ...

B<Optional>. Will be passed directly to L<DBI>'s C<connect_cached()> method
as "options". B<Defaults to:> C<< { RaiseError => 1, AutoCommit => 1 } >>

C<users_table>

    plug_user_login_forgot_password => {
        users_table => 'users',
    ...

B<Optional>. Specifies the name of the SQL table that you're using
for storing I<user records>. This would be the
L<App::ZofCMS::Plugin::UserLogin>'s C<table> argument. If you're not
using that plugin, your users table should have logins stored in
C<login> column, passwords in C<password> columns. If you're B<not
planning to specify> the C<email> argument (see below), your users
table need to have email addresses specified in the C<email> table column;
these will be the email addresses to which the reset links will be emailed.
B<Defaults to:> C<users>

C<code_table>

    plug_user_login_forgot_password => {
        code_table => 'users_forgot_password',
    ...

    CREATE TABLE `users_forgot_password` (
        `login` TEXT,
        `time`  VARCHAR(10),
        `code`  TEXT
    );'

B<Optional>. Specifies the name of SQL table into which to store
reset codes. This table will be used when user submits password reset
request, and the added entry will be deleted when user successfully enters
new password. Above SQL code shows the needed structure of the table,
but see C<create_table> argument (below) for more on this.
B<Defaults to:> C<users_forgot_password>

C<create_table>

    plug_user_login_forgot_password => {
        create_table => undef,
    ...

B<Optional>. Takes true or false values. When set to a true value,
the plugin will automatically create the needed table where to store
reset codes (see C<code_table> above). Note: if the table already exists, 
plugin will crap out with an error - that's the intended behaviour, simply 
set C<create_table> back to false value. B<Defaults to:> C<undef>

C<q_code>

    plug_user_login_forgot_password => {
        q_code => 'pulfp_code',
    ...

B<Optional>. Takes a scalar as a value that indicates the name of
the query parameter that will be used by the plugin to reteive the
"special" code. Plugin uses several query parameter names during its
operation, but the code is sent via email and is directly visible to
the user; the idea is that that might give you enough reason to wish
control the name of that parameter. B<Defaults to:> C<pulfp_code>

C<max_abuse>

    plug_user_login_forgot_password => {
        max_abuse => '5:10:60', # 5 min. intervals, max 10 attempts per 60 min.
    ...

    plug_user_login_forgot_password => {
        max_abuse => undef, # turn off abuse control
    ...

B<Optional>. B<Defaults to:> C<5:10:60> (5 minute intervals, maximum 10
attempts per 60 minutes). Takes either C<undef> or specially formatted
"time code". This argument is responsible for abuse control (yey); abuse
being the case when an idiot enters some user's login in the reset form and
then hits browser's REFRESH a billion times, flooding said user. The values
for this argument are:

C<undef>

    plug_user_login_forgot_password => {
        max_abuse => undef, # turn off abuse control
    ...

If set to C<undef>, abuse control will be disabled.

first time code number

    plug_user_login_forgot_password => {
        max_abuse => '5:10:60',
    ...

Unless set to C<undef>, the argument's value must be three numbers
separated by colons. The first number indicates, in minutes, the interval
of time that must pass after a password reset request until another request
can be sent I<using the same login> (there's no per-IP protection, or
anything like that). B<Default first number is> C<5>.

second time code number

The second number indicates the maximum number of reset attempts
(again, per-login) that can be done in C<third number> interval of time.
For example, if the second number is 10 and third is 60, a user can request
password reset 10 times in 60 minutes and no more.
B<Default second number> is C<10>.

third time code number

The third number indicates, in minutes, the time interval used by the
second number. B<Default third number is> C<60>.

C<min_pass>

    plug_user_login_forgot_password => {
        min_pass => 6,
    ...

B<Optional>. Takes a positive integer as a value. Specifies the minimum
length (number of characters) for the new password the user provides.
B<Defaults to:> C<6>

C<code_expiry>

    plug_user_login_forgot_password => {
        code_expiry => 24*60*60, # 1 day
    ...

B<Optional>. Takes, in seconds, the time after which to deem the 
reset code (request) as expired. In other words, if the user requests 
password reset, then ignores his email for C<code_expiry> seconds, 
then the link in his email will no longer work, and he would have to 
request the reset all over again. B<Defaults to:> C<86400> (24 hours)

C<code_length>

    plug_user_login_forgot_password => {
        code_length => 6,
    ...

B<Optional>. Specifies the length of the randomly generated code that
is used to identify legitimate user. Since this code is sent to the
user via email, and is directly visible, specifying the code to be 
of too much length will look rather ugly. On the other hand, too short 
of a code can be easily guessed by a vandal.
B<Defaults to:> C<6>

C<subject>

    plug_user_login_forgot_password => {
        subject => 'Password Reset',
    ...

B<Optional>. Takes a string as a value, this will be used as the subject
line of the email sent to the user (the one containing the link to click).
B<Defaults to:> C<Password Reset>

C<from>

    plug_user_login_forgot_password => {
        from => undef,
    ...

    plug_user_login_forgot_password => {
        from => 'Zoffix Znet <zoffix@cpan.org>',
    ...

B<Optional>. Takes a scalar as a value that specifies the C<From> field for
your email. If not specified, the plugin will simply not set the C<From>
argument in L<MIME::Lite>'s C<new()> method (which is what this plugin uses
under the hood). See L<MIME::Lite>'s docs for more description.
B<Defaults to:> C<undef> (not specified)

C<email_link>

    plug_user_login_forgot_password => {
        email_link => undef, # guess the right page
    ...

    # note how the URI ends with the "invitation" to append the reset
    # ... code right to the end
    plug_user_login_forgot_password => {
        email_link => 'http://foobar.com/your_page?foo=bar&pulfp_code=',
    ...

B<Optional>. Takes either C<undef> or a string containing a link
as a value. Specifies the link to the page with this plugin enabled, this
link will be emailed to the user so that they could proceed to
enter their new password. When set to C<undef>, the plugin guesses the
current page (using C<%ENV>) and that's what it will use for the link.
If you specify the string, make sure to end it with C<pulfp_code=> (note
the equals sign at the end), where C<pulfp_code> is the value you have set
for C<q_code> argument. B<Defaults to:> C<undef> (makes the plugin guess
the right link)

C<email_template>

    plug_user_login_forgot_password => {
        email_template => undef, # use plugin's default template
    ...

    plug_user_login_forgot_password => {
        email_template => \'templates/file.tmpl', # read template from file
    ...

    plug_user_login_forgot_password => {
        email_template => '<p>Blah blah blah...', # use this string as template
    ...

B<Optional>. Takes a scalar, a scalar ref, or C<undef> as a value.
Specifies L<HTML::Template> template to use when generating the email
with the reset link. When set to C<undef>, plugin will use its default
template (see OUTPUT section below). If you're using your own template,
the C<link> template variable will contain the link the user needs to follow
(i.e., use C<< <tmpl_var escape='html' name='link'> >>).
B<Defaults to:> C<undef> (plugin's default, see OUTPUT section below)

C<login_page>

    plug_user_login_forgot_password => {
        login_page => '/',
    ...

    plug_user_login_forgot_password => {
        login_page => '/my-login-page',
    ...

    plug_user_login_forgot_password => {
        login_page => 'http://lolwut.com/your-login-page',
    ...

B<Optional>. As a value, takes either C<undef> or a URI. Once the user is 
through will all the stuff plugin wants them to do, the plugin will tell 
them that the password has been changed, and that they can no go ahead
and "log in". If C<login_page> is specified, the "log in" text will be
a link pointing to whatever you set in C<login_page>; otherwise, the
"log in" text will be just plain text. B<Defaults to:> C</> (i.e. web root)

C<mime_lite_params>

    plug_user_login_forgot_password => {
        mime_lite_params => undef,
    ...

    plug_user_login_forgot_password => {
        mime_lite_params => [
            'smtp',
            'meowmail',
            Auth   => [ 'FOO/bar', 'p4ss' ],
        ],
    ...

B<Optional>. Takes an arrayref or C<undef> as a value.
If specified, the arrayref will be directly dereferenced into
C<< MIME::Lite->send() >>. Here you can set any special send arguments you
need; see L<MIME::Lite> docs for more info. B<Note:> if the plugin refuses
to send email, it could well be that you need to set some 
C<mime_lite_params>; on my box, without anything set, the plugin behaves
as if everything went through fine, but no email arrives.
B<Defaults to:> C<undef>

C<email>

    plug_user_login_forgot_password => {
        email => undef,
    ...

    plug_user_login_forgot_password => {
        email => 'foo@bar.com,meow.cans@catfood.com',
    ...

B<Optional>. Takes either C<undef> or email address(es) as a value.
This argument tells the plugin where to send the email containing password
reset link. If set to C<undef>, plugin will look into C<users_table> (see 
above) and will assume that email address is associated with the user's
account and is stored in the C<email> column of the C<users_table> table.
If you don't want that, set the email address directly here. Note: if you
want to have multiple email addresses, simply separate them with commas.
B<Defaults to:> C<undef> (take emails from C<users_table> table)

C<button_send_link>

    plug_user_login_forgot_password => {
        button_send_link => q|<input type="submit" class="input_submit"|
            . q| value="Send password">|,
    ...

B<Optional>. Takes HTML code as a value. This code represents the
submit button in the first form (the one that asks the user to enter
their login). This, for example, allows you to use image buttons instead
of regular ones. Also, feel free to use this as the insertion point
for any extra HTML form you need in this form. B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Send password"> >>

C<button_change_pass>

    plug_user_login_forgot_password => {
        button_change_pass => q|<input type="submit" class="input_submit"|
            . q| value="Change password">|,
    ...

B<Optional>. Takes HTML code as a value. This code represents the
submit button in the second form (the one that asks the user to enter
and reconfirm their new password). This, for example, allows you to use
image buttons instead of regular ones. Also, feel free to use this as the
insertion point for any extra HTML form you need in this form.
B<Defaults to:>
C<< <input type="submit" class="input_submit" value="Change password"> >>

C<no_run>

    plug_user_login_forgot_password => {
        no_run => undef,
    ...

    plug_user_login_forgot_password => {
        no_run => 1,
    ...

B<Optional>. Takes either true or false values as a value. This
argument is a simple control switch that you can use to tell the plugin
not to execute. If set to a true value, plugin will not run.
B<Defaults to:> C<undef> (for obvious reasons :))

C<use_stage_indicators>

    plug_user_login_forgot_password => {
        use_stage_indicators => 1,
    ...

B<Optional>. Takes either true or false values as a value. When set
to a true value, plugin will set "stage indicators" (see namesake section 
below for details); otherwise, it won't set anything. B<Defaults to:> C<1>

STAGE INDICATORS & PLUGIN'S OUTPUT VARIABLE

All of plugin's output is spit out into a single variable in your
L<HTML::Template> template:

    <tmpl_var name='plug_forgot_password'>

This raises the question of controlling the bells and whistles on your
page with regard to what stage the plugin is undergoing
(i.e. is it displaying that form that asks for a login or the one that
is asking the user for a new password?). This is where I<stage indicators>
come into play.

Providing C<use_stage_indicators> argument (see above) is set to a true
value, the plugin will set the key with the name of
appropriate stage indicator to a true value. That key resides in the
C<{t}> ZofCMS Template special key, so that you could use it in your
L<HTML::Template> templates. Possible stage indicators as well as
explanations of when they are set are as follows:

C<plug_forgot_password_stage_initial>

    <tmpl_if name='plug_forgot_password_stage_initial'>
        Forgot your pass, huh?
    </tmpl_if>

This indicator shows that the plugin is in its initial stage; i.e. the
form asking the user to enter their login is shown.

C<plug_forgot_password_stage_ask_error_login>

    <tmpl_if name='plug_forgot_password_stage_ask_error_login'>
        Yeah, that ain't gonna work if you don't tell me your login...
    </tmpl_if>

This indicator will be active if the user submits the form that is
asking for his login, but does not specify his login.

C<plug_forgot_password_stage_ask_error_no_user>

    <tmpl_if name='plug_forgot_password_stage_ask_error_no_user'>
        Are you sure you got the right address, bro?
    </tmpl_if>

This indicator shows that the plugin did not find user's login in the
C<users_table> table.

C<plug_forgot_password_stage_ask_error_abuse>

    <tmpl_if name='plug_forgot_password_stage_ask_error_abuse'>
        Give it a rest, idiot!
    </tmpl_if>

This indicator shows that the plugin detected abuse (see C<max_abuse>
plugin's argument for details).

C<plug_forgot_password_stage_emailed>

    <tmpl_if name='plug_forgot_password_stage_emailed'>
        Sent ya an email, dude!
    </tmpl_if>

This indicator turns on when the plugin successfully sent the user
an email containing reset pass link.

C<plug_forgot_password_stage_code_invalid>

    <tmpl_if name='plug_forgot_password_stage_code_invalid'>
        Your reset code has expired, buddy. Hurry up, next time!
    </tmpl_if>

This indicator is active when the plugin can't find the code the user
is giving it. Under natural circumstances, this will only occur when
the code has expired.

C<plug_forgot_password_stage_change_pass_ask>

    <tmpl_if name='plug_forgot_password_stage_change_pass_ask'>
        What's the new pass you want, buddy?
    </tmpl_if>

This indicator turns on when the form asking the user for the new password
is active.

C<plug_forgot_password_stage_code_bad_pass_length>

    <tmpl_if name='plug_forgot_password_stage_code_bad_pass_length'>
        That pass's too short, dude.
    </tmpl_if>

This indicator signals that the user attempted to use too short of a new
password (the length is controlled with the C<min_pass> plugin's argument).

C<plug_forgot_password_stage_code_bad_pass_copy>

    <tmpl_if name='plug_forgot_password_stage_code_bad_pass_copy'>
        It's really hard to type the same thing twice, ain't it?
    </tmpl_if>

This indicator turns on if the user did not retype the new password
correctly.

C<plug_forgot_password_stage_change_pass_done>

    <tmpl_if name='plug_forgot_password_stage_change_pass_done'>
        Well, looks like you're all done with reseting your pass and what not.
    </tmpl_if>

This indicator shows that the final stage of plugin's run has been reached;
i.e. the user has successfully reset the password and can go on with
their other business.

OUTPUT

The plugin generates a whole bunch of various output; what's below should
cover all the bases:

Default Email Template

    <h2>Password Reset</h2>
    
    <p>Hello. Someone (possibly you) requested a password reset. If that
    was you, please follow this link to complete the action:
    <a href="<tmpl_var escape='html' name='link'>"><tmpl_var escape='html'
    name='link'></a></p>
    
    <p>If you did not request anything, simply ignore this email.</p>

You can change this using C<email_template> argument. When using your
own, use C<< <tmpl_var escape='html' name='link'> >> to insert the
link the user needs to follow.

"Ask Login" Form Template

    <form action="" method="POST" id="plug_forgot_password_form">
    <div>
        <p>Please enter your login into the form below and an email with
            further instructions will be sent to you.</p>
    
        <input type="hidden" name="page" value="<tmpl_var escape='html'
            name='page'>">
        <input type="hidden" name="pulfp_ask_link" value="1">
        <tmpl_if name='error'>
            <p class="error"><tmpl_var escape='html' name='error'></p>
        </tmpl_if>
    
        <label for="pulfp_login">Your login: </label
        ><input type="text"
            class="input_text"
            name="pulfp_login"
            id="pulfp_login">
    
        <input type="submit"
            class="input_submit"
            value="Send password">
    </div>
    </form>

This is the form that asks the user for their login in order to reset
the password. Submit button is plugin's default code, you can control
it with the C<button_send_link> plugin's argument.

"New Password" Form Template

    <form action="" method="POST" id="plug_forgot_password_new_pass_form">
    <div>
        <p>Please enter your new password.</p>
    
        <input type="hidden" name="page" value="<tmpl_var escape='html'
            name='page'>">
        <input type="hidden" name="<tmpl_var escape='html'
            name='code_name'>"
            value="<tmpl_var escape='html' name='code_value'>">
        <input type="hidden" name="pulfp_has_change_pass" value="1">
        <tmpl_if name='error'>
            <p class="error"><tmpl_var escape='html' name='error'></p>
        </tmpl_if>
    
        <ul>
            <li>
                <label for="pulfp_pass">New password: </label
                ><input type="password"
                    class="input_password"
                    name="pulfp_pass"
                    id="pulfp_pass">
            </li>
            <li>
                <label for="pulfp_repass">Retype new password: </label
                ><input type="password"
                    class="input_password"
                    name="pulfp_repass"
                    id="pulfp_repass">
            </li>
        </ul>
    
        <input type="submit"
            class="input_submit"
            value="Change password">
    </div>
    </form>

This is the template for the form that asks the user for their new
password, as well as the retype of it for confirmation purposes. The code
for the submit button is what the plugin uses by default
(see C<button_change_pass> plugin's argument).

"Email Sent" Message

    <p class="reset_link_send_success">Please check your email
        for further instructions on how to reset your password.</p>

This message is shown when the user enters correct login and the
plugin successfully sents the user their reset link email.

"Expired Reset Code" Message

    <p class="reset_code_expired">Your reset code has expired. Please try
        resetting your password again.</p>

This will be shown if the user follows a reset link that contains
invalid (expired) reset code.

"Changes Successfull" Message

    <p class="reset_pass_success">Your password has been successfully
        changed. You can now use it to <a href="/">log in</a>.</p>

This will be shown when the plugin has done its business and the password
has been reset. Note that the "log in" text will only be a link if
C<login_page> plugin's argument is set; otherwise it will be plain text.

REQUIRED MODUILES

The plugin requires the following modules/versions for healthy operation:

    App::ZofCMS::Plugin::Base  => 0.0105
    DBI                        => 1.607
    Digest::MD5                => 2.36_01
    HTML::Template             => 2.9
    MIME::Lite                 => 3.027


=head1 App::ZofCMS::Plugin::ValidationLinks (version 0.0101)

NAME


Link: L<App::ZofCMS::Plugin::ValidationLinks>



App::ZofCMS::Plugin::ValidationLinks - plugin for people with bad memory to include Valid HTML/Valid CSS links pointing to validators

SYNOPSIS

In your Main Config File or ZofCMS Template file:

    plugins => [ qw/ValidationLinks/ ]

In your L<HTML::Template> template:

    <tmpl_var name="val_link_html">
    <tmpl_var name="val_link_css">

Produced HTML code:

    <a href="http://validator.w3.org/check?uri=referer" title="Validate HTML code on this page">Valid HTML 4.01 Strict</a>
    <a href="http://jigsaw.w3.org/css-validator/check/referer" title="Validate CSS code on this page">Valid CSS</a>

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It's pretty useless unless you are like me: have
a really bad memory on URIs and sick and tired of looking up all those links. The links are
L<http://validator.w3.org/check?uri=referer> for (X)HTML and
L<http://jigsaw.w3.org/css-validator/check/referer> for CSS.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plug_val_links>

    plug_val_links => {
        html_text   => 'Valid HTML 4.01 Strict',
        css_text    => 'Valid CSS',
        xhtml       => 0,
    },

B<Optional>. The plugin takes its configuration via a hashref assigned to a
C<plug_val_links> first-level key in either Main Config File or ZofCMS Template. As opposed
to many other plugins, this plugin will still execute even if the C<plug_val_links> key
is not present; as long as you include the plugin in the list of plugins to execute.
Possible keys/values of C<plug_val_links> hashref are as follows:

C<html_text>

    plug_val_links => {
        html_text   => 'Valid HTML 4.01 Strict',
    }

B<Optional>. Specifies the text for the "validate (X)HTML" link. B<Defaults to:>
C<Valid HTML 4.01 Strict>

C<css_text>

    plug_val_links => {
        css_text    => 'Valid CSS',
    },

B<Optional>. Specifies the text for the "validate CSS" link. B<Defaults to:> C<Valid CSS>

C<xhtml>

    plug_val_links => {
        xhtml       => 0,
    },

B<Optional>. Pretty much the only purpose of this argument is for the C<title="">
attribute of the "validate (X)HTML" link. Takes either true or false values.
When set to a true value the link will have
C<title="Validate XHTML code on this page">, when set to a false value
the link will have C<title="Validate HTML code on this page">. B<Defaults to:> C<0> (false)

HTML::Template VARIABLES

    <tmpl_var name="val_link_html">
    <tmpl_var name="val_link_css">

The plugin will set two keys in C<{t}> special keys, thus you'll have two
L<HTML::Template> variables to use:

C<val_link_html>

    <tmpl_var name="val_link_html">

Will contain the link to HTML validator to validate the current page.

C<val_link_css>

    <tmpl_var name="val_link_css">

Will contain the link to CSS validator to validate the current page.

NOTES ON TESTING

The W3C validator cannot validate pages that are not publicly accessible, i.e. (possibly) your
development server; thus clicking the links from your local version of site will make
the validator error out.


=head1 App::ZofCMS::Plugin::YouTube (version 0.0104)

NAME


Link: L<App::ZofCMS::Plugin::YouTube>



App::ZofCMS::Plugin::YouTube - CRUD-type plugin to manage YouTube videos

SYNOPSIS

In your Main Config File or ZofCMS Template template:

    plugins => [ qw/YouTube/, ],

    plug_youtube => {
        dsn            => "DBI:mysql:database=test;host=localhost", # everything below is pretty much optional
        user            => '',
        pass            => '',
        opt             => { RaiseError => 1, AutoCommit => 1 },
        t_name          => 'plug_youtube',
        table           => 'videos',
        create_table    => 0,
        h_level         => 3,
        size            => 1,
        no_form         => 0,
        no_list         => 0,
        allow_edit      => 0,
        ua_args => [
            agent   => 'Opera 9.2',
            timeout => 30,
        ],
        filter          => {
            title       => qr/Foo/,
            description => qr/Bar/,
            link        => qr/234fd343/,
        },
    },

In your L<HTML::Template> template:

    <h2>Post new video</h2>
    <tmpl_var name='plug_youtube_form'>

    <h2>Existing Videos</h2>
    <tmpl_var name='plug_youtube_list'>

DESCRIPTION

The module is a plugin for L<App::ZofCMS>. It provides means to have a CRUD-like (Create, Read,
Update, Delete) interface for managing YouTube videos. The plugin provides a form where a
user can enter the title of the video, its YouTube URI and a description. That form is stored
in a SQL database by the plugin and can be displayed as a list.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

When C<create_table> option is turned on (see below) the plugin will create the following
table where C<table_name> is derived from C<table> argument in C<plug_youtube> (see below).

    CREATE TABLE table_name (
        title       TEXT,
        link        TEXT,
        description TEXT,
        embed       TEXT,
        time        VARCHAR(10),
        id          TEXT
    );

MAIN CONFIG FILE AND ZofCMS TEMPLATE FIRST-LEVEL KEYS

C<plugins>

    plugins => [ qw/YouTube/ ],

Without saying it, you need to add the plugin in the list of plugins to execute.

C<plug_youtube>

    plug_youtube => {
        dsn            => "DBI:mysql:database=test;host=localhost", # everything below is pretty much optional
        user            => '',
        pass            => '',
        opt             => { RaiseError => 1, AutoCommit => 1 },
        t_name          => 'plug_youtube',
        table           => 'videos',
        create_table    => 0,
        h_level         => 3,
        size            => 1,
        no_form         => 0,
        no_list         => 0,
        allow_edit      => 0,
        ua_args => [
            agent   => 'Opera 9.2',
            timeout => 30,
        ],
        filter          => {
            title       => qr/Foo/,
            description => qr/Bar/,
            link        => qr/234fd343/,
        },
    },

    plug_youtube => sub {
        my ( $t, $q, $config ) = @_;
        return {
            dsn => "DBI:mysql:database=test;host=localhost",
        }
    },

The plugin takes its config via C<plug_youtube> first-level key that takes a hashref
or a subref as a value and can be specified in
either Main Config File or ZofCMS Template or both. or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_youtube> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object.
If a certain key (does NOT apply to subrefs) in that hashref is set
in both, Main Config File and ZofCMS Template, the value for that key that is set in
ZofCMS Template will take precendence. The possible keys/values are as follows (virtually
all are optional and have default values):

C<dsn>

    dsn => "DBI:mysql:database=test;host=localhost",

B<Mandatory>. Takes a scalar as a value which must contain a valid
"$data_source" as explained in L<DBI>'s C<connect_cached()> method (which
plugin currently uses).

C<user>

    user => '',

B<Optional>. Takes a string as a value that specifies the user name to use when authorizing
with the database. B<Defaults to:> empty string

C<pass>

    pass => '',

B<Optional>. Takes a string as a value that specifies the password to use when authorizing
with the database. B<Defaults to:> empty string

C<opt>

    opt => { RaiseError => 1, AutoCommit => 1 },

B<Optional>. Takes a hashref as a value, this hashref contains additional L<DBI>
parameters to pass to C<connect_cached()> L<DBI>'s method. B<Defaults to:>
C<< { RaiseError => 1, AutoCommit => 1 } >>

C<table>

    table => 'videos',

B<Optional>. Takes a string as a value, specifies the name of the SQL table in which to
store information about videos. B<Defaults to:> C<videos>

C<create_table>

    create_table => 0,

B<Optional>. When set to a true value, the plugin will automatically create needed SQL table,
you can create it manually if you wish, see its format in C<USED SQL TABLE FORMAT> section
above. Generally you'd set this to a true value only once, at the start, and then you'd remove
it because there is no "IF EXISTS" checks. B<Defaults to:> C<0>

C<t_name>

    t_name => 'plug_youtube',

B<Optional>. Takes a string as a value. This string will be
used as a "base name" for two keys that plugin generates in C<{t}> special key.
The keys are C<plug_youtube_list> and C<plug_youtube_form> (providing C<t_name> is set to
default) and are explained below in C<HTML::Template VARIABLES> section below. B<Defaults to:>
C<plug_youtube>

C<h_level>

    h_level => 3,

B<Optional>. When generating a list of YouTube videos, plugin will use HTML C<< <h?> >>
elements (see C<GENERATED HTML CODE> section below).
The C<h_level> takes an integer between 1 and 6 and that value specifies what
C<< <h?> >> level to generate. B<Defaults to:> C<3> (generate C<< <h3> >> elements)

C<size>

    size => 1,
    # or
    size => [ 300, 200 ],

B<Optional>. Takes either an integer from 0 to 3 or an arrayref with two elements that are
positive intergers as a value. When the value is an arrayref the first element is treated
as the value of C<width=""> attribute and the second element is treated as the value for
C<height=""> attribute. These two control the size of the video. You can also use
integers from 0 to 3 to specify a "prefabricated" size (sort'f like a shortcut). The relation
between the integers and the sizes they represent is shown below. B<Defaults to:> C<1> (
size 425x344)

    0 => [ 320, 265 ],
    1 => [ 425, 344 ],
    2 => [ 480, 385 ],
    3 => [ 640, 505 ],

C<no_form>

    no_form => 0,

B<Optional>. Plugin generates an HTML form to input videos into the database, besides that,
it also B<processes> that form and makes sure everything is right. When C<no_form> is
set to a true value, the plugin will B<NOT> generate the form and most importantly it will
B<NOT> process anything; so if you are making your own form for input, make sure to leave
C<no_form> as false. B<Defaults to:> C<0>s

C<no_list>

    no_list => 0,

B<Optional>. Plugin automatically fetches all the available videos from the database and
prepares an HTML list to present them. When C<no_list> is set to a true value, plugin
will not generate any lists. B<Defaults to:> C<0>

C<allow_edit>

    allow_edit => 0,

B<Optional>. Applies only when both C<no_form> and C<no_list> are set to false values.
Takes either true or false values. When set to a true value, plugin will add C<Edit> and
C<Delete> buttons under every video with which the user will be able to (duh!) edit and
delete videos. B<Defaults to:> C<0>

B<Note:> the "edit" is not that smart in this plugin, what actually
happens is the video is deleted and its information is filled in the "entry" form. If the
user never hits "Add" button on the form, the video will be lost; let me know if this
creates a problem for you.

C<filter>

    filter => {
        title       => qr/Foo/,
        description => qr/Bar/,
        link        => qr/234fd343/,
    },

B<Optional>. You can set a filter when displaying the list of videos. The C<filter>
argument takes a hashref as a value. All keys take a regex (C<qr//>) as a value. The field
referenced by the key B<must match> the regex in order for the video to be put in the list
of videos. B<By default> is not specified. You can specify either 1 or all 3 keys. Possible
keys and what they reference are as follows:

C<title>

    filter => {
        title => qr/Foo/,
    },

B<Optional>. The C<title> key's regex matches the titles of the videos.

C<description>

    filter => {
        description => qr/Bar/,
    },

B<Optional>. The C<description> key's regex matches the descriptions of the videos.

C<link>

    filter => {
        link => qr/234fd343/,
    },

B<Optional>. The C<link> key's regex matches the links of the videos.

C<ua_args>

    ua_args => [
        agent   => 'Opera 9.2',
        timeout => 30,
    ],

B<Optional>. Under the hood plugin uses L<LWP::UserAgent> to access YouTube for fetching
the "embed" code for the videos. The C<ua_args> takes an arrayref as a value. This
arrayref will be directly derefrenced into L<LWP::UserAgent>'s constructor (C<new()> method).
See L<LWP::UserAgent> for possible options. B<Defaults to:>
C<< [ agent => 'Opera 9.2', timeout => 30, ] >>

HTML::Template VARIABLES

The plugin generates two keys in C<{t}> ZofCMS Template special key, thus making them
available for use in your L<HTML::Template> templates. Assuming C<t_name> is left at its
default value the following are the names of those two keys:

C<plug_youtube_form>

    <tmpl_var name='plug_youtube_form'>

This variable will contain HTML form generated by the plugin, the form also includes display
of errors.

C<plug_youtube_list>

    <tmpl_var name='plug_youtube_list'>

This variable will contain the list of videos generated by the plugin.

GENERATED HTML CODE

form

    <form action="" method="POST" id="plug_youtube_form">

    <div>
        <p class="error">Incorrect YouTube link
        <input type="hidden" name="page" value="videos">
        <input type="hidden" name="dir" value="/admin/">
        <ul>
            <li>
                <label for="plug_youtube_title">Title: </label
                ><input type="text" id="plug_youtube_title" name="plug_youtube_title" value="xxx">
            </li>
            <li>

                <label for="plug_youtube_link">Link: </label
                ><input type="text" id="plug_youtube_link" name="plug_youtube_link" value="">
            </li>
            <li>
                <label for="plug_youtube_description">Description: </label
                ><textarea id="plug_youtube_description" name="plug_youtube_description" cols="60" rows="10"></textarea>
            </li>
        </ul>
        <input type="submit" name="plug_youtube_submit" value="Add">
    </div>
    </form>

list

B<Note:> the C<< <form> >> will not be there if C<allow_edit> option is set to a false
value.

    <ul id="plug_youtube_list">
        <li>
            <h3><a href="http://www.youtube.com/watch?v=RvcaNIwtkfI">Some club</a></h3>
            <p class="plug_youtube_time">Posted on: Wed Dec 10 21:14:01 2008</p>
            <div class="plug_youtube_video"><object width="200" height="165"><param name="movie" value="http://www.youtube.com/v/RvcaNIwtkfI&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/RvcaNIwtkfI&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="200" height="165"></embed></object></div>
            <p class="plug_youtube_description">Description</p>
                <form action="" method="POST">
                <div>
                    <input type="hidden" name="plug_youtube_vid_edit_id" value="03716801501150291228961641000660045686842636">
                    <input type="hidden" name="page" value="videos">
                    <input type="hidden" name="dir" value="/admin/">
                    <input type="submit" class="submit_button_edit" name="plug_youtube_vid_edit_action" value="Edit">
                    <input type="submit" class="submit_button_delete" name="plug_youtube_vid_edit_action" value="Delete">
                </div>
                </form>
        </li>
        <li class="alt">
            <h3><a href="http://www.youtube.com/watch?v=RvcaNIwtkfI">Some club</a></h3>
            <p class="plug_youtube_time">Posted on: Wed Dec 10 21:13:30 2008</p>
            <div class="plug_youtube_video"><object width="200" height="165"><param name="movie" value="http://www.youtube.com/v/RvcaNIwtkfI&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/RvcaNIwtkfI&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="200" height="165"></embed></object></div>
            <p class="plug_youtube_description">Description</p>
                <form action="" method="POST">
                <div>
                    <input type="hidden" name="plug_youtube_vid_edit_id" value="051156628115950712289616100613964522347914">
                    <input type="hidden" name="page" value="videos">
                    <input type="hidden" name="dir" value="/admin/">
                    <input type="submit" class="submit_button_edit" name="plug_youtube_vid_edit_action" value="Edit">
                    <input type="submit" class="submit_button_delete" name="plug_youtube_vid_edit_action" value="Delete">
                </div>
                </form>
        </li>
    </ul>

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://zoffix.com/>, L<http://haslayout.net/>, L<http://mind-power-book.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-pluginreference at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-PluginReference>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::PluginReference

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-PluginReference>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-PluginReference>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-PluginReference>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-PluginReference>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

