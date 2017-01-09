%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Undergraduate Thesis, Joomy Korkut   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup {{{

  % Imports and Styling {{{
  \RequirePackage{amsmath}
  \documentclass[11pt]{westhesis} % add "final" flag when finished
  \def\textmu{}

  %include agda.fmt
  \usepackage{natbib, fullpage, textgreek, bussproofs, epigraph, color, float,
              enumerate, url, xcolor, graphicx, hyperref}
  \hypersetup{pdftex, backref = true, colorlinks = true, allcolors = {blue}}
  \setcounter{tocdepth}{4}
  \setcounter{secnumdepth}{4}
  % }}}

  % Editorial commands {{{
  \newcommand{\Red}[1]{{\color{red} #1}}
  \newcommand{\nop}[0]{} % used to reconcile vim folds and latex curly braces
  \newcommand{\ToDo}[1]{{\color{blue} ToDo: #1}}
  \newcommand{\tocite}[1]{{\color{red} [cite #1]}\xspace}
  %  }}}

  % Math and code commands {{{
  \newcommand{\figrule}{\begin{center}\hrule\end{center}}
  \newcommand{\set}[1]{\left\{#1\right\}}
  \DeclareRobustCommand{\shamrock}{\raisebox{-.035em}{\includegraphics[width=.75em, height=.75em]{symbols/command}}\nop}
  \DeclareRobustCommand{\col}{\raisebox{-.035em}{\includegraphics[width=.30em, height=.75em]{symbols/colon}}\nop}
  \newcommand{\conc}[2]{#1 \text{<#2>}}
  \newcommand{\val}[2]{#1 \sym #2}
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
\epigraph{``Forgotten were the elementary rules of logic, that extraordinary
  claims require extraordinary evidence and that what can be asserted without
  evidence can also be dismissed without evidence.''}{\textit{Christopher
  Hitchens}}
\end{dedication}

\begin{acknowledgements}

\end{acknowledgements}

\begin{abstract}
  Curry-Howard correspondence describes a language that corresponds to
  propositional logic.  If modal logic is an extension of propositional logic,
  then what language corresponds to modal logic? If there is one, then what is
  it good for?  Murphy's dissertation\cite{tom7} argues that a programming
  language designed based on modal type systems can provide elegant
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
\phantomsection
\addcontentsline{toc}{section}{Abstract}
\makeabstract
\phantomsection
\addcontentsline{toc}{section}{Table of Contents}
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
  proposition depends on other propositions, i.e.\ when we want to say ``$A$
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
  nuisance. However it will be our gateway to understanding our modal logic.
  \cite{judgmental}

  I think it should be clarified if an incorrect or unproved judgment is still
  a judgment. In other words, is the word judgment a way to express truth or is
  it just a form? In this regard, I will follow Martin-Löf's fourfold
  terminology\cite{pml}: judgment and proposition are ``stripped of [their]
  epistemic force'', they describe the state that those concepts have before
  ``[they have] been proved or become known''. On the other hand, the terms
  ``evident judgment'' and ``true proposition'' imply that there is a proof.
  % }}}

  % Modal Logic {{{
  \subsection{Modal logic}

  Modal logic is a broad field that includes various kinds of logic that deal
  with relational structures that have different perspectives of truth.
  \cite{blackburn}\cite{tom7} For our purposes, we only want to examine
  intuitionistic modal logic with explicit worlds.

  We call these perspectives of truth, ``possible worlds''. Each world holds a
  possibly different set of truths. It is possible for a proposition to be true
  in one world and false in another.

  To illustrate the concept, let's think of a prison that have cells, and each
  correspond to a world in our modal logic.
  Suppose in each cell, there is a person who is locked inside.
  Alice is in a cell with a window, while Bob is in a windowless one.
  Alice can look outside and learn that it is sunny, however Bob would
  not be able to do that. In Alice's room you have proof of the nice weather,
  but in Bob's room you do not.

  Let's express this in modal logic. Let $A$ be the proposition that says it is
  sunny, and $w$ and $w'$ be the worlds of Alice and Bob respectively.
  We cannot simply say ``$A$ true'', because we did not specify in which
  cell that is true. We should say ``$A$ is true in Alice's world'',
  for which we will use the notation ``\conc{$A$}{w}''.

  Alice, Bob and others in different cells, have a warden, whose name is Walter.
  Walter provides communication among everyone. Alice can take a photo of
  outside and send it in an envelope to Bob through Walter. Now Bob also has a
  proof that it is sunny, and he can use it later.

  From a modal logic perspective, it matters to regulate who can send envelopes
  to whom. If we call our set of prisoners, i.e.\ worlds, $W$, then this
  regulation is achieved by a relation $R \subseteq W \times W$.

  The pair of those, $\mathfrak{F} = (W,R)$ is called a frame.
  The properties of the relation $R$ defines the kind of logic we have.
  The logic with the relation that is reflexive, transitive
  and symmetric, i.e.\ an equivalence relation, is called
  \textbf{IS5}.\cite{lecture15-pf}
  For our purposes we will deal with the case that $R$ is a full relation
  $R = W \times W$, in other words every world will be accessible from any
  other.  We call this relation \textbf{IS$5^\cup$}.\cite{tom7}

  In \autoref{fig:is5cup}, we state the axioms and inference rules of
  IS$5^\cup$ for the connectives that are familiar from non-modal propositional
  logic, namely $\top, \bot, \land, \lor$ and $\supset$ (reads ``implies'',
  $\Rightarrow$ is another notation for it).

  \begin{figure}[ht]
    \caption{Axioms and inference rules of IS$5^\cup$.}
    \label{fig:is5cup}
    \begin{center}
      \AxiomC{}
      \RightLabel{hyp} % or intro 1
      \UnaryInfC{$\Gamma,\conc{A}{w} \vdash \conc{A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{}
      \RightLabel{$\top$} % top
      \UnaryInfC{$\Gamma \vdash \conc{\top}{w}$}
      \DisplayProof
      \hskip 1.5em
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A}{w}$}
      \AxiomC{$\Gamma \vdash \conc{A}{w}$}
      \RightLabel{$\land_i$} % and intro
      \BinaryInfC{$\Gamma \vdash \conc{A \land B}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{A \land B}{w}$}
      \RightLabel{$\land_{e_1}$} % and elim 1
      \UnaryInfC{$\Gamma \vdash \conc{A}{w} $}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{A \land B}{w}$}
      \RightLabel{$\land_{e_2}$} % and elim 2
      \UnaryInfC{$\Gamma \vdash \conc{B}{w} $}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A}{w}$}
      \RightLabel{$\lor_{i_1}$} % or intro 1
      \UnaryInfC{$\Gamma \vdash \conc{A \lor B}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{B}{w}$}
      \RightLabel{$\lor_{i_2}$} % or intro 2
      \UnaryInfC{$\Gamma \vdash \conc{A \lor B}{w}$}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A \lor B}{w'}$}
      \AxiomC{$\Gamma,\conc{A}{w'} \vdash \conc{C}{w}$}
      \AxiomC{$\Gamma,\conc{B}{w'} \vdash \conc{C}{w}$}
      \RightLabel{$\lor_e$} % or elim
      \TrinaryInfC{$\Gamma \vdash \conc{C}{w}$}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma, \conc{A}{w} \vdash \conc{B}{w}$}
      \RightLabel{$\supset_i$} % implies intro
      \UnaryInfC{$\Gamma \vdash \conc{A \supset B}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{A \supset B}{w}$}
      \AxiomC{$\Gamma \vdash \conc{A}{w}$}
      \RightLabel{$\supset_e$} % implies elim
      \BinaryInfC{$\Gamma \vdash \conc{B}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

  This is a good start, but if we want to make more general claims about
  different worlds, these connectives do not suffice. Therefore we introduce
  the $\Box$ (reads ``box'') and $\Diamond$ (reads ``diamond'') as new modal
  connectives. $\Box A$ means $A$ is true for all worlds, and $\Diamond A$
  means that $A$ is true for some world. The inference rules for $\Box$ and
  $\Diamond$ are in \autoref{fig:is5cupBoxDiamond}.
  Notice that we are using $w$ and $w'$ for concrete world variables, while
  $\omega$ stands for a world that is universally quantified.

  \begin{figure}[ht]
    \caption{Inference rules for $\Box$ and $\Diamond$ in IS$5^\cup$}
    \label{fig:is5cupBoxDiamond}
    \begin{center}
      \AxiomC{$\Gamma, \omega \text{ world} \vdash \conc{A}{$\omega$}$}
      \RightLabel{$\Box_i$} % Box intro
      \UnaryInfC{$\Gamma \vdash \conc{\Box A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\Box A}{w'}$}
      \RightLabel{$\Box_e$} % box elim
      \UnaryInfC{$\Gamma \vdash \conc{A}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A}{w'}$}
      \RightLabel{$\Diamond_i$} % Diamond intro
      \UnaryInfC{$\Gamma \vdash \conc{\Diamond A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\Diamond A}{w'}$}
      \AxiomC{$\Gamma, \omega \text{ world}, \conc{A}{$\omega$} \vdash \conc{C}{w}$}
      \RightLabel{$\Diamond_e$} % Diamond elim
      \BinaryInfC{$\Gamma \vdash \conc{C}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

  % }}}

  % Hybrid logic {{{
  \subsubsection{Hybrid Logic and Quantifiers}

  Even though $\Box$ and $\Diamond$ are introduced as modal connectives,
  they are not as expressive as we like. Moreover, for any person who
  is familiar with first-order logic, universal and existential quantifiers
  ($\forall$ and $\exists$) are more intuitive.
  For that reason, we will replace them with three different connectives:
  $\forall, \exists$ and \texttt{at}.
  The inference rules for them are presented in \autoref{fig:is5hybrid}.

  $A\ \texttt{at}\ w$ is a proposition that is an internalization of the
  $\conc{A}{w}$ judgment, just like $A \supset B$ is an internalization
  of the $A \vdash B$ judgment. \cite{tom7}

  $\forall \omega . A$ means ``for all worlds $\omega$, the proposition A is
  true''.  Similarly, $\exists \omega . A$ means ``there exists a world
  $\omega$ such that the proposition A is true''.
  Notice that our propositions now can contain references to worlds. In other
  words, $\omega$ is a bound variable for a world in the proposition $A$ above.

  % todo tethering

  \begin{figure}[ht]
    \caption{Inference rules of hybrid connectives for IS$5^\cup$}
    \label{fig:is5hybrid}
    \begin{center}
      \AxiomC{$\Gamma \vdash N : \conc{A}{w'}$}
      \RightLabel{$\texttt{at}_i$} % at intro
      \UnaryInfC{$\Gamma \vdash \conc{A\ \texttt{at}\ \text{w'}}{w}$}
      \DisplayProof
      % \hskip 1.5em
    \end{center}
  \end{figure}

  % }}}

  % Mobility {{{
  \subsection{Lambda 5 and Mobility}


  If we go back to the prison analogy, it is clear that the rules in
  \autoref{fig:is5cup} are not enough to provide communication between
  different worlds. However we have to think about what kinds of proofs Alice
  can pass onto Bob on a paper. Given that Alice has a window in her cell and
  Bob does not, can Alice teach Bob how to look up the weather by himself?
  The answer is no, whatever Alice writes down, Bob will always have to ask
  someone else. So we discover that communication between cells are restricted
  by nature, because they can only pass notes on a paper, and they are confined
  to their cells. We will later call the process of writing down data
  ``marshaling''.

  The restriction they have is communication. They cannot write down
  information that contains communication from their cell.
  Therefore we define a concept of mobility in \autoref{fig:l5Mobile} and then
  a communication inference rule in \autoref{fig:l5get}.

  \begin{figure}[ht]
    \caption{Mobility judgment for Lambda 5}
    \label{fig:l5Mobile}
    \begin{center}
      \AxiomC{}
      \RightLabel{$\top_m$} % top mobile
      \UnaryInfC{$\top$ mobile}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{}
      \RightLabel{$\texttt{at}_m$} % at mobile
      \UnaryInfC{$A\ \texttt{at}$\ w mobile}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{}
      \RightLabel{$\shamrock_m$} % at mobile
      \UnaryInfC{$\shamrock A$\ mobile}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$A$\ mobile}
      \AxiomC{$B$\ mobile}
      \RightLabel{$\land_m$} % and mobile
      \BinaryInfC{$A\land B$\ mobile}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$A$\ mobile}
      \AxiomC{$B$\ mobile}
      \RightLabel{$\lor_m$} % or mobile
      \BinaryInfC{$A\lor B$\ mobile}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$A$\ mobile}
      \RightLabel{$\forall_m$} % forall mobile
      \UnaryInfC{$\forall \omega . A$\ mobile}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$A$\ mobile}
      \RightLabel{$\exists_m$} % exists mobile
      \UnaryInfC{$\exists \omega . A$\ mobile}
      \DisplayProof
    \end{center}
  \end{figure}

  \begin{figure}[ht]
    \caption{Communication inference rule for Lambda 5}
    \label{fig:l5get}
    \begin{center}
      \AxiomC{$A$ mobile}
      \AxiomC{$\Gamma \vdash N : \conc{A}{w'}$}
      \RightLabel{get} % get
      \BinaryInfC{$\Gamma \vdash \texttt{get}\ N : \conc{A}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

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
\bibliographystyle{plain}
\bibliography{paper}
\printindex
\backmatter
\end{document}
% }}}
