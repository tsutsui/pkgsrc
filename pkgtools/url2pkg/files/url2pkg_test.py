# $NetBSD: url2pkg_test.py,v 1.58 2025/01/23 06:05:44 rillig Exp $

# URLs for manual testing:
#
# https://files.pythonhosted.org/packages/source/p/pysha3/pysha3-1.0.2.tar.gz
#   Prefers distutils over setuptools, has no external dependencies.
#
# https://github.com/pytorch/pytorch/archive/refs/tags/v1.12.0.tar.gz
#   Uses setuptools with an extension.
#   Runs Git from 'setup.py', which is rather unusual.

import pytest
from url2pkg import *
from textwrap import dedent

mkcvsid = '# $''NetBSD$'
g: Globals
prev_dir = Path.cwd()


def setup_function(_):
    global g

    g = Globals()
    os.chdir(g.pkgsrcdir / 'pkgtools' / 'url2pkg')

    class Wr:
        def __init__(self) -> None:
            self.buf = ''

        def write(self, s: str):
            self.buf += s

        def written(self) -> List[str]:
            result = self.buf
            self.buf = ''
            return result.splitlines()

    g.out = Wr()
    g.err = Wr()


def teardown_function(_):
    os.chdir(prev_dir)
    assert g.out.written() == []
    assert g.err.written() == []


def str_vars(vars: List[Var]) -> List[str]:
    def to_string(var):
        return var.name + var.op + var.value

    return list(map(to_string, vars))


def str_varassigns(varassigns: List[Varassign]) -> List[str]:
    def to_string(v: Varassign) -> str:
        return f'{v.varname}{v.op}{v.indent}' \
               f'{v.value}{v.space_after_value}{v.comment}'

    return list(map(to_string, varassigns))


def detab(lines: Lines) -> List[str]:
    """ Replaces tabs with the appropriate amount of spaces. """

    def detab_line(line: str) -> str:
        detabbed = []
        for ch in line:
            if ch == '\t':
                detabbed.append('        '[:8 - len(detabbed) % 8])
            else:
                detabbed.append(ch)
        return ''.join(detabbed)

    return list(map(detab_line, lines.lines))


def test_Global_debug():
    g.verbose = True

    g.debug('plain message')
    g.debug('list {0}', [1, 2, 3])
    g.debug('tuple {0}', (1, 2, 3))
    g.debug('cwd {0} env {1} cmd {2}', 'directory', {'VAR': 'value'}, 'command')

    assert g.err.written() == [
        'url2pkg: plain message',
        'url2pkg: list [1, 2, 3]',
        'url2pkg: tuple (1, 2, 3)',
        'url2pkg: cwd \'directory\' env {\'VAR\': \'value\'} cmd \'command\'',
    ]


def test_Global_bmake():
    g.verbose = True
    g.make = 'echo'

    g.bmake('hello', 'world')

    assert g.err.written() == [
        'url2pkg: running bmake (\'hello\', \'world\') in \'.\'',
    ]


def test_Global_pkgsrc_license():
    assert g.pkgsrc_license('BSD') == ''  # too unspecific
    assert g.pkgsrc_license('apache-2.0') == 'apache-2.0'
    assert g.pkgsrc_license('Apache 2') == 'apache-2.0'

    # Not explicitly in the list, looked up from PKGSRCDIR.
    assert g.pkgsrc_license('skype21-license') == 'skype21-license'

    assert g.pkgsrc_license('mit + file LICENSE') == 'mit\t# + file LICENSE'
    assert g.pkgsrc_license('MIT | file LICENSE') == 'mit\t# OR file LICENSE'

    # Neither in the list nor in PKGSRCDIR/licenses.
    assert g.pkgsrc_license('unknown') == ''


def test_Lines__write_and_read(tmp_path: Path):
    example = tmp_path / 'example'

    lines = Lines('1', '2', '3')

    lines.write_to(example)

    assert example.read_text() == '1\n2\n3\n'

    back = Lines.read_from(example)

    assert back.lines == ['1', '2', '3']


def test_Lines_all_varassigns():
    lines = Lines(
        'OTHER=\tvalue',  # unrelated variable name
        'VAR=\tvalue',
        'VAR=value',  # no space between operator and value
        'VAR=\t# only comment',
        '#VAR=\t# commented variable assignment',
        '#VAR=',
        '# VAR=',  # This is a regular comment
        'VAR= \\',
        '\tmulti-first \\',
        '\tmulti-last'
    )

    assert str_varassigns(lines.all_varassigns('VAR')) == [
        'VAR=\tvalue',
        'VAR=value',
        'VAR=\t# only comment',
        '#VAR=\t# commented variable assignment',
        '#VAR=',
        # TODO: Add support for multi-line variable assignments.
    ]


def test_Lines_unique_varassign():
    lines = Lines(
        'UNIQUE=\tunique',
        'REPEATED=\tfirst',
        'REPEATED+=\tlast',
    )

    assert lines.unique_varassign('UNIQUE') is not None
    assert lines.unique_varassign('REPEATED') is None


def test_Lines_get():
    lines = Lines(
        'VAR=value',
        'VAR=\tvalue # comment',
        'UNIQUE=\tunique',
        '#COMMENTED=\tvalue',
    )

    assert lines.get('VAR') == ''  # too many values
    assert lines.get('ENOENT') == ''  # not found
    assert lines.get('UNIQUE') == 'unique'
    assert lines.get('COMMENTED') == ''  # commented out


def test_Lines_index():
    lines = Lines('1', '2', '345')

    assert lines.index('1') == 0
    assert lines.index('2') == 1
    assert lines.index('345') == 2
    assert lines.index('4') == 2

    assert lines.index(r'^(\d\d)\d$') == 2
    assert lines.index(r'^\d\s\d$') == -1
    assert lines.index(r'(\d)') == 0


def test_Lines_add():
    lines = Lines()

    lines.add('')

    # Adding variables might also be supported one day.
    with pytest.raises(AssertionError):
        lines.add(Var('VAR', '=', 'value'))

    with pytest.raises(AssertionError):
        lines.add(1)


def test_Lines_add_vars__simple():
    lines = Lines()

    lines.add_vars(
        Var('1', '=', 'one'),
        Var('6', '=', 'six'),
    )

    assert lines.lines == [
        '1=\tone',
        '6=\tsix',
        '',
    ]


def test_Lines_add_vars__alignment():
    lines = Lines()

    lines.add_vars(
        Var('short', '=', 'value'),
        Var('long_name', '=', 'value # comment'),
    )

    assert lines.lines == [
        'short=\t\tvalue',
        'long_name=\tvalue # comment',
        '',
    ]


