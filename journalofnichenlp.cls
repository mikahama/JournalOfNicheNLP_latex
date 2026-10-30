%% Journal of Niche NLP -- manuscript class
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{journalofnichenlp}[2026/10/27 Journal of Niche NLP manuscript class]

\newif\ifjnlpreview
\jnlpreviewfalse
\DeclareOption{review}{\jnlpreviewtrue}
\DeclareOption{camera}{\jnlpreviewfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

\RequirePackage[a4paper,margin=30mm,headheight=14pt]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
% TeX Gyre Termes is a Times-like publication face with broad Linux support.
\RequirePackage{tgtermes}
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{caption}
\RequirePackage{xcolor}
\RequirePackage{eso-pic}
\RequirePackage[round,authoryear]{natbib}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{fancyhdr}

\definecolor{jnllight}{gray}{0.94}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.55em}
\setlength{\emergencystretch}{2em}
\setlength{\leftmargini}{1.7em}
\renewcommand{\arraystretch}{1.15}
\captionsetup{font=small,labelfont=bf,labelsep=period}
\renewcommand{\refname}{References}
\renewcommand{\bibsection}{\section*{\refname}}
\setlength{\bibhang}{1.5em}
\setlength{\bibsep}{0.45em}
\bibliographystyle{apalike}

%% Number and style all four conventional section levels.
\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{4}
\renewcommand\thesection{\arabic{section}}
\renewcommand\thesubsection{\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection{\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph{\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph{\theparagraph.\arabic{subparagraph}}
\renewcommand\section{\@startsection{section}{1}{\z@}%
  {-2.4ex \@plus -0.8ex \@minus -.2ex}{1.0ex \@plus .2ex}%
  {\normalfont\Large\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-2.0ex \@plus -.7ex \@minus -.2ex}{0.7ex \@plus .15ex}%
  {\normalfont\large\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-1.7ex \@plus -.5ex \@minus -.2ex}{0.45ex \@plus .1ex}%
  {\normalfont\normalsize\bfseries}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
  {1.4ex \@plus .4ex \@minus .1ex}{-0.8em}%
  {\normalfont\normalsize\bfseries\itshape}}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize\itshape Journal of Niche NLP}
\renewcommand{\headrulewidth}{0.3pt}

%% Metadata fields. Set these in the manuscript preamble.
\newcommand{\jnl@authors}{}
\newcommand{\jnl@affiliations}{}
\newcommand{\jnl@correspondence}{}
\newcommand{\jnl@year}{\number\year}
% Match the non-long \@empty used by the citation fallback's \ifx test.
\newcommand*{\jnl@citationauthors}{}
\newcommand{\jnl@shorttitle}{}
\newcommand{\authors}[1]{\gdef\jnl@authors{#1}}
\newcommand{\affiliations}[1]{\gdef\jnl@affiliations{#1}}
\newcommand{\correspondence}[1]{\gdef\jnl@correspondence{#1}}
\newcommand{\publicationyear}[1]{\gdef\jnl@year{#1}}
\newcommand{\citationauthors}[1]{\gdef\jnl@citationauthors{#1}}
\newcommand{\shorttitle}[1]{\gdef\jnl@shorttitle{#1}}
% Render the displayed authors inline only for the citation fallback. Keep this
% local: the title block has its own separator and explicit overrides are verbatim.
\newcommand{\jnl@citationauthorfallback}{%
  \begingroup
    \def\and{\unskip\space and\space\ignorespaces}%
    \jnl@authors
  \endgroup}
\newcommand{\jnl@citation}{\ifx\jnl@citationauthors\@empty\jnl@citationauthorfallback\else\jnl@citationauthors\fi\ (\jnl@year). \@title. \textit{Journal of Niche NLP}.}

\newcommand{\jnl@placefirstpagelogo}{%
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{\raisebox{-20mm}[0pt][0pt]{\hspace*{20mm}%
      \IfFileExists{logo.png}{\includegraphics[width=28mm]{logo.png}}{%
        \sffamily\bfseries\small JOURNAL OF NICHE NLP}%
      \hspace{5mm}\raisebox{1mm}{\parbox[c]{70mm}{\small
        \textbf{Journal of Niche NLP}\\[-.15em]
        \href{https://nichenlp.com}{https://nichenlp.com}}}}}}}
\newcommand{\jnl@placecitationfooter}{%
  \AddToShipoutPictureFG*{%
    \AtPageLowerLeft{\raisebox{14mm}[0pt][0pt]{\hspace*{20mm}%
      \parbox[b]{\dimexpr\paperwidth-40mm\relax}{\small
        \begin{minipage}[b]{.76\linewidth}
          \textbf{Citation:} \jnl@citation
        \end{minipage}\hfill
        \IfFileExists{by.png}{\includegraphics[height=8mm]{by.png}}{}%
      }}}}}
\newcommand{\jnl@makefirstpage}{%
  \thispagestyle{empty}
  \jnl@placefirstpagelogo
  \ifjnlpreview\else\jnl@placecitationfooter\fi
  \vspace*{1.6em}
  \begin{center}
    {\LARGE\bfseries\@title\par}
    \vspace{1.25em}
    \ifjnlpreview
      {\large\itshape Anonymous submission\par}
      \vspace{.5em}
      {\normalsize Author information withheld for double-anonymous review.\par}
  \else
    % The standard \and is a tabular control token after \title; make it a
    % simple, safe author separator in this custom title block instead.
    \begingroup
    \def\and{\\[.2em]}%
      {\large \jnl@authors\par}
      \vspace{.55em}
      {\normalsize\itshape \jnl@affiliations\par}
      \ifx\jnl@correspondence\@empty\else
        \vspace{.4em}{\small Correspondence: \jnl@correspondence\par}
      \fi
    \endgroup
    \fi
  \end{center}
  \vspace{1.4em}
  \ifjnlpreview
    \noindent\colorbox{jnllight}{\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\small\textbf{Review copy.} Identifying metadata and citation instructions are suppressed.}}
  \fi
  \vspace{1.7em}
}
\renewcommand{\maketitle}{\jnl@makefirstpage}

%% natbib supplies \cite, \citet, \citep, \citeauthor, \citeyear and \citealt.
\endinput

