%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Undergraduate Thesis, Joomy Korkut   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup {{{

  % Imports and Styling {{{
  \RequirePackage{amsmath}
  \documentclass[11pt]{article}
  \bibliographystyle{jfp}
  \def\textmu{}

  %include agda.fmt
  \usepackage{fullpage}
  \usepackage{textgreek} % not reproducible without textgreek
  \usepackage{bussproofs}
  \usepackage{color}
  \usepackage{proof}
  \usepackage{enumerate}
  \usepackage{url}
  \usepackage{authordate1-4}
  % }}}

  % Editorial commands {{{
  \newcommand{\Red}[1]{{\color{red} #1}}
  \newcommand{\ToDo}[1]{{\color{blue} ToDo: #1}}
  \newcommand{\tocite}[0]{{\color{red} [cite]}\xspace}
  \newcommand{\citey}[1]{\shortcite{#1}}
  %  }}}

  % Math and code commands {{{
  \newcommand{\figrule}{\begin{center}\hrule\end{center}}
  \newcommand{\set}[1]{\left\{#1\right\}}
  % }}}

  % Unicode chars not supported by lhs2TeX {{{
  \DeclareUnicodeCharacter{738}{$^\text{s}$}
  \DeclareUnicodeCharacter{7503}{$^\text{k}$}
  \DeclareUnicodeCharacter{739}{$^\text{x}$}
  \DeclareUnicodeCharacter{8709}{$\varnothing$} % overwriting \emptyset
  % }}}

% }}}

% Title, Abstract, TOC {{{

\title{Verified Compilation of Modal Logic \\
       Based Functional Language ML5 to JavaScript}
\author{Joomy Korkut\\ Wesleyan University}
\date{}

\begin{document}

\maketitle

\begin{abstract}
Murphy's dissertation argues that a language designed based on modal type
systems can provide elegant abstractions to organize local resources on
different computers. \citey{tom7} In this thesis, I bound his argument to
simple web programming and claim that a modal logic based language is
suitable to write readable and correct web applications. To do this, I defined
and implemented a minimal language called MinML5 in Agda and then wrote a
compiler for it to JavaScript. The compiler is a series of type directed
translations, hence we have fully formalized languages at every step.
\end{abstract}

\tableofcontents

% }}}

% Introduction {{{

\section{Introduction}



% }}}

% End {{{
\bibliography{paper}
\end{document}
% }}}