def test_Lines_add_vars__operators():
    lines = Lines()

    lines.add_vars(Var('123456', '=', 'value'))
    lines.add_vars(Var('1234567', '=', 'value'))
    lines.add_vars(Var('123456', '+=', 'value'))

    assert lines.lines == [
        '123456=\tvalue',
        '',
        '1234567=\tvalue',
        '',
        '123456+=\tvalue',
        '',
    ]


def test_Lines_add_vars__empty():
    lines = Lines('# initial')

    lines.add_vars()

    # No empty line is added.
    assert lines.lines == ['# initial']


def test_Lines_set__replace_comment():
    lines = Lines('LICENSE=\t# TODO: see mk/license.mk')

    assert lines.set('LICENSE', '${PERL5_LICENSE}')

    assert lines.lines == ['LICENSE=\t${PERL5_LICENSE}']


def test_Lines_set__overwrite_commented_comment_with_comment():
    lines = Lines('#LICENSE=\t# TODO: see mk/license.mk')

    assert lines.set('LICENSE', '${PERL5_LICENSE}')

    assert lines.lines == ['LICENSE=\t${PERL5_LICENSE}']


def test_Lines_set__not_found():
    lines = Lines('OLD_VAR=\told value # old comment')

    assert not lines.set('NEW_VAR', 'new value')

    assert lines.lines == ['OLD_VAR=\told value # old comment']


def test_Lines_append__not_found():
    lines = Lines()

    lines.append('VARNAME', 'value')

    assert lines.lines == []


def test_Lines_append__no_value_only_comment():
    lines = Lines('VARNAME=\t\t\t# none')

    lines.append('VARNAME', 'value')

    assert lines.lines == ['VARNAME=\t\t\tvalue # none']


def test_Lines_append__value_with_comment():
    lines = Lines('VARNAME=\tvalue # comment')

    lines.append('VARNAME', 'appended')

    assert lines.lines == ['VARNAME=\tvalue appended # comment']


def test_Lines_append__value_without_comment():
    lines = Lines('VARNAME+=\tvalue')

    assert lines.append('VARNAME', 'appended')

    assert lines.lines == ['VARNAME+=\tvalue appended']


def test_Lines_append__multiple_assignments():
    # When there is more than one assignment for a variable,
    # it may not be clear which to append to.
    # The assignments might be in an .if statement.
    # Therefore, rather do nothing.
    # Assuming no .if statements, appending to the last one makes sense.

    lines = Lines('VARNAME+=\tvalue1', 'VARNAME+=\tvalue2')

    assert not lines.append('VARNAME', 'appended')

    assert lines.lines == ['VARNAME+=\tvalue1', 'VARNAME+=\tvalue2']


def test_Lines_remove__not_found():
    lines = Lines('VAR=\tvalue')

    assert not lines.remove('VARIABLE')

    assert lines.lines == ['VAR=\tvalue']


def test_Lines_remove__found():
    lines = Lines('VAR=\tvalue')

    assert lines.remove('VAR')

    assert lines.lines == []


def test_Lines_remove__found_several_times():
    lines = Lines('VAR=\tvalue1', 'VAR=\tvalue2')

    assert not lines.remove('VAR')

    assert lines.lines == ['VAR=\tvalue1', 'VAR=\tvalue2']


def test_Lines_remove_if__different_name():
    lines = Lines('VAR=\tvalue')

    assert not lines.remove_if('VARIABLE', 'value')

    assert lines.lines == ['VAR=\tvalue']


def test_Lines_remove_if__different_value():
    lines = Lines('VAR=\tvalue')

    assert not lines.remove_if('VAR', 'something')

    assert lines.lines == ['VAR=\tvalue']


def test_Lines_remove_if__found():
    lines = Lines('VAR=\tvalue')

    assert lines.remove_if('VAR', 'value')

    assert lines.lines == []


def test_Lines_remove_if__multiple():
    lines = Lines('VAR=\tvalue', 'VAR=\tvalue')

    assert lines.remove_if('VAR', 'value')

    assert lines.lines == ['VAR=\tvalue']

    assert lines.remove_if('VAR', 'value')

    assert lines.lines == []


