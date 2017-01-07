%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Undergraduate Thesis, Joomy Korkut   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup {{{

  % Imports and Styling {{{
  \RequirePackage{amsmath}
  \documentclass[11pt,draft]{westhesis}
  \def\textmu{}

  %include agda.fmt
  \usepackage{natbib}
  \usepackage{fullpage}
  \usepackage{textgreek} % not reproducible without textgreek
  \usepackage{bussproofs}
  \usepackage{epigraph}
  \usepackage{color}
  \usepackage{enumerate}
  \usepackage{url}
  \usepackage{xcolor}
  \RequirePackage{graphicx}
  \usepackage{hyperref}
  \hypersetup{backref = true, colorlinks = true, allcolors = {blue}}
  % }}}

  % Editorial commands {{{
  \newcommand{\Red}[1]{{\color{red} #1}}
  \newcommand{\nop}[0]{} % used to reconcile vim folds and latex curly braces
  \newcommand{\ToDo}[1]{{\color{blue} ToDo: #1}}
  \newcommand{\tocite}[0]{{\color{red} [cite]}\xspace}
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

\title{Verified Compilation of ML5 to JavaScript}
\author{Joomy Korkut}
\advisor{Daniel R. Licata}
\department{Mathematics and Computer Science}
\submitdate{April 2017}
\copyrightyear{2017}

\makeindex
\begin{document}

\begin{dedication}
\epigraph{Forgotten were the elementary rules of logic, that extraordinary
  claims require extraordinary evidence and that what can be asserted without
  evidence can also be dismissed without evidence.}{\textit{Christopher
  Hitchens}}
\end{dedication}

\begin{acknowledgements}

\end{acknowledgements}

\begin{abstract}
  Curry-Howard correspondence describes a language that corresponds to
  propositional logic.  If modal logic is an extension of propositional logic,
  then what language corresponds to modal logic? If there is one, then what is
  it good for?  Murphy's dissertation \cite{tom7} argues that a programming
  language designed basezd on modal type systems can provide elegant
  abstractions to organize local resources on different computers.  In this
  thesis, I limit his argument to simple web programming and claim that a modal
  logic based language provides a way to write readable code and correct web
  applications.  To do this, I defined and implemented a minimal language
  called MinML5 in Agda and then wrote a compiler to JavaScript for it. The
  compiler is a series of type directed translations through fully formalized
  languages, the last one of which is a very limited subset of JavaScript.
\end{abstract}

\frontmatter
\maketitle
\makededication
\makeack
\makeabstract
\tableofcontents
\mainmatter
% }}}

% Introduction {{{
\section{Introduction}

% }}}

% Background {{{

\section{Background}

  % Background intro {{{
  In non-modal propositional logic, certain kinds of notations for inference
  rules obscure the distinction between a proposition and a judgment.
  Consider the following conjunction intro rule:
  \begin{prooftree}
    \AxiomC{$A$}
    \AxiomC{$B$}
    \BinaryInfC{$A \land B$}
  \end{prooftree}
  Now are $A$, $B$ and $A \land B$ in this rule propositions or judgments? The
  correct answer is judgments, because what this notation means is the
  following sentence: ``$A \land B$ is true, if $A$ is true and $B$ is true.''
  The ambiguity about the notions of proposition and judgment can be removed by
  adopting a new notation for judgments; we would now write ``$A$ true'' or
  ``$\vdash A$'' for a judgment, instead of just ``$A$''.

  This notation and the inference rule above do not cover the case in which a
  proposition depends on other propositions, i.e. when we want to say ``$A$
  follows from $\Gamma$''. We accept ``$\Gamma \vdash A$'' as the default
  notation such a judgment.  If we apply these changes to our inference rules,
  we would get
  \begin{prooftree}
    \AxiomC{$\Gamma \vdash A$}
    \AxiomC{$\Gamma \vdash B$}
    \BinaryInfC{$\Gamma \vdash A \land B$}
  \end{prooftree}
  The distinction between a proposition and judgment does not come up often
  when we think about non-modal logic, so this distinction might seem like a
  nuisance. However it will be our gateway to understanding modal logic.
  \cite{judgmental}

  I think it should be clarified if an incorrect or unproved judgment is still
  a judgment. In other words, is the word judgment a way to express truth or is
  it just a form? In this regard, I will follow Martin-Löf's fourfold
  terminology \cite{pml}: judgment and proposition are ``stripped of [their]
  epistemic force'', they describe the state that those concepts have before
  ``[they have] been proved or become known''. On the other hand, the terms
  ``evident judgment'' and ``true proposition'' imply that there is a proof.
  % }}}

  % Modal Logic {{{
  \subsection{Modal logic}

  % }}}

  % Hybrid logic {{{
  \subsection{Hybrid logic}

  % }}}

% }}}

% Type-directed translation {{{

\section{Type-directed translation}

  % MinML5 {{{
  \subsection{MinML5}
  In the previous section we presented a propositional modal logic, and the
  next step is to define the proof terms that correspond to the logic we
  defined.

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

  % Monomorphization {{{
  \subsection{Monomorphization}

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
\bibliographystyle{abbrv}
\bibliography{paper}
\printindex
\backmatter
\end{document}
% }}}
