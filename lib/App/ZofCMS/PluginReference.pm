package App::ZofCMS::PluginReference;

use warnings;
use strict;

our $VERSION = '0.0103';


1;
__END__

=head1 NAME

App::ZofCMS::PluginReference - docs for all plugins in one document for easy reference

=head1 DESCRIPTION

I often found myself reaching out for docs for different plugins cluttering up my browser. The solution - stick all docs into one!.

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


=head1 App::ZofCMS::Plugin::AutoIMGSize (version 0.0101)

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


=head1 App::ZofCMS::Plugin::Base (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::Base>



App::ZofCMS::Plugin::Base - base class for App::ZofCMS plugins

SYNOPSIS

    package App::ZofCMS::Plugin::Example;

    use strict;
    use warnings;
    use base 'App::ZofCMS::Plugin::Base';

    sub _key { 'plug_example' }
    sub _defaults { qw/foo bar baz beer/ }
    sub _do {
        my ( $self, $conf, $template, $query, $config ) = @_;
    }

DESCRIPTION

The module is a base class for L<App::ZofCMS> plugins. I'll safely assume that you've
already read the docs for L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

The base class (currently) is only for plugins who take their "config" as a single
first-level key in either Main Config File or ZofCMS Template. That key's value
must be a hashref.

SUBS TO OVERRIDE

C<_key>

    sub _key { 'plug_example' }

The C<_key> needs to return a scalar contain the name of first level key in ZofCMS template
or Main Config file. Study the source code of this module to find out what it's used for
if it's still unclear.

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


=head1 App::ZofCMS::Plugin::BreadCrumbs (version 0.0102)

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
of the plugin. The key takes a hashref as a value.
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


=head1 App::ZofCMS::Plugin::Cookies (version 0.0103)

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


=head1 App::ZofCMS::Plugin::DBI (version 0.0202)

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
        },
    }

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

The C<dbi_get> key takes either a hashref or an arrayref as a value.
If the value is a hashref it is the same as having just that hashref
inside the arrayref. Each element of the arrayref must be a hashref with
instructions on how to retrieve the data. The possible keys/values of
that hashref are as follows:

C<layout>

    layout  => [ qw/name pass time info/ ],

B<Mandatory>. Takes an arrayref as an argument.
Specifies the name of C<< <tmpl_var name=""> >>s in your
C<< <tmpl_loop> >> (see C<type> argument below) to which map the columns
retrieved from the database, see C<SYNOPSIS> section above.

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


=head1 App::ZofCMS::Plugin::Debug::Dumper (version 0.0101)

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


=head1 App::ZofCMS::Plugin::DirTreeBrowse (version 0.0102)

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

The C<plug_dir_tree> takes a hashref as a value and can be set in either Main Config file or
ZofCMS Template file. Keys that are set in both Main Config file and ZofCMS Template file
will get their values from ZofCMS Template file. Possible keys/values of C<plug_dir_tree>
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


=head1 App::ZofCMS::Plugin::FileUpload (version 0.0101)

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

B<Optional>. Specifies the name (without the extension)
of the local file into which save the uploaded file. Special value of
C<[rand]> specifies that the name should be random, in which case it
will be created by calling C<rand()> and C<time()> and removing any dots
from the concatenation of those two. B<Defaults to:> C<[rand]>

C<ext>

    { ext => '.html', }

B<Optional>. Specifies the extension to use for the name of local file
into which the upload will be stored. B<By default> is not specified
and therefore the extension will be obtained from the name of the remote
file.

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


=head1 App::ZofCMS::Plugin::FormChecker (version 0.0301)

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
key C<plug_form_checker> to a true value. The C<ok_key> parameter specifies the
B<first level> key in ZofCMS template where to put the C<plug_form_checker> key. For example,
you can set C<ok_key> to C<'t'> and then in your L<HTML::Template> template use
C<< <tmpl_if name="plug_form_checker">FORM OK!</tmpl_if> >>... but, beware of using
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
The C<rules> key takes a hashref as a value. The keys of that hashref are the names
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
            valid_values_error   => '', # same for valid_values rule
            param_error          => '', # same fore param rule
        },
    }

You can mix and match the rules for perfect tuning.

C<name>

    name => 'Decent name',

This is not actually a rule but the text to use for the name of the parameter in error
messages. If not specified the actual parameter name will be used.

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

If the form values failed any of your checks, the plugin will set C<plug_form_checker_error>
key in C<{t}> special key explaining the error. The sample usage of this is presented above.


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


=head1 App::ZofCMS::Plugin::FormMailer (version 0.0101)

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

The plugin will not run unless C<plug_form_mailer> first-level key is set in either Main
Config File or ZofCMS Template file. The C<plug_form_mailer> first-level key takes a hashref
as a value. Keys that are set in both Main Config File and ZofCMS Template file will take on
their values from ZofCMS Template. Possible keys/values are as follows:

C<format>

        format  => <<'END',
    The following account request has been submitted:
    First name: {:{first_name}:}
    Time:       {:[time]:}
    Host:       {:[host]:}
    END
        },

B<Mandatory>. The C<format> key takes a scalar as a value. This scalar represents the body
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


=head1 App::ZofCMS::Plugin::LinksToSpecs::CSS (version 0.0101)

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


=head1 App::ZofCMS::Plugin::NavMaker (version 0.0102)

NAME


Link: L<App::ZofCMS::Plugin::NavMaker>



App::ZofCMS::Plugin::NavMaker - ZofCMS plugin for making navigation bars

SYNOPSIS

In your ZofCMS Template:

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

FIRST LEVEL ZofCMS TEMPLATE KEYS

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

Takes an arrayref as a value elements of which can either be strings
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


=head1 App::ZofCMS::Plugin::QuickNote (version 0.0105)

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
        <input type="submit" value="Send">
    </div>
    </form>


=head1 App::ZofCMS::Plugin::StyleSwitcher (version 0.0101)

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

The plugin reads it's configuration from L<plug_style_switcher> first-level ZofCMS Template
or Main Config file template. Keys that are set in ZofCMS Template will override same
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


=head1 App::ZofCMS::Plugin::UserLogin (version 0.0102)

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

logout form

    <form action="" method="POST" id="zofcms_plugin_login_logout">
    <div>
        <input type="hidden" name="page" value="/login">
        <input type="hidden" name="zofcms_plugin_login" value="logout_user">
        <input type="submit" value="Logout">
    </div>
    </form>


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




=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://zoffix.com/>, L<http://haslayout.net/>, L<http://zofdesign.com/>)

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