def test_PackageVars_adjust_site_SourceForge():
    url = 'http://downloads.sourceforge.net/sourceforge/rfcascade/cascade-1.4.tar.gz'

    lines = Generator(url).generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       cascade-1.4',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_SOURCEFORGE:=rfcascade/}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://rfcascade.sourceforge.net/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_GitHub_archive():
    url = 'https://github.com/org/proj/archive/v1.0.0.tar.gz'

    lines = Generator(url).generate_Makefile()
    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       v1.0.0',
        'PKGNAME=        ${GITHUB_PROJECT}-${DISTNAME:S,^v,,}',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=org/}',
        'GITHUB_PROJECT= proj',
        'GITHUB_TAG=     v1.0.0',
        'DIST_SUBDIR=    ${GITHUB_PROJECT}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/org/proj/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_GitHub_archive__tag():
    url = 'https://github.com/org/proj/archive/refs/tags/1.0.0.tar.gz'

    lines = Generator(url).generate_Makefile()
    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       1.0.0',
        'PKGNAME=        ${GITHUB_PROJECT}-${DISTNAME}',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=org/}',
        'GITHUB_PROJECT= proj',
        'GITHUB_TAG=     refs/tags/1.0.0',
        'DIST_SUBDIR=    ${GITHUB_PROJECT}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/org/proj/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_GitHub_archive__tag_v():
    url = 'https://github.com/org/proj/archive/refs/tags/v1.0.0.tar.gz'

    lines = Generator(url).generate_Makefile()
    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       proj-1.0.0',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=org/}',
        'GITHUB_TAG=     refs/tags/v${PKGVERSION_NOREV}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/org/proj/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        'WRKSRC= ${WRKDIR}/${DISTNAME}',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_GitHub_release__containing_project_name():
    url = 'https://github.com/org/proj/releases/download/1.0.0/proj.zip'

    lines = Generator(url).generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       proj',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=org/}',
        'GITHUB_PROJECT= proj',
        'GITHUB_RELEASE= 1.0.0',
        'EXTRACT_SUFX=   .zip',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/org/proj/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_PackageVars_adjust_site_GitHub_release__not_containing_project_name():
    url = 'https://github.com/org/proj/releases/download/1.0.0/data.zip'

    lines = Generator(url).generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       data',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=org/}',
        'GITHUB_PROJECT= proj',
        'GITHUB_RELEASE= 1.0.0',
        'EXTRACT_SUFX=   .zip',
        'DIST_SUBDIR=    ${GITHUB_PROJECT}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/org/proj/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_PackageVars_adjust_site_from_sites_mk__with_subdir():
    url = 'https://files.pythonhosted.org/packages/source/i/irc/irc-11.1.1.zip'
    generator = Generator(url)

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       irc-11.1.1',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_PYPI:=i/irc/}',
        'EXTRACT_SUFX=   .zip',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://files.pythonhosted.org/packages/source/i/irc/ # TODO: check',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_from_sites_mk__without_subdir():
    url = 'https://files.pythonhosted.org/packages/source/irc-11.1.1.zip'
    generator = Generator(url)

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       irc-11.1.1',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_PYPI}',
        'EXTRACT_SUFX=   .zip',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       # TODO',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_from_sites_mk__CPAN():
    url = 'https://cpan.metacpan.org/authors/id/M/MA/MAMAWE/Algorithm-CheckDigits-v1.3.6.tar.gz'
    generator = Generator(url)

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       Algorithm-CheckDigits-v1.3.6',
        'PKGNAME=        p5-${DISTNAME:S,-v,-,}',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_PERL_CPAN:=Algorithm/}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://metacpan.org/pod/Algorithm::CheckDigits',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_from_sites_mk__GNU():
    url = 'https://ftp.gnu.org/pub/gnu/cflow/cflow-1.6.tar.gz'
    generator = Generator(url)

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       cflow-1.6',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_GNU:=cflow/}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://www.gnu.org/software/cflow/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_from_sites_mk__PyPI():
    url = ('https://files.pythonhosted.org/'
           + 'packages/da/8b/218264f5ce91df1ad27ce8021d51b747ef287627338fe05d170565358546/'
           + 'apprise-0.9.6.tar.gz')
    generator = Generator(url)

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       apprise-0.9.6',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   ${MASTER_SITE_PYPI:=a/apprise/}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://pypi.org/project/apprise/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_PackageVars_adjust_site_from_sites_mk__R(tmp_path: Path):
    g.pkgdir = tmp_path
    url = 'http://cran.r-project.org/src/contrib/forecast_8.7.tar.gz'

    with pytest.raises(SystemExit, match='^url2pkg: to create R packages, use pkgtools/R2pkg instead$'):
        _ = Generator(url)

    assert list(tmp_path.glob('*')) == []


def test_PackageVars_adjust_site_other__malformed_URL():
    # This error is supposed to be handled by the URL check in main.

    error = "'NoneType' object has no attribute 'groups'"
    with pytest.raises(AttributeError, match=error):
        Generator('localhost').generate_Makefile()


def test_PackageVars_adjust_everything_else__distname_version_with_v():
    # Some version numbers have a leading 'v', derived from the Git tag name.

    url = 'https://cpan.example.org/Algorithm-CheckDigits-v1.3.2.tar.gz'

    lines = Generator(url).generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       Algorithm-CheckDigits-v1.3.2',
        'PKGNAME=        ${DISTNAME:S,-v,-,}',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   https://cpan.example.org/',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://cpan.example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_PackageVars_adjust_everything_else__distfile_without_extension():
    url = 'https://example.org/app-2019-10-05'

    lines = Generator(url).generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       app-2019-10-05',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   https://example.org/',
        'EXTRACT_SUFX=   # none',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_PackageVars_adjust_everything_else__v8():
    generator = Generator('https://example.org/v8-1.0.zip')

    lines = generator.generate_Makefile()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       v8-1.0',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   https://example.org/',
        'EXTRACT_SUFX=   .zip',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_Generator_generate_package(tmp_path: Path):
    url = 'https://ftp.gnu.org/pub/gnu/cflow/cflow-1.6.tar.gz'
    g.make = 'true'  # the shell command
    g.pkgdir = tmp_path

    Generator(url).generate_package(g)

    assert not (tmp_path / 'DESCR').is_file()  # is created later
    assert len((tmp_path / 'Makefile').read_text().splitlines()) == 13
    assert (tmp_path / 'PLIST').read_text().splitlines() == [
        '@comment $''NetBSD$',
        '@comment TODO: to fill this file with the file listing:',
        '@comment TODO: 1. run "true package"',
        '@comment TODO: 2. run "true print-PLIST"',
    ]

    # Since bmake is only fake in this test, the distinfo file is not created.
    expected_files = ['Makefile', 'PLIST']
    assert sorted([f.name for f in tmp_path.glob("*")]) == expected_files


def test_Adjuster_read_dependencies():
    child_process_output = [
        'DEPENDS\tpackage>=112.0:../../pkgtools/pkglint',
        'DEPENDS\tpackage>=120.0:../../pkgtools/x11-links',
        'BUILD_DEPENDS\turl2pkg>=1.0b',
        'BUILD_DEPENDS\tdoes-not-exist-build>=1.0',
        'TOOL_DEPENDS\turl2pkg>=1.0t',
        'TOOL_DEPENDS\tdoes-not-exist-tool>=1.0',
        'TEST_DEPENDS\tpkglint',
        'A line that is not a dependency at all',
        '',
        'var\tHOMEPAGE\thttps://homepage.example.org/',
        '',
        'cmd\tlicense\tBSD',
        'cmd\tlicense_default\tBSD # (from Python package)',
        'cmd\tunknown-cmd\targ',
    ]
    env = {'URL2PKG_DEPENDENCIES': '\n'.join(child_process_output)}
    cmd = "printf '%s\n' \"$URL2PKG_DEPENDENCIES\""

    adjuster = Adjuster(g, '', Lines())
    adjuster.makefile_lines.add('# url2pkg-marker')
    adjuster.read_dependencies(cmd, env, '.')

    assert os.getenv('URL2PKG_DEPENDENCIES') is None
    assert adjuster.depends == ['package>=112.0:../../pkgtools/pkglint']
    assert adjuster.bl3_lines == [
        'BUILDLINK_API_DEPENDS.x11-links+=\tpackage>=120.0',
        '.include "../../pkgtools/x11-links/buildlink3.mk"',
    ]
    assert adjuster.build_depends == [
        '# TODO: does-not-exist-build>=1.0',
        'url2pkg>=1.0b:../../pkgtools/url2pkg',
    ]
    assert adjuster.tool_depends == [
        '# TODO: does-not-exist-tool>=1.0',
        'url2pkg>=1.0t:../../pkgtools/url2pkg',
    ]
    assert adjuster.test_depends == ['pkglint>=0:../../pkgtools/pkglint']
    assert detab(adjuster.generate_lines()) == [
        'BUILD_DEPENDS+= # TODO: does-not-exist-build>=1.0',
        'BUILD_DEPENDS+= url2pkg>=1.0b:../../pkgtools/url2pkg',
        'TOOL_DEPENDS+=  # TODO: does-not-exist-tool>=1.0',
        'TOOL_DEPENDS+=  url2pkg>=1.0t:../../pkgtools/url2pkg',
        'DEPENDS+=       package>=112.0:../../pkgtools/pkglint',
        'TEST_DEPENDS+=  pkglint>=0:../../pkgtools/pkglint',
        '',
        'HOMEPAGE=       https://homepage.example.org/',
        '#LICENSE=       BSD # (from Python package)',
        '',
        'BUILDLINK_API_DEPENDS.x11-links+=       package>=120.0',
        '.include "../../pkgtools/x11-links/buildlink3.mk"'
    ]


