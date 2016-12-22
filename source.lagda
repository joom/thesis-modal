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
  \usepackage{hyperref}
  \usepackage{authordate1-4}
  \usepackage{xcolor}
  \hypersetup{colorlinks = true, allcolors = {blue}}
  \RequirePackage{graphicx}
  % }}}

  % Editorial commands {{{
  \newcommand{\Red}[1]{{\color{red} #1}}
  \newcommand{\nop}[0]{} % used to reconcile vim folds and latex curly braces
  \newcommand{\ToDo}[1]{{\color{blue} ToDo: #1}}
  \newcommand{\tocite}[0]{{\color{red} [cite]}\xspace}
  \newcommand{\citey}[1]{\shortcite{#1}}
  %  }}}

  % Math and code commands {{{
  \newcommand{\figrule}{\begin{center}\hrule\end{center}}
  \newcommand{\set}[1]{\left\{#1\right\}}
  \DeclareRobustCommand{\shamrock}{\raisebox{-.035em}{\includegraphics[width=.75em, height=.75em]{symbols/command}}\nop}
  \DeclareRobustCommand{\col}{\raisebox{-.035em}{\includegraphics[width=.30em, height=.75em]{symbols/colon}}\nop}
  % }}}

  % Unicode chars not supported by lhs2TeX {{{
  \DeclareUnicodeCharacter{738}{$^\text{s}$}
  \DeclareUnicodeCharacter{7503}{$^\text{k}$}
  \DeclareUnicodeCharacter{739}{$^\text{x}$}
  \DeclareUnicodeCharacter{8709}{$\varnothing$} % overwriting \emptyset
  \DeclareUnicodeCharacter{8984}{$\shamrock$}
  \DeclareUnicodeCharacter{10626}{$\col$}
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
  Curry-Howard correspondence describes a language that corresponds to
  propositional logic.  If modal logic is an extension of propositional logic,
  then what language corresponds to modal logic? If there is one, then what is
  it good for?  Murphy's dissertation \citey{tom7} argues that a programming
  language designed based on modal type systems can provide elegant
  abstractions to organize local resources on different computers.  In this
  thesis, I limit his argument to simple web programming and claim that a modal
  logic based language provides a way to write readable code and correct web
  applications.  To do this, I defined and implemented a minimal language
  called MinML5 in Agda and then wrote a compiler to JavaScript for it. The
  compiler is a series of type directed translations through fully formalized
  languages, the last one of which is a very limited subset of JavaScript.
\end{abstract}

\tableofcontents

% }}}

% Introduction {{{

\section{Introduction}

% }}}

% Background {{{

\section{Background}

  % Modal Logic {{{
  \subsection{Modal logic}

  % }}}

  % Lambda 5 {{{
  \subsection{Lambda 5}
  In the previous section we presented a propositional modal logic, and the
  next step is to define the proof terms that correspond to the logic we
  defined.

  % }}}

% }}}

% Type-directed translation {{{

\section{Type-directed translation}

  % MinML5 {{{
  \subsection{MinML5}

  % }}}

  % CPS {{{
  \subsection{CPS}

  \subsubsection{Conversion from MinML5 to CPS}
  % }}}

  % Closure conversion {{{
  \subsection{Closure conversion}

  \subsubsection{Conversion from CPS to the closure conversion language}
  % }}}

  % Lambda lifting {{{
  \subsection{Lambda lifting}

  % }}}

% }}}

% Formalization of JavaScript {{{

\section{Formalization of JavaScript}


% }}}

% Conversion to JavaScript {{{

\section{Conversion to JavaScript}


% }}}

% Conclusion {{{

\section{Conclusion}


% }}}

% End {{{
\bibliography{paper}
\end{document}
% }}}
