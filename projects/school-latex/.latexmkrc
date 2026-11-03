# Shared project settings. Keep this file next to the ROOT .tex file.
# Set the project default below. LATEX_ENGINE is an optional CLI/CI override.
# Allowed: uplatex, platex, lualatex, pdflatex, xelatex
my $engine = $ENV{'LATEX_ENGINE'} || 'uplatex';

$max_repeat = 5;
$recorder = 1;
$out_dir = 'export';

# SyncTeX, readable diagnostics and a prompt-free build for every engine.
my $options = '-synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error';
$biber = 'biber %O %S';
$bibtex = 'bibtex %O %S';
$makeindex = 'makeindex %O -o %D %S';

if ($engine eq 'uplatex') {
    $pdf_mode = 3;
    $latex = "uplatex %O $options -kanji=utf8 %S";
    $dvipdf = 'dvipdfmx %O -o %D %S';
    $bibtex = 'upbibtex %O %S';
    $makeindex = 'upmendex %O -o %D %S';
} elsif ($engine eq 'platex') {
    $pdf_mode = 3;
    $latex = "platex %O $options -kanji=utf8 %S";
    $dvipdf = 'dvipdfmx %O -o %D %S';
    $bibtex = 'pbibtex %O %S';
    $makeindex = 'mendex %O -o %D %S';
} elsif ($engine eq 'lualatex') {
    $pdf_mode = 4;
    $lualatex = "lualatex %O $options %S";
} elsif ($engine eq 'pdflatex') {
    $pdf_mode = 1;
    $pdflatex = "pdflatex %O $options %S";
} elsif ($engine eq 'xelatex') {
    $pdf_mode = 5;
    $xelatex = "xelatex %O $options %S";
} else {
    die "Unsupported TeX engine '$engine' in .latexmkrc\n";
}

# Add project-specific custom dependencies (e.g. glossaries) here if needed.
# Shell escape is deliberately not enabled globally.