def test_Adjuster_read_dependencies__lookup_python():
    child_process_output = [
        'DEPENDS\tpyobjc-framework-Quartz>=0',
        # begin from py-slixmpp
        'DEPENDS\tpyasn1>=0',
        'DEPENDS\tpyasn1_modules>=0',
        'DEPENDS\ttyping_extensions;python_version<"3.8.0">=0',
        # end from py-slixmpp
        '',
    ]
    env = {'URL2PKG_DEPENDENCIES': '\n'.join(child_process_output)}
    cmd = "printf '%s\n' \"$URL2PKG_DEPENDENCIES\""

    adjuster = Adjuster(g, '', Lines())
    adjuster.read_dependencies(cmd, env, '.', python=True)

    assert adjuster.depends == [
        '${PYPKGPREFIX}-asn1>=0:../../security/py-asn1',
        '${PYPKGPREFIX}-asn1-modules>=0:../../security/py-asn1-modules',
        '${PYPKGPREFIX}-pyobjc-framework-Quartz>=0:../../devel/py-pyobjc-framework-Quartz',
        '# TODO: typing_extensions;python_version<"3.8.0">=0',
    ]


def test_Adjuster_wrksrc_grep(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'file').write_text('\n'.join(
        ('a', 'b', 'c', 'd', 'e', 'abc', 'def', 'ghi')
    ))

    assert adjuster.wrksrc_grep('file', r'e') == ['e', 'def']
    assert adjuster.wrksrc_grep('file', r'(.)(.)(.)') == [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i'],
    ]


def test_Adjuster_generate_adjusted_Makefile_lines():
    adjuster = Adjuster(g, 'https://example.org/pkgname-1.0.tar.gz', Lines())
    adjuster.makefile_lines = Lines(
        '# before 1',
        '# before 2',
        '# url2pkg-marker',
        '# after 1',
        '# after 2'
    )

    lines = adjuster.generate_lines()

    assert lines.lines == [
        '# before 1',
        '# before 2',
        '# after 1',
        '# after 2',
    ]


