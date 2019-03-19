package Module::Preloadable;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(load_or_preload);

sub load_or_preload {
    (my $pm = "$_[0].pm") =~ s!::!/!g;
    require $pm;
}

if ($ENV{PERL_PRELOAD_MODULES}) {
    # ...
} else {
    require B::CallChecker;
    require B::Generate;
    B::CallChecker::cv_set_call_checker(
        \&load_or_preload,
        # XXX how to retrieve load_or_preload's parameter?
        sub { B::UNOP->new("require",0, B::SVOP->new("const", 0, "Color/RGB/Util.pm") ) },
        \!1,
    );
}

1;