def test_Adjuster_generate_adjusted_Makefile_lines__dependencies():
    adjuster = Adjuster(g, 'https://example.org/pkgname-1.0.tar.gz', Lines())
    adjuster.makefile_lines.add(
        mkcvsid,
        '',
        '# url2pkg-marker',
        '.include "../../mk/bsd.pkg.mk"'
    )
    # some dependencies whose directory will not be found
    adjuster.add_dependency('DEPENDS', 'depends', '>=5.0', '../../devel/depends')
    adjuster.add_dependency('TOOL_DEPENDS', 'tool-depends', '>=6.0', '../../devel/tool-depends')
    adjuster.add_dependency('BUILD_DEPENDS', 'build-depends', '>=7.0', '../../devel/build-depends')
    adjuster.add_dependency('TEST_DEPENDS', 'test-depends', '>=8.0', '../../devel/test-depends')
    # some dependencies whose directory is explicitly given
    adjuster.depends.append('depends>=11.0:../../devel/depends')
    adjuster.build_depends.append('build-depends>=12.0:../../devel/build-depends')
    adjuster.tool_depends.append('tool-depends>=12.5:../../devel/tool-depends')
    adjuster.test_depends.append('test-depends>=13.0:../../devel/test-depends')

    lines = adjuster.generate_lines()

    assert detab(lines) == [
        mkcvsid,
        '',
        'BUILD_DEPENDS+= # TODO: build-depends>=7.0',
        'BUILD_DEPENDS+= build-depends>=12.0:../../devel/build-depends',
        'TOOL_DEPENDS+=  # TODO: tool-depends>=6.0',
        'TOOL_DEPENDS+=  tool-depends>=12.5:../../devel/tool-depends',
        'DEPENDS+=       # TODO: depends>=5.0',
        'DEPENDS+=       depends>=11.0:../../devel/depends',
        'TEST_DEPENDS+=  # TODO: test-depends>=8.0',
        'TEST_DEPENDS+=  test-depends>=13.0:../../devel/test-depends',
        '',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_Adjuster_generate_adjusted_Makefile_lines__dont_overwrite_PKGNAME():
    adjuster = Adjuster(g, 'https://example.org/pkgname-1.0.tar.gz', Lines())
    adjuster.makefile_lines.add(
        mkcvsid,
        'DISTNAME=\tdistname-1.0',
        'PKGNAME=\tmanually-edited-pkgname-1.0'
        '',
        '# url2pkg-marker',
        '.include "../../mk/bsd.pkg.mk"'
    )

    lines = adjuster.generate_lines()

    assert detab(lines) == [
        mkcvsid,
        'DISTNAME=       distname-1.0',
        'PKGNAME=        manually-edited-pkgname-1.0',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_Adjuster_generate_adjusted_Makefile_lines__add_PKGNAME():
    adjuster = Adjuster(g, 'https://example.org/pkgname-1.0.tar.gz', Lines())
    adjuster.makefile_lines.add(
        mkcvsid,
        'DISTNAME=\tdistname-1.0',
        '',
        '# url2pkg-marker',
        '.include "../../mk/bsd.pkg.mk"'
    )

    lines = adjuster.generate_lines()

    assert lines.lines == [
        mkcvsid,
        'DISTNAME=\tdistname-1.0',
        '',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_Adjuster_generate_adjusted_Makefile_lines__add_PKGNAME_with_prefix():
    adjuster = Adjuster(g, 'https://example.org/pkgname-1.0.tar.gz', Lines())
    adjuster.makefile_lines.add(
        mkcvsid,
        'DISTNAME=\tdistname-1.0',
        '',
        '# url2pkg-marker',
        '.include "../../mk/bsd.pkg.mk"'
    )
    adjuster.pkgname_prefix = '${PYPKGPREFIX}-'

    lines = adjuster.generate_lines()

    assert lines.lines == [
        mkcvsid,
        'DISTNAME=\tdistname-1.0',
        'PKGNAME=\t${PYPKGPREFIX}-${DISTNAME}',
        '',
        '.include "../../mk/bsd.pkg.mk"'
    ]


def test_Adjuster_add_dependency__buildlink():
    # Note: this test only works because it runs in pkgtools/url2pkg,
    # and from there the file ../../devel/libusb/buildlink3.mk is visible.

    adjuster = Adjuster(g, 'https://example.org/distfile-1.0.zip', Lines())
    adjuster.makefile_lines.add('# url2pkg-marker')

    adjuster.add_dependency('BUILD_DEPENDS', 'libusb', '>=2019', '../../devel/libusb')

    lines = adjuster.generate_lines()

    assert lines.lines == [
        'BUILDLINK_DEPENDS.libusb+=\tbuild',
        'BUILDLINK_API_DEPENDS.libusb+=\tlibusb>=2019',
        '.include "../../devel/libusb/buildlink3.mk"',
    ]


def test_Adjuster_adjust_cmake(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'CMakeLists.txt').touch()

    adjuster.adjust_cmake()

    assert adjuster.includes == [
        '../../devel/cmake/build.mk'
    ]


def test_Adjuster_adjust_gnu_make(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'Makefile').write_text('ifdef HAVE_STDIO_H')

    adjuster.adjust_gnu_make()

    assert adjuster.tools == {'gmake'}


def test_Adjuster_adjust_configure__none(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path

    adjuster.adjust_configure()

    assert adjuster.build_vars == []


def test_Adjuster_adjust_configure__GNU(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.wrksrc_files.append('configure')
    (tmp_path / 'configure').write_text('# Free Software Foundation\n')

    adjuster.adjust_configure()

    assert str_vars(adjuster.build_vars) == [
        'GNU_CONFIGURE=yes',
    ]


def test_Adjuster_adjust_configure__other(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.wrksrc_files.append('configure')
    (tmp_path / 'configure').write_text('# A generic configure script\n')

    adjuster.adjust_configure()

    assert str_vars(adjuster.build_vars) == [
        'HAS_CONFIGURE=yes',
    ]


def test_Adjuster_adjust_cargo__not_found(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path

    adjuster.adjust_cargo()

    assert adjuster.cargo_crate_depends == []


def test_Adjuster_adjust_cargo__before_0_39(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'Cargo.lock').write_text(dedent('''\
        [[package]]
        name = "aes-ctr"
        version = "0.3.0"
        source = "registry+https://github.com/rust-lang/crates.io-index"
        dependencies = [
         "aes-soft 0.3.3 (registry+https://github.com/rust-lang/crates.io-index)",
         "aesni 0.6.0 (registry+https://github.com/rust-lang/crates.io-index)",
         "ctr 0.3.2 (registry+https://github.com/rust-lang/crates.io-index)",
         "stream-cipher 0.3.2 (registry+https://github.com/rust-lang/crates.io-index)",
        ]
        
        [metadata]
        ...
        "checksum aes-ctr 0.3.0 (registry+https://github.com/rust-lang/crates.io-index)" = "..."
        ...
        '''))

    adjuster.adjust_cargo()

    assert adjuster.cargo_crate_depends == [
        'aes-ctr-0.3.0',
    ]


def test_Adjuster_adjust_cargo__since_0_39(tmp_path: Path):
    """
    https://github.com/rust-lang/cargo/pull/7070/commits/34bca035ae133abe7e62acd0e90698943d471080

    There is no [metadata] section anymore.
    The checksum has been moved directly into the [[package]] section.
    """
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'Cargo.lock').write_text(dedent('''\
        [[package]]
        name = "aes-ctr"
        version = "0.3.0"
        source = "registry+https://github.com/rust-lang/crates.io-index"
        checksum = "d2e5b0458ea3beae0d1d8c0f3946564f8e10f90646cf78c06b4351052058d1ee"
        dependencies = [
         "aes-soft",
         "aesni",
         "ctr",
         "stream-cipher",
        ]
        '''))

    adjuster.adjust_cargo()

    assert adjuster.cargo_crate_depends == [
        'aes-ctr-0.3.0',
    ]


def test_Adjuster_adjust_gconf2():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = [
        'file1.schemas',
        'file2.schemas.in',
        'file6.schemas.in.in.in.in.in.in',  # realistic maximum is 2 times
    ]

    adjuster.adjust_gconf2_schemas()

    assert adjuster.includes == [
        '../../devel/GConf/schemas.mk',
    ]
    assert str_vars(adjuster.extra_vars) == [
        'GCONF_SCHEMAS+=file1.schemas',
        'GCONF_SCHEMAS+=file2.schemas',
        'GCONF_SCHEMAS+=file6.schemas',
    ]


def test_Adjuster_adjust_libtool__ltconfig(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'ltconfig').write_text('')

    adjuster.adjust_libtool()

    assert str_vars(adjuster.build_vars) == ['USE_LIBTOOL=yes']


def test_Adjuster_adjust_libtool__libltdl(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'libltdl').mkdir()

    adjuster.adjust_libtool()

    assert adjuster.includes == [
        '../../devel/libltdl/convenience.mk',
    ]


def test_Adjuster_adjust_meson(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'meson.build').touch()

    adjuster.adjust_meson()

    assert adjuster.includes == ['../../devel/meson/build.mk']


def test_Adjuster_adjust_perl_module_Build_PL(tmp_path: Path):
    g.perl5 = "cat dependencies #"
    g.libdir = '/libdir'
    g.verbose = False
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path
    (tmp_path / 'dependencies').write_text(
        'TOOL_DEPENDS\tp5-Module-Build>=0\n'
        'TOOL_DEPENDS\tp5-Data-Float>=0.008\n'
        'TOOL_DEPENDS\tp5-Test-More>=0\n'
        'TOOL_DEPENDS\tp5-IO-File>=1.03\n'
        'TOOL_DEPENDS\tp5-Module-Build>=0\n'
        'TOOL_DEPENDS\tp5-Crypt-Rijndael>=0\n'
        'DEPENDS\tp5-IO-File>=1.03\n'
        'DEPENDS\tp5-Data-Float>=0.008\n'
        'DEPENDS\tp5-Params-Classify>=0\n'
        'DEPENDS\tp5-Carp>=0\n'
        'DEPENDS\tp5-HTTP-Lite>=2.2\n'
        'DEPENDS\tp5-Crypt-Rijndael>=0\n'
        'DEPENDS\tp5-Errno>=1.00\n'
        'DEPENDS\tp5-Exporter>=0\n'
        'cmd\tlicense\tperl\n'
        'cmd\tlicense_default\t# TODO: perl (from Build.PL)\n'
    )

    adjuster.adjust_perl_module_Build_PL()

    assert str_vars(adjuster.build_vars) == ['PERL5_MODULE_TYPE=Module::Build']
    assert g.err.written() == []
    assert adjuster.tool_depends == [
          'p5-Crypt-Rijndael>=0:../../security/p5-Crypt-Rijndael',
          'p5-Data-Float>=0.008:../../devel/p5-Data-Float',
          '# TODO: p5-IO-File>=1.03',
          '# TODO: p5-Test-More>=0',
    ]
    assert adjuster.depends == [
          'p5-Carp>=0:../../devel/p5-Carp',
          'p5-Crypt-Rijndael>=0:../../security/p5-Crypt-Rijndael',
          'p5-Data-Float>=0.008:../../devel/p5-Data-Float',
          '# TODO: p5-Errno>=1.00',
          '# TODO: p5-Exporter>=0',
          'p5-HTTP-Lite>=2.2:../../www/p5-HTTP-Lite',
          '# TODO: p5-IO-File>=1.03',
          'p5-Params-Classify>=0:../../devel/p5-Params-Classify',
    ]


def test_Adjuster_adjust_perl_module_Makefile_PL(tmp_path: Path):
    g.perl5 = 'echo perl5'
    g.libdir = '/libdir'
    g.verbose = True
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrksrc = tmp_path

    adjuster.adjust_perl_module_Makefile_PL()

    assert str_vars(adjuster.build_vars) == []
    assert g.err.written() == [
        f'url2pkg: reading dependencies: cd \'{tmp_path}\' && env {{}} \'echo perl5 -I/libdir -I. Makefile.PL\'',
        'url2pkg: unknown dependency line: \'perl5 -I/libdir -I. Makefile.PL\''
    ]


def test_Adjuster_adjust_perl_module_homepage():
    adjuster = Adjuster(g, 'https://example.org/Perl-Module-1.0.tar.gz', Lines())
    adjuster.makefile_lines.add_vars(
        Var('DISTNAME', '=', 'Perl-Module-1.0.tar.gz'),
        Var('MASTER_SITES', '=', '${MASTER_SITE_PERL_CPAN:=subdir/}'),
        Var('HOMEPAGE', '=', 'https://example.org/'),
    )

    adjuster.adjust_perl_module_homepage()

    assert adjuster.makefile_lines.get('HOMEPAGE') == 'https://metacpan.org/pod/Perl::Module'


def test_Adjuster_adjust_perl_module__Build_PL(tmp_path: Path):
    g.perl5 = 'echo perl5'
    g.pkgdir = tmp_path  # for removing the PLIST
    adjuster = Adjuster(g, 'https://example.org/Perl-Module-1.0.tar.gz', Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.makefile_lines.add_vars(
        Var('DISTNAME', '=', 'Perl-Module-1.0.tar.gz'),
        Var('MASTER_SITES', '=', '${MASTER_SITE_PERL_CPAN:=subdir/}'),
        Var('HOMEPAGE', '=', 'https://example.org/'),
    )
    adjuster.makefile_lines.add('# url2pkg-marker')
    (tmp_path / 'Build.PL').touch()
    (tmp_path / 'PLIST').touch()

    adjuster.adjust_perl_module()

    assert detab(adjuster.generate_lines()) == [
        'DISTNAME=       Perl-Module-1.0.tar.gz',
        'PKGNAME=        p5-${DISTNAME}',
        'MASTER_SITES=   ${MASTER_SITE_PERL_CPAN:=subdir/}',
        'HOMEPAGE=       https://metacpan.org/pod/Perl::Module',
        '',
        'PERL5_MODULE_TYPE=      Module::Build',
        'PERL5_PACKLIST=         auto/Perl/Module/.packlist',
        '',
        '.include "../../lang/perl5/module.mk"',
    ]
    assert not (tmp_path / 'PLIST').exists()


def test_Adjuster_adjust_perl_module__Makefile_PL_without_PLIST(tmp_path: Path):
    # For code coverage, when PLIST cannot be unlinked.

    g.perl5 = 'echo perl5'
    g.pkgdir = tmp_path
    adjuster = Adjuster(g, 'https://example.org/Mod-1.0.tar.gz', Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.makefile_lines.add_vars(
        Var('DISTNAME', '=', 'Mod-1.0.tar.gz'),
        Var('MASTER_SITES', '=', '${MASTER_SITE_PERL_CPAN:=subdir/}'),
        Var('HOMEPAGE', '=', 'https://example.org/'),
    )
    adjuster.makefile_lines.add('# url2pkg-marker')
    (tmp_path / 'Makefile.PL').touch()

    adjuster.adjust_perl_module()

    assert not (tmp_path / 'PLIST').exists()


def test_Adjuster_adjust_python_module(tmp_path: Path):
    url = 'https://example.org/Mod-1.0.tar.gz'
    g.pythonbin = 'echo python'
    g.pkgdir = tmp_path
    adjuster = Adjuster(g, url, Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.makefile_lines = Generator(url).generate_Makefile()
    (tmp_path / 'setup.py').touch()

    adjuster.adjust_python_module()

    assert detab(adjuster.generate_lines()) == [
        mkcvsid,
        '',
        'DISTNAME=       Mod-1.0',
        'PKGNAME=        ${PYPKGPREFIX}-${DISTNAME}',
        'CATEGORIES=     pkgtools python',
        'MASTER_SITES=   https://example.org/',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '.include "../../lang/python/wheel.mk"',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_Adjuster_adjust_python_module__pyproject_toml(tmp_path: Path):
    url = 'https://example.org/Mod-1.0.tar.gz'
    g.pythonbin = 'echo python'
    g.pkgdir = tmp_path
    adjuster = Adjuster(g, url, Lines())
    adjuster.abs_wrksrc = tmp_path
    adjuster.makefile_lines = Generator(url).generate_Makefile()
    (tmp_path / 'pyproject.toml').touch()

    adjuster.adjust_python_module()

    assert detab(adjuster.generate_lines()) == [
        mkcvsid,
        '',
        'DISTNAME=       Mod-1.0',
        'PKGNAME=        ${PYPKGPREFIX}-${DISTNAME}',
        'CATEGORIES=     pkgtools python',
        'MASTER_SITES=   https://example.org/',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# TODO: Extract dependencies from pyproject.toml',
        '',
        '.include "../../lang/python/wheel.mk"',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_Adjuster_adjust_po__not_found():
    adjuster = Adjuster(g, '', Lines())

    adjuster.adjust_po()

    assert adjuster.build_vars == []


def test_Adjuster_adjust_po__mo_found():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['share/locale/de.mo']

    adjuster.adjust_po()

    assert str_vars(adjuster.build_vars) == ['USE_PKGLOCALEDIR=yes']


def test_Adjuster_adjust_po__po_found():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['po/de.po']

    adjuster.adjust_po()

    assert str_vars(adjuster.build_vars) == ['USE_PKGLOCALEDIR=yes']


def test_Adjuster_adjust_use_languages__none():
    adjuster = Adjuster(g, '', Lines())

    adjuster.adjust_use_languages()

    assert str_vars(adjuster.build_vars) == ['USE_LANGUAGES=# none']


def test_Adjuster_adjust_use_languages__c():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['main.c']

    adjuster.adjust_use_languages()

    assert str_vars(adjuster.build_vars) == []


def test_Adjuster_adjust_use_languages__c_in_subdir():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['subdir/main.c']

    adjuster.adjust_use_languages()

    assert str_vars(adjuster.build_vars) == []


def test_Adjuster_adjust_use_languages__cplusplus_in_subdir():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['subdir/main.cpp']

    adjuster.adjust_use_languages()

    assert str_vars(adjuster.build_vars) == ['USE_LANGUAGES=c++']


def test_Adjuster_adjust_use_languages__cplusplus_and_fortran():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['subdir/main.cpp', 'main.f']

    adjuster.adjust_use_languages()

    assert str_vars(adjuster.build_vars) == ['USE_LANGUAGES=c++ fortran']


def test_Adjuster_adjust_pkg_config__none():
    adjuster = Adjuster(g, '', Lines())

    adjuster.adjust_pkg_config()

    assert str_vars(adjuster.build_vars) == []
    assert str_vars(adjuster.extra_vars) == []


def test_Adjuster_adjust_pkg_config__pc_in():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['library.pc.in']

    adjuster.adjust_pkg_config()

    assert str_vars(adjuster.build_vars) == ['USE_TOOLS+=pkg-config']
    assert str_vars(adjuster.extra_vars) == ['PKGCONFIG_OVERRIDE+=library.pc.in']


def test_Adjuster_adjust_pkg_config__uninstalled_pc_in():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = ['library-uninstalled.pc.in']

    adjuster.adjust_pkg_config()

    assert str_vars(adjuster.build_vars) == []
    assert str_vars(adjuster.extra_vars) == []


def test_Adjuster_adjust_pkg_config__both():
    adjuster = Adjuster(g, '', Lines())
    adjuster.wrksrc_files = [
        'library.pc.in',
        'library-uninstalled.pc.in',
    ]

    adjuster.adjust_pkg_config()

    assert str_vars(adjuster.build_vars) == ['USE_TOOLS+=pkg-config']
    assert str_vars(adjuster.extra_vars) == ['PKGCONFIG_OVERRIDE+=library.pc.in']


def test_Adjuster_generate_lines():
    url = 'https://dummy.example.org/package-1.0.tar.gz'
    adjuster = Adjuster(g, url, Lines())
    adjuster.makefile_lines = Generator(url).generate_Makefile()
    assert adjuster.makefile_lines.set('HOMEPAGE', 'https://example.org/')
    assert adjuster.makefile_lines.set('#LICENSE', 'BSD # TODO: too unspecific')
    adjuster.depends.append('dependency>=0:../../category/dependency')
    adjuster.todos.append('Run pkglint')
    adjuster.tools.add('gmake')

    lines = adjuster.generate_lines()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       package-1.0',
        'CATEGORIES=     pkgtools',
        'MASTER_SITES=   https://dummy.example.org/',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://example.org/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       BSD # TODO: too unspecific',
        '',
        '# TODO: Run pkglint',
        '',
        'DEPENDS+=       dependency>=0:../../category/dependency',
        '',
        'USE_TOOLS+=     gmake',
        '',
        '.include "../../mk/bsd.pkg.mk"',
    ]


def test_Adjuster_determine_wrksrc__no_files(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrkdir = tmp_path

    adjuster.determine_wrksrc()

    assert adjuster.abs_wrksrc == adjuster.abs_wrkdir


def test_Adjuster_determine_wrksrc__single_dir(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrkdir = tmp_path
    (tmp_path / 'subdir').mkdir()

    adjuster.determine_wrksrc()

    assert adjuster.abs_wrksrc == adjuster.abs_wrkdir / 'subdir'


def test_Adjuster_determine_wrksrc__distname_dir(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrkdir = tmp_path
    adjuster.makefile_lines.add_vars(Var('DISTNAME', '=', 'distname-1.0'))
    (tmp_path / 'distname-1.0').mkdir()

    adjuster.determine_wrksrc()

    assert adjuster.abs_wrksrc == adjuster.abs_wrkdir / 'distname-1.0'
    assert str_vars(adjuster.build_vars) == []


def test_Adjuster_determine_wrksrc__several_dirs(tmp_path: Path):
    adjuster = Adjuster(g, '', Lines())
    adjuster.abs_wrkdir = tmp_path
    (tmp_path / 'subdir1').mkdir()
    (tmp_path / 'subdir2').mkdir()

    adjuster.determine_wrksrc()

    assert adjuster.abs_wrksrc == adjuster.abs_wrkdir
    assert str_vars(adjuster.build_vars) == [
        'WRKSRC=${WRKDIR} # TODO: one of subdir1 subdir2, or leave it as-is',
    ]


def test_Adjuster_adjust__empty_wrkdir(tmp_path: Path):
    g.pkgdir = tmp_path
    g.show_var = lambda varname: {'WRKDIR': str(tmp_path)}[varname]
    adjuster = Adjuster(g, 'https://example.org/distfile-1.0.zip', Lines())
    (tmp_path / 'Makefile').write_text('# url2pkg-marker\n')

    adjuster.adjust()

    assert detab(adjuster.generate_lines()) == [
        'WRKSRC=         ${WRKDIR}',
        'USE_LANGUAGES=  # none',
        '',
    ]


def test_Adjuster_adjust__files_in_wrksrc(tmp_path: Path):
    wrkdir = tmp_path / 'work'
    wrkdir.mkdir()
    (wrkdir / '.hidden').touch()
    (wrkdir / 'file').touch()
    (wrkdir / 'dir').mkdir()
    (wrkdir / 'dir' / '.hidden-dir').mkdir()
    (wrkdir / 'dir' / 'subdir').mkdir()
    (wrkdir / 'dir' / 'subdir' / '.hidden').touch()
    (wrkdir / 'dir' / 'subdir' / 'file').touch()
    (wrkdir / 'dir2').mkdir()  # to make WRKSRC = WRKDIR
    g.show_var = lambda varname: {'WRKDIR': str(wrkdir)}[varname]
    g.pkgdir = tmp_path
    (tmp_path / 'Makefile').write_text('# url2pkg-marker\n')
    adjuster = Adjuster(g, 'https://example.org/distfile-1.0.zip', Lines())

    adjuster.adjust()

    assert adjuster.wrksrc_dirs == [
        'dir',
        'dir/.hidden-dir',
        'dir/subdir',
        'dir2',
    ]
    assert adjuster.wrksrc_files == [
        'dir/subdir/.hidden',
        'dir/subdir/file',
        'file',
    ]


def test_Adjuster_adjust_lines_python_module(tmp_path: Path):
    url = 'https://github.com/espressif/esptool/archive/v2.7.tar.gz'
    g.pkgdir = tmp_path
    g.make = 'true'  # the shell command
    g.verbose = True
    initial_lines = Generator(url).generate_Makefile()
    initial_lines.append('CATEGORIES', 'python')
    adjuster = Adjuster(g, url, initial_lines)
    adjuster.makefile_lines = Lines(*initial_lines.lines)
    (g.pkgdir / 'Makefile').touch()

    assert detab(adjuster.makefile_lines) == [
        mkcvsid,
        '',
        'DISTNAME=       v2.7',
        'PKGNAME=        ${GITHUB_PROJECT}-${DISTNAME:S,^v,,}',
        'CATEGORIES=     pkgtools python',
        'MASTER_SITES=   ${MASTER_SITE_GITHUB:=espressif/}',
        'GITHUB_PROJECT= esptool',
        'GITHUB_TAG=     v2.7',
        'DIST_SUBDIR=    ${GITHUB_PROJECT}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/espressif/esptool/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]

    lines = adjuster.generate_lines()

    assert detab(lines) == [
        mkcvsid,
        '',
        'DISTNAME=       esptool-2.7',
        'PKGNAME=        ${PYPKGPREFIX}-${DISTNAME}',
        'CATEGORIES=     pkgtools python',
        'MASTER_SITES=   ${MASTER_SITE_PYPI:=e/esptool/}',
        '',
        'MAINTAINER=     INSERT_YOUR_MAIL_ADDRESS_HERE # or use pkgsrc-users@NetBSD.org',
        'HOMEPAGE=       https://github.com/espressif/esptool/',
        'COMMENT=        TODO: Short description of the package',
        '#LICENSE=       # TODO: (see mk/license.mk)',
        '',
        '# url2pkg-marker (please do not remove this line.)',
        '.include "../../mk/bsd.pkg.mk"',
    ]

    try_mk = tmp_path / 'try-pypi.mk'
    assert g.err.written() == [
        f"url2pkg: running ['true', '-f', '{try_mk}', 'distinfo'] to try PyPI",
    ]


def test_Adjuster_adjust_lines_python_module__edited():
    # When the package developer has edited the Makefile, it's unclear
    # what has changed. To not damage anything, let the package
    # developer migrate manually.

    url = 'https://github.com/espressif/esptool/archive/v2.7.tar.gz'
    initial_lines = Generator(url).generate_Makefile()
    initial_lines.append('CATEGORIES', 'python')
    adjuster = Adjuster(g, url, initial_lines)
    adjuster.makefile_lines = Lines(*initial_lines.lines)
    initial_lines.add('')  # to make the lines different

    lines = adjuster.generate_lines()

    assert lines.get('GITHUB_PROJECT') == 'esptool'

    adjuster.adjust_lines_python_module(lines)

    assert lines.get('GITHUB_PROJECT') == 'esptool'
    assert lines.index('TODO: Migrate MASTER_SITES to MASTER_SITE_PYPI') == 14


def test_main__wrong_dir(tmp_path):
    os.chdir(tmp_path)
    error = r'url2pkg: must be run from a package or category directory'

    with pytest.raises(SystemExit, match=error):
        main(['url2pkg', 'https://example.org/distfile-1.0.tar.gz'], g)


def test_main__unknown_option():
    with pytest.raises(SystemExit, match=r'usage:'):
        main(['url2pkg', '--unknown'], g)


def test_main__verbose():
    with pytest.raises(SystemExit, match=r'url2pkg: invalid URL: broken URL'):
        main(['url2pkg', '--verbose', 'broken URL'], g)


def test_main__valid_URL():
    import shutil

    g.make = os.getenv('MAKE') or sys.exit('MAKE must be set')
    g.pkgdir = g.pkgsrcdir / 'pkgtools' / 'url2pkg-test-main'
    g.pkgdir.is_dir() and shutil.rmtree(g.pkgdir)
    try:
        g.pkgdir.mkdir()
    except OSError:
        return  # skip if the directory is not writable
    os.chdir(g.pkgdir)

    main(['url2pkg', '-v', 'https://github.com/rillig/checkperms/archive/v1.12.tar.gz'], g)

    assert g.out.written() == [
        '',
        'Remember to run pkglint when you\'re done.',
        'See ../../doc/pkgsrc.txt to get some help.',
        '',
    ]
    assert g.err.written() == [
        f'url2pkg: running bmake (\'clean\', \'distinfo\', \'extract\') in \'{g.pkgdir}\'',
        'url2pkg: Adjusting the Makefile',
        f'url2pkg: running bmake (\'clean\',) in \'{g.pkgdir}\'',
        f'url2pkg: running bmake (\'extract\',) in \'{g.pkgdir}\'',
    ]

    g.verbose = False
    g.bmake('clean')  # remove the work directory

    expected_files = ['DESCR', 'Makefile', 'PLIST', 'distinfo']
    assert sorted([f.name for f in g.pkgdir.glob("*")]) == expected_files

    shutil.rmtree(g.pkgdir)
