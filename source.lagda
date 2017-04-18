%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Undergraduate Thesis, Joomy Korkut   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup {{{

  % Imports and Styling {{{
  \RequirePackage{amsmath}
  \documentclass[11pt,final]{westhesis} % add "final" flag when finished
  \def\textmu{}

  %include agda.fmt
  \usepackage{natbib, fullpage, textgreek, bussproofs, epigraph, color, float,
              enumerate, url, xcolor, graphicx, hyperref, listings, xfrac}
  \hypersetup{pdftex, backref = true, colorlinks = true, allcolors = {blue}}
  \setcounter{tocdepth}{4}
  \setcounter{secnumdepth}{4}
  \lstdefinelanguage{JavaScript}{
    keywords={break, case, catch, continue, debugger, default, delete, do, else, finally, for, function, if, in, instanceof, new, return, switch, this, throw, try, typeof, var, void, while, with},
    morecomment=[l]{//},
    morecomment=[s]{/*}{*/},
    morestring=[b]',
    morestring=[b]",
    sensitive=true
  }
  \lstset{
    numbers=left,
    numberstyle=\small,
    language=JavaScript,
    frame=single,
    framexleftmargin=15pt,
    basicstyle=\ttfamily,
    columns=fullflexible,
    keepspaces=true
  }
  \renewcommand{\hscodestyle}{\small}
  % }}}

  % Editorial commands {{{
  \newcommand{\Red}[1]{{\color{red} #1}}
  \newcommand{\nop}[0]{} % used to reconcile vim folds and latex curly braces
  \newcommand{\task}[1]{{\color{red} TASK: #1}}
  \newcommand{\tocite}[1]{{\color{red} [cite #1]}\xspace}
  %  }}}

  % Math and code commands {{{
  \renewcommand{\paragraph}[1]{\bigskip\textbf{#1}}
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
  \DeclareUnicodeCharacter{7504}{$^\text{m}$}
  \DeclareUnicodeCharacter{8338}{$_\text{o}$}
  \DeclareUnicodeCharacter{8339}{$_\text{x}$}
  \DeclareUnicodeCharacter{11388}{$_\text{j}$}
  \DeclareUnicodeCharacter{8709}{$\varnothing$} % overwriting \emptyset
  \DeclareUnicodeCharacter{8984}{$\shamrock$}
  \DeclareUnicodeCharacter{10626}{$\col$}
  \DeclareUnicodeCharacter{65307}{$;$}
  % }}}

% }}}

% Title, Abstract, TOC etc. {{{

\title{Verified Compilation of ML5 to JavaScript}
\author{Joomy Korkut}
\advisor{Daniel R. Licata}
\department{Mathematics and Computer Science}
\submitdate{April 2017}
\copyrightyear{2017}
\pagestyle{chapsec}

\makeindex
\begin{document}

\newcommand{\isc}{IS$5^\cup$}

\begin{dedication}
\epigraph{``Forgotten were the elementary rules of logic, that extraordinary
  claims require extraordinary evidence and that what can be asserted without
  evidence can also be dismissed without evidence.''}{\textit{Christopher
  Hitchens}}
\end{dedication}

\begin{acknowledgements}

  First and foremost, I would like to thank Dan Licata, my research advisor.
  He is the primary reason that I had an opportunity to get into computer
  science research, and I am immensely grateful for his patience and humility
  throughout the years that we worked together.  Every undeserved ``Good work!''
  I got from him was a great source of motivation for me.

  The amazing computer science classes I have taken with James Lipton, Norman
  Danner, and Jeff Epstein, and the eye-opening mathematics classes I have
  taken with Cameron Donnay Hill and David Pollack have sparkled my interest
  in research, so I would like to thank them for that.

  I would like to thank my dear colleague and friend Maksim Trifunovski for his
  support and comradery throughout the years we did research and worked as
  course assistants, not to mention his endless supply of \textit{rakija}.

  Finally, I would like to thank Pi, Emily, Cloie, Molly, Kivanc, Damlasu, Isin
  Ekin, and my family. I am thankful to the emotional support they provided by
  putting up with me babbling ceaselessly about linguistics, religion, history
  and politics.

\end{acknowledgements}

\begin{abstract}
  Curry-Howard correspondence describes a language that corresponds to
  propositional logic.  Since modal logic is an extension of propositional logic,
  then what language corresponds to modal logic? If there is one, then what is
  it good for?  Murphy's dissertation\cite{tom7} argues that a programming
  language designed based on modal type systems can provide elegant
  abstractions to organize local resources on different computers.  In this
  thesis, I limit his argument to simple web programming and claim that a modal
  logic based language provides a way to write readable code and correct web
  applications.  To do this, I defined and implemented a minimal language
  called ML5 in Agda and then wrote a compiler to JavaScript for it. The
  compiler is a series of type directed translations through fully formalized
  languages, the last one of which is a very limited subset of JavaScript.
  As opposed to Murphy's compiler, this one compiles to JavaScript both on the
  front end and back end through Node.js.
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
{\small\tableofcontents}
\mainmatter
% }}}

% Introduction {{{
\section{Introduction}
\label{sec:intro}

The field of web development was drastically different a decade ago from what
it is today. AJAX and frameworks like jQuery and Prototype had just been
introduced to the world and programmers had just started to use JavaScript for
things other than tacky effects. Concepts like single-page application and
server-side JavaScript were not around. As these things changed and JavaScript
became a sine qua non in web programming, programmers started to complain more
and more about the idiosyncracies of this language. Despite the inconvenience
of programming with JavaScript, people still had to use it because there were
no serious alternatives. This issue came to be known as the JavaScript
problem.\cite{jsprob} The common solution to it was to create higher level
languages or different syntaxes that compiled back to JavaScript.

This thesis stems from the same necessity of programming in a language that is
more sensible than JavaScript. Another problem we hope to solve is that current
web applications require too much boilerplate code to do network communication
with the server. This makes writing single-page applications an annoying task.
The language we will define in this thesis will not attempt solving these
issues altogether, but it will take a first step in addressing them.

Since we want to design a more sensible language that does not have the
idiosyncracies of JavaScript and that handles the network communication for us,
we now look for a basis for our language. Murphy's research shows us that a
language that uses a modal type system can handle resources in a distributed
program elegantly.\cite{tom7} This thesis will explore what happens when we
restrict the distributed system to two computers: client, i.e.\ user of the web
program, and server. Compilation process from our initial language, ML5, to
JavaScript will be a series of simple type-directed conversions. Each step
should will a specific purpose, and we should be able prove certain properties
about the compilation at each step. Murphy's work goes over some these
steps, but it prioritizes implementation over formalization, and does not go
as deep into formalization as we will go in this thesis.

In the formalization and compiler implementation, we are using the Agda proof
assistant.\cite{norell} Agda is a dependently typed functional programming
language with Haskell-like syntax, and this thesis will not go into detail
about explaining the language.\footnote{Since we will not go into detail about
Agda or dependent typing, one crucial concept we should remember is types can
be values in a dependently typed language, just like functions are values in a
functional language. Therefore a type will also belong to a type. The type of
types in Agda is called |Set|, which will come up often in this thesis.
However, not every Agda type belong to the type |Set|. Since we will not use
this distinction, we will omit the explanation. For more information, you can
read about Girard's paradox.\\A syntactic reminder about Agda is that it allows
mixfix naming of variables. An underscore character in a name stands for an
argument; in fact we will define the ternary operator |`if_`then_`else_| in
ML5. }

Our final program\footnote{The Agda source code is available at
\url{http://github.com/joom/modal}} consists of $\approx 3800$ lines of
executable Agda code. It currently does not have a parser, so the code has to
written in Agda, using the abstract syntax tree (AST) of ML5. However the task
is not as daunting as it sounds, because of the mixfix variable naming in Agda,
a program written in the AST does not look that different from any other
function language. For example, a simple program that alerts a string on the
browser looks like this:

\begin{code}
  program : [] ⊢₅ `Unit < client >
  program = `prim `alert `in (` `val (`v "alert" (here refl)) · `val (`string "hello world"))
\end{code}

Starting from ML5, our compiler has 5 conversion steps: continuation-passing
style, closure conversion, lambda lifting, monomorphization, and JavaScript.
Currently all the steps are entirely completed except the conversion from the
monomorphic language to JavaScript. Currently conversions for base types and
function calls work properly, and there is partially working network
communication between the client and the server.

Now let's go over some aspects of modal logic, so that we can understand the
modal type system we will use to organize our web programs.

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
  Now are $A$, $B$ and $A \land B$ in this rule propositions or judgments?
  Syntactically they are propositions, but if we intend to say ``$A \land B$ is
  true, if $A$ is true and $B$ is true.'' then they are in fact judgments.  The
  ambiguity about the notions of proposition and judgment can be removed by
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
  \label{ssec:modal}

  Modal logic is a broad field that includes various kinds of logic that deal
  with relational structures that have different perspectives of truth.
  \cite{blackburn}\cite{tom7} For our purposes, we only want to examine
  intuitionistic modal logic with explicit worlds.

  We call these perspectives of truth, ``possible worlds''. Each world holds a
  possibly different set of truths. It is possible for a proposition to be true
  in one world and false in another.

  To illustrate the concept, let's think of a prison that has cells, and each
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

  Alice, Bob and others in different cells have a warden, whose name is Walter.
  Walter provides communication among everyone. Alice can take a photo of
  outside and send it in an envelope to Bob through Walter. Now Bob also has a
  proof that it is sunny, and he can use it later.

  From a modal logic perspective, it matters to regulate who can send envelopes
  to whom. If we call our set of prisoners, i.e.\ worlds, $W$, then this
  regulation is achieved by a relation $R \subseteq W \times W$.

  % The pair of those, $\mathfrak{F} = (W,R)$ is called a frame.
  The properties of the relation $R$ defines the kind of logic we have.
  The logic with the relation that is reflexive, transitive
  and symmetric, i.e.\ an equivalence relation, is called
  \textbf{IS5}.\cite{lecture15-pf}
  For our purposes we will deal with the case that $R$ is a full relation
  $R = W \times W$, in other words every world will be accessible from any
  other.  We call this relation \textbf{\isc}.\cite{tom7}

  In \autoref{fig:is5cup}, we state the axioms and inference rules of
  \isc\ for the connectives that are familiar from non-modal propositional
  logic, namely $\top, \bot, \land, \lor$ and $\supset$ (reads ``implies'',
  $\Rightarrow$ is another notation for it).

  \begin{figure}[ht]
    \caption{Axioms and inference rules of \isc.}
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
      \AxiomC{$\Gamma \vdash \conc{B}{w}$}
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
      \AxiomC{$\Gamma \vdash \conc{A \lor B}{w}$}
      \AxiomC{$\Gamma,\conc{A}{w} \vdash \conc{C}{w}$}
      \AxiomC{$\Gamma,\conc{B}{w} \vdash \conc{C}{w}$}
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
  means that $A$ is true for some world.\footnote{Technically $\Box$ and
  $\Diamond$ should say ``all worlds accessible from the current one'', but
  since we are using \isc\ and all worlds are accessible from each other, we can
  directly say ``all worlds''.} The inference rules for $\Box$ and
  $\Diamond$ are in \autoref{fig:is5cupBoxDiamond}.

  Notice that we are using $w$ and $w'$ for concrete world variables, while
  $\omega$ stands for a world that is universally quantified.

  \begin{figure}[ht]
    \caption{Inference rules for $\Box$ and $\Diamond$ in \isc}
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
  \label{sssec:hybrid}

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
    \caption{Inference rules of hybrid connectives for \isc}
    \label{fig:is5hybrid}
    \begin{center}
      \AxiomC{$\Gamma \vdash N : \conc{A}{w'}$}
      \RightLabel{$\texttt{at}_i$} % at intro
      \UnaryInfC{$\Gamma \vdash \conc{A\ \texttt{at}\ \text{w'}}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{A\ \texttt{at}\ \text{w''}}{w'}$}
      \AxiomC{$\Gamma, \conc{A}{w''} \vdash \conc{C}{w'}$}
      \RightLabel{$\texttt{at}_i$} % at elim
      \BinaryInfC{$\Gamma \vdash \conc{C}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma, \omega \text{ world} \vdash \conc{A}{$\omega$}$}
      \RightLabel{$\forall_i$} % forall intro
      \UnaryInfC{$\Gamma \vdash \conc{\forall \omega . A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\forall \omega . A}{w}$}
      \RightLabel{$\forall_e$} % forall elim
      \UnaryInfC{$\Gamma \vdash \conc{[\sfrac{w'}{\omega}]A}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A}{w'}$}
      \RightLabel{$\exists_i$} % exists intro
      \UnaryInfC{$\Gamma \vdash \conc{\exists \omega . A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\exists \omega . A}{w'}$}
      \AxiomC{$\Gamma, \omega \text{ world}, \conc{A}{$\omega$} \vdash \conc{C}{w}$}
      \AxiomC{$\omega \not\in FV(C)$}
      \RightLabel{$\exists_e$} % exists elim
      \TrinaryInfC{$\Gamma \vdash \conc{C}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

  % }}}

  % Lambda 5 {{{
  \subsection{Lambda 5}
  \label{ssec:l5}

  % L5 intro {{{
  We stated the rules of modal logic in the previous section, and now we want
  to convert each rule to a proof term, and hence define a language that we
  will call Lambda 5. \footnote{We should note that our Lambda 5 definition is
  different from the one defined in \cite{tom7}. Our definition includes
  $\forall$ and $\exists$ for worlds, while \cite{tom7} uses $\Box$ and
  $\Diamond$ instead. Since this thesis is more about the compilation process
  than logic itself, we choose to fast-forward to quantifiers.}
  The relationship between modal logic rules and proof
  terms in Lambda 5 should resemble how propositional logic and simply typed
  lambda calculus are related in Curry-Howard correspondence.  In simpler
  words, modal propositions will be types in Lambda 5, and proof trees will be
  Lambda 5 expressions. \autoref{fig:l5term} shows the proof terms of Lambda
  5.\cite{tom7}\cite{monadic}

  \begin{figure}[ht]
    \caption{Proof terms of Lambda 5}
    \label{fig:l5term}
    \begin{center}
      \AxiomC{}
      \RightLabel{hyp} % variable
      \UnaryInfC{$\Gamma,\conc{x : A}{w} \vdash \conc{|v|\ x : A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{}
      \RightLabel{$\top$} % top
      \UnaryInfC{$\Gamma \vdash \conc{|tt| : \top}{w}$}
      \DisplayProof
      \hskip 1.5em
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{M : A}{w}$}
      \AxiomC{$\Gamma \vdash \conc{N : B}{w}$}
      \RightLabel{$\land_i$} % and intro
      \BinaryInfC{$\Gamma \vdash \conc{|(|M| , |N|)| : A \land B}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{M : A \land B}{w}$}
      \RightLabel{$\land_{e_1}$} % and elim 1
      \UnaryInfC{$\Gamma \vdash \conc{|fst|\ M : A}{w} $}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{M : A \land B}{w}$}
      \RightLabel{$\land_{e_2}$} % and elim 2
      \UnaryInfC{$\Gamma \vdash \conc{|snd|\ M : B}{w} $}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{M : A}{w}$}
      \RightLabel{$\lor_{i_1}$} % or intro 1
      \UnaryInfC{$\Gamma \vdash \conc{|inl|\ M : A \lor B}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{M : B}{w}$}
      \RightLabel{$\lor_{i_2}$} % or intro 2
      \UnaryInfC{$\Gamma \vdash \conc{|inr|\ M : A \lor B}{w}$}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{M : A \lor B}{w}$}
      \AxiomC{$\Gamma,\conc{x : A}{w} \vdash \conc{N_1 : C}{w}$}
      \AxiomC{$\Gamma,\conc{y : B}{w} \vdash \conc{N_2 : C}{w}$}
      \RightLabel{$\lor_e$} % or elim
      \TrinaryInfC{$\Gamma \vdash \conc{|case|\  M\ |of inl|\ x\ |⇒ |N_1\ |inr|\ y\ |⇒ |N_2 : C}{w}$}
      \DisplayProof
    \end{center}\bigskip

    \begin{center}
      \AxiomC{$\Gamma, \conc{x : A}{w} \vdash \conc{M : B}{w}$}
      \RightLabel{$\supset_i$} % implies intro
      \UnaryInfC{$\Gamma \vdash \conc{|λ |x . M\ : A \supset B}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{M : A \supset B}{w}$}
      \AxiomC{$\Gamma \vdash \conc{N : A}{w}$}
      \RightLabel{$\supset_e$} % implies elim
      \BinaryInfC{$\Gamma \vdash \conc{M\ N : B}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma \vdash N : \conc{N : A}{w'}$}
      \RightLabel{$\texttt{at}_i$} % at intro
      \UnaryInfC{$\Gamma \vdash \conc{|held|\ N : A\ \texttt{at}\ \text{w'}}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{M : A\ \texttt{at}\ \text{w''}}{w'}$}
      \AxiomC{$\Gamma, \conc{x : A}{w''} \vdash \conc{N : C}{w'}$}
      \RightLabel{$\texttt{at}_i$} % at elim
      \BinaryInfC{$\Gamma \vdash \conc{|leta|\ x = M\ |in|\ N : C}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma, \omega \text{ world} \vdash \conc{v : A}{$\omega$}$}
      \RightLabel{$\forall_i$} % forall intro
      \UnaryInfC{$\Gamma \vdash \conc{|Λ| \omega . v\ :\ \forall \omega . A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\forall \omega . A}{w}$}
      \RightLabel{$\forall_e$} % forall elim
      \UnaryInfC{$\Gamma \vdash \conc{[\sfrac{w'}{\omega}]A}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$\Gamma \vdash \conc{A}{w'}$}
      \RightLabel{$\exists_i$} % exists intro
      \UnaryInfC{$\Gamma \vdash \conc{\exists \omega . A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{\exists \omega . A}{w'}$}
      \AxiomC{$\Gamma, \omega \text{ world}, \conc{A}{$\omega$} \vdash \conc{C}{w}$}
      \AxiomC{$\omega \not\in FV(C)$}
      \RightLabel{$\exists_e$} % exists elim
      \TrinaryInfC{$\Gamma \vdash \conc{C}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

  % }}}

  % Mobility {{{
  \subsubsection{Mobility}
  \label{sssec:mobility}

  If we go back to the prison analogy, it is clear that the rules in
  \autoref{fig:is5cup} are not enough to provide communication between
  different worlds. However we have to think about what kinds of proofs Alice
  can pass onto Bob on a paper. Given that Alice has a window in her cell and
  Bob does not, can Alice instruct Bob how to look up the weather by himself?
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
      \BinaryInfC{$\Gamma \vdash |get|\ N : \conc{A}{w}$}
      \DisplayProof
    \end{center}
  \end{figure}

  % }}}

  % Validity {{{
  \subsubsection{Validity}
  \label{sssec:validity}

  Currently we only have one possibly judgment that is specifically for a
  single world. Later these will correspond to programs that run in a single
  world. We should consider that many functions we use in programs are shared
  by the client and server, such as simple library functions. \cite{tom7}

  One can argue that the $\Box$ connective (or $\forall$ for worlds) would be
  enough to cover this purpose. However we have to remember that even in that
  case the judgment will be in a specific world. Say we have a term
  $\conc{M : \forall \omega . A}{w}$. this will still be a term in the world w,
  which means if we want to use it in a different world we will have to move it
  explicitly, as we will see in \autoref{sssec:mobility}.

  Remember that in our judgment structure, before the $\vdash$, we have smaller
  judgments (i.e. hypotheses) that look like $\conc{x : A}{w}$.
  Now to solve the problem we described above, we will to introduce another
  judgment that describes a value that is valid in all worlds.
  We will denote this judgment as $u \sim \omega . A$,
  where $u$ is the name of the variable, and $A$ is a proposition in which the
  world $\omega$ is bound.

  In \autoref{sssec:hybrid} we mentioned that some judgments can be
  internalized as propositions, such as $\conc{A}{w}$ to $A\ \texttt{at}\ w$
  and $A \vdash B$ to $A \supset B$. This raises the question of what an
  internalization of $u \sim \omega . A$ would look like. Ergo we define a
  $\Box$-like proposition named $\shamrock$ (read ``shamrock''). \cite{monadic}

  % proof rules for box and shamrock are different

  \begin{figure}[ht]
    \caption{Validity rules for in Lambda 5}
    \label{fig:l5shamrock}
    \begin{center}
      \AxiomC{$\Gamma, \omega \text{ world} \vdash \conc{M : A}{$\omega$}$}
      \RightLabel{$\shamrock_i$} % Shamrock intro
      \UnaryInfC{$\Gamma \vdash \conc{|sham|\ \omega . M : \shamrock_\omega A}{w}$}
      \DisplayProof
      \hskip 1.5em
      \AxiomC{$\Gamma \vdash \conc{M : \shamrock_\omega A}{w'}$}
      \AxiomC{$\Gamma, u \sim \omega.A  \vdash \conc{N : C}{w'}$}
      \RightLabel{$\shamrock_e$} % Shamrock elim
      \BinaryInfC{$\Gamma \vdash \conc{|letsham|\ u=M\ |in|\ N : C}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{}
      \RightLabel{vhyp} % valid value hyp
      \UnaryInfC{$\Gamma, u \sim \omega.A \vdash \conc{|vval|\ u : [\sfrac{w}{\omega}]A}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{$A$ mobile}
      \AxiomC{$\Gamma \vdash \conc{M : A}{w}$}
      \AxiomC{$\Gamma, u \sim \omega.A \vdash \conc{N : C}{w}$}
      \RightLabel{put} % put
      \TrinaryInfC{$\Gamma \vdash \conc{|put|\ u = M\ |in|\ N : C}{w}$}
      \DisplayProof
    \end{center}\bigskip
    \begin{center}
      \AxiomC{}
      \RightLabel{$\shamrock_m$} % shamrock mobile
      \UnaryInfC{$\shamrock A$\ mobile}
      \DisplayProof
    \end{center}
  \end{figure}

  % }}}

  % }}}

% }}}

% Type-directed translation {{{

\section{Type-directed translation}

% TDT intro {{{
We mentioned in \autoref{sec:intro} that our compiler has 5 conversion steps:
continuation-passing style, closure conversion, lambda lifting,
monomorphization, and JavaScript.

We will start this section by describing ML5, which is more or less an Agda
formalization of Lambda 5 that we described in \autoref{ssec:l5}.  Our next
task will be to define a similar language that respects continuation-passing
style, and convert from ML5 to the new one.  Considering that most actions in
JavaScript are run through callbacks\footnote{A callback in JavaScript is not a
syntactic construct, it is rather a widely-used pattern. When there is a
computation that can take long, or will have to do communication, the common
usage is to pass it a function as an argument, which will be called when the
computation is finished. Because of this, programmers often end up with nested
anonymous function that are hard to read, also called ``callback hell''. Since
we are generating code that is not meant to be read, we can overlook that
problem.}, this process is necessary move us closer to JavaScript, our final
target language. Then we eventually want to hoist all lambdas in a program to
the top, so that we can call them by their names during network communication.
However, this is not possible because these functions contain bound variables
from previous definitions.  That is why we create closures to get rid of these
bound variables. Only after that we can hoist the functions, i.e.\ lambda
lifting. Finally, before conversion to JavaScript, we have to monomorphize
valid values into values in specific worlds.

% }}}

  % ML5 {{{
  \subsection{ML5}
  In the previous section we presented a propositional modal logic and the
  proof terms that correspond to that logic. In this section, our goal is to
  formalize this language and the compilation process to JavaScript.

  First, we should define each type in our initial language:

  \begin{code}
    data Type : Set where
      `Int `Bool `Unit `String : Type
      `_⇒_ `_×_ `_⊎_ : Type → Type → Type
      `_at_ : Type → World → Type
      `⌘ : (World → Type) → Type
      `∀ `∃ : (World → Type) → Type
  \end{code}

  Then we have to define the building block judgments that we will use in the
  ``$... \vdash ...$'' kind of judgment. We should start with what can come
  before the $\vdash$. We will call this small judgment a hypothesis.

  \begin{code}
    data Hyp : Set where
      _⦂_<_> : (x : Id) (τ : Type) (w : World) → Hyp
      _∼_ : (u : Id) → (World → Type) → Hyp
  \end{code}

  We have two kinds of hypothesis judgments, the first is the judgment is a
  specific world that we described in \autoref{ssec:modal},\footnote{For
  convenience we defined |Id = String|, where |String| is the Agda type for
  strings.} and the second is the valid value judgment we defined in
  \autoref{sssec:validity}. It is worth mentioning that a valid value takes a
  function |World → Type|, we have to apply the appropriate world to this
  function if we want to actually use the type.\cite{monadic} Using a function
  for this saves us from the trouble of having to define substitution
  ourselves.  We will also define |Context = List Hyp|.

  We will call what comes after the $\vdash$. We will call this
  small judgment a conclusion.

  \begin{code}
    data Conc : Set where
      _<_> : (τ : Type) (w : World) → Conc
      ↓_<_> : (τ : Type) (w : World) → Conc
  \end{code}

  We have two kinds of conclusion; we will call the first an expression and the
  second a value. In our definition, an expression is a term that
  potentially requires network communication for evaluation. A value, on the
  other hand, does not.

  Before defining the terms of ML5, let's define the mobility judgment in ML5
  so that we can use it in the terms.

  \begin{code}
  data _mobile : Type → Set where
    `Boolᵐ : `Bool mobile
    `Intᵐ : `Int mobile
    `Unitᵐ : `Unit mobile
    `Stringᵐ : `String mobile
    `_atᵐ_ : ∀ {A w} → (` A at w) mobile
    `_×ᵐ_ : ∀ {A B} → A mobile → B mobile → (` A × B) mobile
    `_⊎ᵐ_ : ∀ {A B} → A mobile → B mobile → (` A ⊎ B) mobile
    `∀ᵐ : ∀ {A} → A mobile → (`∀ (λ _ → A)) mobile
    `∃ᵐ : ∀ {A} → A mobile → (`∃ (λ _ → A)) mobile
    `⌘ᵐ : ∀ {A} → (`⌘ (λ _ → A)) mobile
  \end{code}

  Now that we have defined mobility as a direct formalization of
  \autoref{fig:l5Mobile}, let's define the notion of terms in ML5 and terms of
  the base types.

  \begin{code}
  data _⊢_ (Γ : Context) : Conc → Set where
    `tt : ∀ {w} → Γ ⊢ ↓ `Unit < w >
    `string : ∀ {w} → Data.String.String → Γ ⊢ ↓ `String < w >
    `true  : ∀ {w} → Γ ⊢ ↓ `Bool < w >
    `false : ∀ {w} → Γ ⊢ ↓ `Bool < w >
    `_∧_ : ∀ {w} → Γ ⊢ ↓ `Bool < w > → Γ ⊢ ↓ `Bool < w > → Γ ⊢ ↓ `Bool < w >
    `_∨_ : ∀ {w} → Γ ⊢ ↓ `Bool < w > → Γ ⊢ ↓ `Bool < w > → Γ ⊢ ↓ `Bool < w >
    `¬_  : ∀ {w} → Γ ⊢ ↓ `Bool < w > → Γ ⊢ ↓ `Bool < w >
    `if_`then_`else_ : ∀ {τ w} → Γ ⊢ `Bool < w > → Γ ⊢ τ < w > → Γ ⊢ τ < w > → Γ ⊢ τ < w >
    `n_  : ∀ {w} → ℤ → Γ ⊢ ↓ `Int < w >
    `_≤_ : ∀ {w} → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Bool < w >
    `_+_ : ∀ {w} → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Int < w >
    `_*_ : ∀ {w} → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Int < w > → Γ ⊢ ↓ `Int < w >
  \end{code}

  We define |_⊢_| to be the type of terms, similar to our usage in
  \autoref{ssec:l5}. Then we define literals and some operators for the base
  types |`Unit|, |`String|, |`Bool| and |`Int|. In order to make the language
  more practical, one can expand this to new base types and operators, such as
  floating numbers, hexadecimals etc., but what we have here is enough for a
  proof of concept.

  \begin{code}
    `v : ∀ {τ w} → (x : Id) → x ⦂ τ < w > ∈ Γ → Γ ⊢ ↓ τ < w >
    `vval : ∀ {w C} → (u : Id) → u ∼ C ∈ Γ → Γ ⊢ ↓ C w < w >
  \end{code}

  We are defining two values to use variables that are already in the context.
  The first is for the judgment |x ⦂ τ < w >|, which refers to values that are
  in a specific world.  The second is for the judgment |u ∼ C|, which refers to
  valid values. In both cases, our values require a proof that the variable we
  are using is actually in the context.

  \begin{code}
    `λ_⦂_⇒_ : ∀ {τ w} → (x : Id) (σ : Type) → (x ⦂ σ < w > ∷ Γ) ⊢ τ < w > → Γ ⊢ ↓ (` σ ⇒ τ) < w >
    `_·_ : ∀ {τ σ w} → Γ ⊢ (` τ ⇒ σ) < w > → Γ ⊢ τ < w > → Γ ⊢ σ < w >
  \end{code}

  We define lambda functions and function application. A lambda function takes
  the arguments name and type, and a function body that now contains the
  argument as well.  A lambda function is a value by itself, because it cannot
  be further reduced and therefore its evaluation does not require network
  connection. However, notice that the function body can require communication,
  therefore so can a function application. For that reason, function
  application is an expression.

  \begin{code}
    `_,_ : ∀ {τ σ w} → Γ ⊢ ↓ τ < w > →  Γ ⊢ ↓ σ < w > →  Γ ⊢ ↓ (` τ × σ) < w >
    `fst : ∀ {τ σ w} → Γ ⊢ (` τ × σ) < w > → Γ ⊢ τ < w >
    `snd : ∀ {τ σ w} → Γ ⊢ (` τ × σ) < w > → Γ ⊢ σ < w >
    `inl_`as_ : ∀ {τ w} → Γ ⊢ ↓ τ < w > → (σ : Type) → Γ ⊢ ↓ (` τ ⊎ σ) < w >
    `inr_`as_ : ∀ {σ w} → Γ ⊢ ↓ σ < w > → (τ : Type) → Γ ⊢ ↓ (` τ ⊎ σ) < w >
    `case_`of_⇒_||_⇒_ : ∀ {τ σ υ w} → Γ ⊢ (` τ ⊎ σ) < w > → (x : Id) → (x ⦂ τ < w > ∷ Γ) ⊢ υ < w >
                       → (y : Id) → (y ⦂ σ < w > ∷ Γ) ⊢ υ < w > → Γ ⊢ υ < w >
  \end{code}

  Then we define terms for the product type |`_×_|, which corresponds to the
  logical connective $\land$, and the sum type |`_⊎_|, which corresponds to the
  logical connective $\lor$. We define introduction and elimination terms for
  both.

  \begin{code}
    `hold : ∀ {τ w w'} → Γ ⊢ ↓ τ < w' > → Γ ⊢ ↓ (` τ at w') < w >
    `leta_`=_`in_ : ∀ {τ σ w w'} → (x : Id) → Γ ⊢ (` τ at w') < w > → ((x ⦂ τ < w' >) ∷ Γ) ⊢ σ < w > → Γ ⊢ σ < w >
    `sham : ∀ {w} {A : World → Type} → ((ω : World) → Γ ⊢ ↓ (A ω) < ω >) → Γ ⊢ ↓ `⌘ A < w >
    `letsham_`=_`in_ : ∀ {σ w} {A : World → Type} → (u : Id) → Γ ⊢ `⌘ A < w >
                     → (u ∼ A ∷ Γ) ⊢ σ < w > → Γ ⊢ σ < w >
    `put : ∀ {τ σ w} {m : τ mobile} (u : Id) → Γ ⊢ τ < w > → ((u ∼ (λ _ → τ)) ∷ Γ) ⊢ σ < w > → Γ ⊢ σ < w >
  \end{code}

  We define introduction and elimination terms for the |at| and $\shamrock$
  connectives we defined in \autoref{sssec:hybrid} and
  \autoref{sssec:validity}. Our terms here are direct formalizations of the
  inference rules $|at|_i, |at|_e, \shamrock_i, \shamrock_e, |put|$ respectively,
  defined in \autoref{fig:l5term} and \autoref{fig:l5shamrock}.

  \begin{code}
    `Λ : ∀ {w} {A : World → Type} → ((ω : World) → Γ ⊢ ↓ A ω < w >) → Γ ⊢ ↓ `∀ A < w >
    _⟨_⟩ : ∀ {w} {A : World → Type} → Γ ⊢ `∀ A < w > → (ω : World) → Γ ⊢ (A ω) < w >
    `wpair : ∀ {w} {A : World → Type} (ω : World) → Γ ⊢ ↓ A ω < w > → Γ ⊢ ↓ `∃ A < w >
    `unpack_`=_`in_ : ∀ {w τ} {A : World → Type} (x : Id) → Γ ⊢ `∃ A < w >
                    → ((ω : World) → ((x ⦂ A ω < w >) ∷ Γ) ⊢ τ < w >) → Γ ⊢ τ < w >
  \end{code}

  We define introduction and elimination terms for the $\forall$ and $\exists$
  connectives we defined in \autoref{sssec:hybrid}.  Our terms are direct
  formalizations of the inference rules $\forall_i ,\forall_e, \exists_i,
  \exists_e$, respectively, defined in \autoref{fig:l5term}.

  \begin{code}
    `get : ∀ {τ w w'} {m : τ mobile} → Γ ⊢ τ < w' > → Γ ⊢ τ < w >
    `val : ∀ {τ w} → Γ ⊢ ↓ τ < w > → Γ ⊢ τ < w >
    `prim_`in_ : ∀ {h w σ} (x : Prim h) → (h ∷ Γ) ⊢ σ < w > → Γ ⊢ σ < w >
  \end{code}

  We define the most important term in ML5, |get|, in order to move a mobile
  expression from one world to another. It is a term after the inference rule
  we defined in \autoref{fig:l5get}. |get| will often be an interesting case
  during our type-directed conversions; keeping an eye out for it will help us
  understand the compiler better.

  We define the term |val| to inject values into expressions.\cite{monadic}
  Since an expression is a term that potentially requires communication, a
  value can also be an expression.

  We define an expression to generalize primitive functions we will have in our
  language. We will define a type |Prim : Hyp → Set| that will contain all of
  our primitives, instead of adding new terms to the type |_⊢_|. We will not go over the primitive much throughout the conversion, but our |Prim| type in ML5 is as follows:

  \begin{code}
  data Prim : Hyp → Set where
    `alert : Prim ("alert" ⦂ ` `String ⇒ `Unit  < client >)
    `write : Prim ("write" ⦂ ` `String ⇒ `Unit  < client >)
    `version : Prim ("version" ⦂ `String < server > )
    `log : Prim ("log" ∼ (λ _ → ` `String ⇒ `Unit))
    `prompt : Prim ("prompt" ⦂ ` `String ⇒ `String < client >)
    `readFile : Prim ("readFile" ⦂ ` `String ⇒ `String < server >)
  \end{code}

  Observe that having valid value primitives also makes sense in some cases such as |`log|, because logging to console makes sense in both client and server.

  With that, we conclude the definition of ML5.

  % }}}

  % CPS {{{
  \subsection{CPS}

  % CPS intro {{{

  Currently we have an ML5 program whose control flow is unspecified. We need a
  language that can represent the entire control and data flow
  explicitly.\cite{appel} We will achieve this by representing the control
  stack in a function that will be called the continuation function
  |K|.\cite{regexp2016} The idea behind a continuation function is not far from
  a JavaScript callback; both are functions that are called when a certain
  computation is completed.  Since nothing is returned and the rest of the
  computation happens through the continuation function, our resulting program
  in CPS will be an expression without a type, we will call this a continuation
  expression, |⋆|.

  \begin{code}
  data Conc : Set where
    ⋆<_> : (w : World) → Conc
    ↓_<_> : (τ : Type) (w : World) → Conc
  \end{code}

  In the CPS language, we have a different conclusion judgments. |⋆<_>| is the
  continuation expression that denotes a computation that calls the
  continuation function inside. On the other hand, our value judgment |↓_<_>|
  remains the same.

  We will also replace the function type |`_⇒_| with an alternative that
  respects the continuations.

  \begin{code}
    `_cont : Type → Type
  \end{code}

  As we mentioned above, expression evaluation does not return anything
  anymore, it rather calls a continuation function with the computed value. In
  that case, a function does not have a return type; it only has an argument
  type.

  The value terms in ML5 stay the same in the CPS language, however the
  expressions all have to become continuation expressions. Let's go over the
  new terms in our language.

  \begin{code}
    `if_`then_`else_ : ∀ {w} → Γ ⊢ ↓ `Bool < w >
                     → Γ ⊢ ⋆< w >
                     → Γ ⊢ ⋆< w >
                     → Γ ⊢ ⋆< w >
    `letcase_,_`=_`in_`or_ : ∀ {τ σ w} → (x y : Id)
                           → Γ ⊢ ↓ (` τ ⊎ σ) < w >
                           → ((x ⦂ τ < w >) ∷ Γ) ⊢ ⋆< w >
                           → ((y ⦂ σ < w >) ∷ Γ) ⊢ ⋆< w >
                           → Γ ⊢ ⋆< w >
    `let_`=fst_`in_ : ∀ {τ σ w} → (x : Id)
        → Γ ⊢ ↓ (` τ × σ) < w >
        → ((x ⦂ τ < w >) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
    `let_`=snd_`in_ : ∀ {τ σ w} → (x : Id)
        → Γ ⊢ ↓ (` τ × σ) < w >
        → ((x ⦂ σ < w >) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
  \end{code}

  The conditional expression and the elimination terms of |`_⊎_| and |`_×_|
  become continuation expressions. All expressions in the corresponding terms
  in ML5 are now |⋆< w >| continuation expressions.

  \begin{code}
    `leta_`=_`in_ : ∀ {τ w w'} → (x : Id)
        → Γ ⊢ ↓ (` τ at w') < w >
        → ((x ⦂ τ < w' >) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
    `lets_`=_`in_ : ∀ {C w} → (u : Id)
        → Γ ⊢ ↓ (`⌘ C) < w >
        → ((u ∼ C) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
    `put_`=_`in_ : ∀ {τ w} {m : τ mobile} → (u : Id)
        → Γ ⊢ ↓ τ < w >
        → ((u ∼ (λ _ → τ)) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
    `let_`=_⟨_⟩`in_ : ∀ {C w} → (x : Id)
        → Γ ⊢ ↓ `∀ C < w >
        → (w' : World)
        → ((x ⦂ C w' < w >) ∷ Γ) ⊢ ⋆< w >
        → Γ ⊢ ⋆< w >
    `let_=`unpack_`in_ : ∀ {w} {A : World → Type} (x : Id)
        → Γ ⊢ ↓ `∃ A < w >
        → ((ω : World)
        → ((x ⦂ A ω < w >) ∷ Γ) ⊢ ⋆< w >)
        → Γ ⊢ ⋆< w >
  \end{code}

  Similarly, |`put| and the elimination terms of |at|, $\shamrock$, $\forall$
  and $\exists$ become continuation expressions. All expressions in the
  corresponding terms in ML5 are now |⋆< w >| continuation expressions, but
  their contexts remain the same.

  \begin{code}
    `go[_]_ : ∀ {w} → (w' : World) → Γ ⊢ ⋆< w' > → Γ ⊢ ⋆< w >
    `prim_`in_ : ∀ {h w} → (x : Prim h) → (h ∷ Γ) ⊢ ⋆< w > → Γ ⊢ ⋆< w >
    `call : ∀ {τ w} → Γ ⊢ ↓ ` τ cont < w > → Γ ⊢ ↓ τ < w > → Γ ⊢ ⋆< w >
    `halt : ∀ {w} → Γ ⊢ ⋆< w >
  \end{code}

  Observe that our definition of |`go| differs from its counterpart |`get| in
  the sense that it does not require mobility, because our expressions no
  longer have a type that we can check for mobility.
  Our definition of primitives remain the same except the judgment
  change. However, notice that function calls are different especially because
  the function type |`_⇒_| in ML5 does not exist in the CPS language; it is
  replaced by |`_cont|. We also define a new term is |`halt|, which will be
  used in the initial continuation function, as marker for the end of the
  control stack.

  This concludes our definition of the CPS language, but before we move on to
  the conversion process, let's state weakening lemmas for values and
  continuation expressions:

  \begin{code}
    ⊆-term-lemma : ∀ {Γ Γ' τ w} → Γ ⊆ Γ' → Γ ⊢ ↓ τ < w > → Γ' ⊢ ↓ τ < w >
    ⊆-cont-lemma : ∀ {Γ Γ' w} → Γ ⊆ Γ' → Γ ⊢ ⋆< w > → Γ' ⊢ ⋆< w >
  \end{code}

  Both proofs are simple inductions.

  % }}}

  % CPS conversion {{{
  \subsubsection{Conversion from ML5 to CPS}
  \label{sssec:tocps}

  During conversion from ML5 to CPS, our initial idea is that each type in ML5 will correspond to another in the CPS language. We define a function to convert ML5 types to CPS types.

  \begin{code}
  convertType : Type₅ → Typeₓ
  convertType `Int = `Int
  convertType `Bool = `Bool
  convertType `Unit = `Unit
  convertType `String = `String
  convertType (` τ × σ) = ` (convertType τ) × (convertType σ)
  convertType (` τ ⊎ σ) = ` (convertType τ) ⊎ (convertType σ)
  convertType (` τ at w) = ` (convertType τ) at w
  convertType (`⌘ C) = `⌘ (λ ω → convertType (C ω))
  convertType (`∀ C) = `∀ (λ ω → convertType (C ω))
  convertType (`∃ C) = `∃ (λ ω → convertType (C ω))
  convertType (` τ ⇒ σ) = ` (` (convertType τ) × (` convertType σ cont)) cont
  \end{code}

  This seems like a simple induction except the last case, in which a function
  is converted into a continuation term that takes a pair of an argument and a
  callback function for when the return value is ready. We describe the
  conversion of the lambda term in \hyperref[par:cpsInteresting]{the
  interesting conversion cases}.

  To convert ML5 to JavaScript, we need one function to convert the value type,
  and another one to convert the star expressions.

  \begin{code}
  convertValue : ∀ {Γ τ w}
               → Γ ⊢₅ ↓ τ < w >
               → (convertCtx Γ) ⊢ₓ ↓ (convertType τ) < w >
  convertExpr : ∀ {Γ τ w}
              → (K : ∀ {Γ'} {s' : (convertCtx Γ) ⊆ Γ'} → Γ' ⊢ₓ ↓ (convertType τ) < w > → Γ' ⊢ₓ ⋆< w >)
              → Γ ⊢₅ τ < w >
              → (convertCtx Γ) ⊢ₓ ⋆< w >
  \end{code}

  The first conversion function's type tells us that a value in ML5 can be
  converted into a value in the CPS language.  The second conversion function's
  type tells us that if we have an expression in ML5, and if we have a
  continuation function |K| that tells us what to do when the expression is
  evaluated, we can convert the ML5 expression to CPS continuation expression
  |⋆< w >|.\footnote{We are using the word ``continuation'' for three concepts,
  so we must be able to distinguish between them before getting into the
  conversion process. The first usage is a continuation expression, |⋆< w >|.
  It corresponds to the expressions in ML5 and it does not have a type for the
  reasons stated above. The second usage is continuation type, |`_cont|, the
  replacement of functions in the CPS language. The third usage is continuation
  function, often named |K|. This is an Agda-level function, i.e.\ a function
  in the meta language. }

  It turns out that defining this function with a direct induction on the
  values and expressions is not straightforward. Therefore, we slightly alter
  the type of the functions with generalization for all subsets of
  |convertCtx Γ|.

  \begin{code}
    convertValue' : ∀ {Γ Γ' τ w } {s : (convertCtx Γ) ⊆ Γ'}
                  → Γ ⊢₅ ↓ τ < w >
                  → Γ' ⊢ₓ ↓ (convertType τ) < w >
    convertExpr' : ∀ {Γ Γ' τ w}
                → {s : (convertCtx Γ) ⊆ Γ'}
                → (K : ∀ {Γ''} {s' : Γ' ⊆ Γ''} → Γ'' ⊢ₓ ↓ (convertType τ) < w > → Γ'' ⊢ₓ ⋆< w >)
                → Γ ⊢₅ τ < w >
                → Γ' ⊢ₓ ⋆< w >
  \end{code}

  Since this is the first of the type directed conversions that we are doing,
  let's look at some uninteresting and interesting cases of this conversion.

  \paragraph{Uninteresting cases}

  Every time we convert one language to another, there will be uninteresting
  cases that do not change from language to language, however the types require
  us to fulfill the formalities. In the next conversions, we will often omit
  the uninteresting cases, but since this is the first conversion we will go
  over some of them to have a general sense of what we have to do.

  \begin{code}
    convertValue' {s = s} (` t ∧ u) = ` (convertValue' {s = s} t) ∧ (convertValue' {s = s} u)
  \end{code}

  The and operator for booleans is a simple example of a straightforward
  conversion with recursive calls. We convert the two terms |t| and |u|, and
  then use the and operator in the CPS language to construct our new term.
  There are many unary and binary operators like this in our language, and
  their conversions consist of usage of the same constructor and recursive
  calls, like the case we have just seen.

  \begin{code}
    convertValue' {s = s} (`v x ∈) = `v x (s (convert∈ ∈))
  \end{code}

  We define the conversion of a variable reference in ML5 to one in CPS.  We
  have the same constructor, however since the context is changed we have to
  change the proof that the given element is in the new context. We define a
  simple inductive lemma |convert∈| to handle that problem.

  \begin{code}
    convert∈ : ∀ {h Γ} → h ∈ Γ → (convertHyp h) ∈ (convertCtx Γ)
    convert∈ (here px) = here (cong convertHyp px)
    convert∈ (there i) = there (convert∈ i)
  \end{code}

  Now let's go back to the two |convertValue'|. We have constructors like |`Λ|
  and |`sham| that take a function from |World| to a term. Conversion for them will
  proceed as follows:

  \begin{code}
    convertValue' {s = s} (`Λ C) = `Λ (λ ω → convertValue' {s = s} (C ω))
  \end{code}


  \paragraph{Interesting cases}
  \phantomsection
  \label{par:cpsInteresting}

  Now we want to handle the conversion cases that actually are of substance.

  \begin{code}
    convertValue' {s = s} (`λ x ⦂ σ ⇒ t) =
      `λ (x ++ "_y") ⦂ (` (convertType σ) × ` _ cont) ⇒
      (`let x `=fst (`v (x ++ "_y") (here refl)) `in
       convertExpr' {s = sub-lemma (there ∘ s)}
                   (λ {_}{s'} v →
                   `let (x ++ "_k") `=snd `v (x ++ "_y") (s' (there (here refl)))
                   `in (`call (`v (x ++ "_k") (here refl)) (⊆-term-lemma there v))) t)
  \end{code}

  The first and most prominent case we have to handle is the conversion of
  lambdas. In the definition of |convertType| we have seen that a function type
  is converted to a continuation type that takes a pair consisting of the
  original argument type and a callback function that takes the return type.
  Therefore the term we are converting is a lambda that gives new names to the
  both elements of the pair it takes as an argument, and calls the second part,
  which is a callback function, with the first part, which is the initial
  argument. Notice that the first projection of the pair and the second
  projection have different contexts, because when the second projection
  happens the first one is already in the context. Because of this, in order to
  use the two values together in the same function call, we have to weaken the
  first projection, i.e.\ to prove that it is still valid under a greater
  context.

  \begin{code}
    convertExpr' {s = s} K (` t · u) =
      convertExpr' {s = s} (λ {_}{s'} v → convertExpr' {s = s' ∘ s}
        (λ {_}{s''} v' → `call (⊆-term-lemma s'' v) (` v' , (`λ "x" ⦂ _ ⇒ K {s' = there ∘ s'' ∘ s'} (`v "x" (here refl))))) u) t
  \end{code}

  Since we changed lambda terms so much, we also have to adjust function calls
  accordingly. What was once a lambda function in ML5 is now a function that
  takes a pair of the initial argument and a callback function. Therefore
  during a function call, we should pass a pair of those. The question of what
  the callback function will do is solved by the continuation function |K|.

  \begin{code}
    convertExpr' {w = w}{s = s} K (`get {w' = w'}{m = m} t) =
        `go[ w' ] (convertExpr' {s = s} (λ {_}{s'} v →
          `put_`=_`in_ {m = convertMobile m} "u" v (`go[ w  ] (K {s' = there ∘ s'} (`vval "u" (here refl))))) t)
  \end{code}

  We mentioned that |`go| does not contain the notion of mobility, unlike
  |`get| in ML5. Therefore we need another way of preserving the mobility data
  we inherit from the |`get| constructor. The only other expression that uses
  mobility is |put|, hence we have to use that to ensure mobility. We convert a
  |`get| to three steps: going to the other world, putting the valid mobile
  value into the context and then going back to the previous world and using
  the valid value.

  This concludes the conversion of ML5 to the CPS language.

  % }}}

  % }}}

  % Closure {{{
  \subsection{Closure}

  Our next goal is to hoist all lambdas in a program to the top, so that we
  would have names for them, which allows us to use them when we are moving
  data between the client and the server.  Doing this without taking any
  precautions about bound variables will be disastrous, therefore we first have
  to convert bound variables to a construct that we can make sure that they
  will never become free variables.  We do this by creating environment objects
  before functions and storing them so that later we can refer to the
  environment objects for the variables that used to depend on a previous
  definition. We call the combination of the environment object and the lambda,
  a closure.

  Closure language will have two more types different from the CPS language.

  \begin{code}
    `Env : List Hyp → Type
    `Σt[t×[_×t]cont] : Type → Type
  \end{code}

  The first type will be used for the environment objects we described above,
  and the second type is a hardcoded existential pair we will use to create
  closures, a combination, i.e.\ pair, of the environment object and the
  function.

  Let's start by adding the terms to use the recently introduced type |`Env|.

  \begin{code}
    `buildEnv : ∀ {Δ w} → Δ ⊆ Γ → Γ ⊢ ↓ `Env Δ < w >
    `open_`in_ : ∀ {Δ w} → Γ ⊢ ↓ `Env Δ < w > → (Δ ++ Γ) ⊢ ⋆< w > → Γ ⊢ ⋆< w >
  \end{code}

  We will have to add existential pair intro and elim rules to our language.

  \begin{code}
    `packΣ : ∀ {σ w} → (τ : Type)
           → Γ ⊢ ↓ (` τ × ` (` σ × τ) cont) < w >
           → Γ ⊢ ↓ `Σt[t×[ σ ×t]cont] < w >
    `let_,_`=unpack_`in_ : ∀ {w σ} → (τ : Type) (x : Id)
                           → (v : Γ ⊢ ↓ `Σt[t×[ σ ×t]cont] < w >)
                           → ((x ⦂ ` τ × ` (` σ × τ) cont < w >) ∷ Γ) ⊢ ⋆< w >
                           → Γ ⊢ ⋆< w >
  \end{code}

  Now that we have a hardcoded existential pair type in our language, we can
  alter the definition of |`go[_]| from our previous language.

  \begin{code}
    `go-cc[_] : ∀ {w} → (w' : World)
                       → Data.String.String
                         → Γ ⊢ ↓ `Σt[t×[ `Unit ×t]cont] < w' >
                         → Γ ⊢ ⋆< w >
  \end{code}

  That concludes the definition of our closure language. We also define and
  prove weakening lemmas for continuation expressions and values, with the
  names |⊆-cont-lemma| and |⊆-term-lemma| respectively.

  \subsubsection{Conversion from CPS to the closure conversion language}

  Similar to the CPS conversion, our closure conversion also requires the
  change of all the types through a function |convertType|.  Most of its
  definition is the same kind of induction we have seen in
  \autoref{sssec:tocps}. The only interesting case is the conversion of
  |`_cont|, a continuation type becomes an existential pair of the environment
  object and another continuation type.

  \begin{code}
  convertType ` τ cont = `Σt[t×[ convertType τ ×t]cont]
  \end{code}

  We need a conversion function for values and one for continuations, with the
  following types.

  \begin{code}
    convertValue : ∀ {Γ τ w} → Γ ⊢ₓ ↓ τ < w > → (convertCtx Γ) ⊢ₒ ↓ (convertType τ) < w >
    convertCont : ∀ {Γ w} → Γ ⊢ₓ ⋆< w > → (convertCtx Γ) ⊢ₒ ⋆< w >
  \end{code}

  Similar to our previous conversion, closure conversion also looks the the
  direct conversion of contexts and types of the values.

  \begin{code}
    convertValue {Γ}{_}{w} (`λ x ⦂ σ ⇒ t) = `packΣ (`Env (convertCtx Γ)) (` `buildEnv id , (`λ "p" ⦂ _ ⇒ c))
      where
        t' : convertCtx ((x ⦂ σ < w >) ∷ Γ) ⊢ₒ ⋆< w >
        t' = convertCont t

        c : (("p" ⦂ ` convertType σ × `Env (convertCtx Γ) < w >) ∷ []) ⊢ₒ ⋆< w >
        c = `let "env" `=snd `v "p" (here refl) `in
            `open `v "env" (here refl) `in
            `let x `=fst `v "p" (++ʳ (convertCtx Γ) (there (here refl))) `in
            (⊆-cont-lemma (sub-lemma ++ˡ) t')
  \end{code}

  Lambda function is our most essential case in closure conversion. Each
  function is turned into an existential pair using |`packΣ|, packing the
  current environment and a new lambda function together. The new function
  takes a pair of the initial argument and the environment we just built.  We
  expand the function body with expressions to name the environment object,
  initial argument, and to open up the environment object in the local context.
  This way we show that the resulting lambda function is a closed term.

  Notice that the term |t'| will be too strong to fit in the last step of our
  definition, because we defined variables and opened an environment. We have
  to weaken |t'| to be able to use it in that spot.

  \begin{code}
    convertCont {Γ} (`call t u) =
      `let contextToType Γ , "p" `=unpack (convertValue t) `in
      `let "e" `=fst `v "p" (here refl) `in
      `let "f" `=snd `v "p" (there (here refl)) `in
      `call (`v "f" (here refl))
            (` ⊆-term-lemma (there ∘ there ∘ there) (convertValue u) , `v "e" (there (here refl)))
  \end{code}

  Like CPS conversion, changing the lambda functions requires us to adjust the
  function applications as well. Since |convertValue t| is an existential pair,
  we have to unpack it into an environment and a function. Then we call the
  function with the pair of the initial argument and the environment we just
  unpacked in the previous step.

  Notice that |convertValue u| is too strong for the pair that is the argument
  to the function, because we unpacked an existential pair and also did first
  and second named projections of a pair. Therefore we have to weaken it to
  make it fit the type requirements.

  \begin{code}
    convertCont (`go[ w' ] u) =
      `go-cc[ w' ] "" (convertValue (`λ "y" ⦂ `Unit ⇒ CPS.Terms.⊆-cont-lemma there u ))
  \end{code}

  Now we are moving the term |u|, which is in the world |w'|, into a lambda
  function, and then applying the lambda conversion process we defined above.
  This will allow us to hoist it in the next step, so that we can refer to it
  by its name. The empty string is planned as a placeholder for the name we
  will assign in lambda lifting in \autoref{ssec:lifting}. Since we are adding
  a new variable |"y"| to the environment, we have to weaken the expression |u|.

  % }}}

  % Lambda lifting {{{
  \subsection{Lambda lifting}
  \label{ssec:lifting}
  Our goal with closure conversion was that we would be able to move the lambda
  terms as we like. We want to move all of them to the beginning so that we can
  give them names and refer to them with their specific names later. This will
  especially be necessary for the network communication, we need names to know
  which functions are sending and receiving data at a given point.

  Therefore we will define a function that changes the program structure, but
  keeps using the closure language we defined before.
  \begin{code}
  entryPoint : ∀ {w}
             → [] ⊢ ⋆< w >
             → Σ (List (Id × Type × World))
                 (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ ↓ σ < w' > }) newbindings
                 × (toCtx newbindings) ⊢ ⋆< w >)
  \end{code}
  The program structure in the previous language is just a closed continuation
  |[] ⊢ ⋆< w >|.  In the new structure, we will have a list of closed terms,
  which are actually the lambda terms we are relocating, and a continuation
  that should be able to use the list of closed terms. However we cannot simply
  have a list of terms, because the type of terms change according to the
  context, type and world. We need some notion of a list that can hold values
  of different types. Moreover, we do not want a loose definition, we want to
  use the same list to be the context of the remaning continuation. What we can
  do is to use an existential pair to say that there exists a list of triple of
  names, types and worlds that satisfy a certain property. If we call this
  property |P : List (Id × Type × World) → Set|, then the existential type
  would be written as |Σ (List (Id × Type × World)) (λ xs → P xs)|.  Now we
  need to specify what |P| is. Since we have two things we have to show, we can
  use a product, i.e.\ pair.

  The first part of the product will be a special kind of list called |All|.
  \footnote{The type |All| is defined in Agda standard library, in
  |Data.List.All|.  Morally it has the same constructors as a list, but it
  takes a predicate of |P : A → Set| and a list |xs : List A|.  Each element in
  the list is mapped to a |Set| using the predicate, and a value of type |All P
  xs| is constructed by providing values of type |P x| for each |x| in |xs|.
  Let's see a simple example: the type |All (λ n → n ≡ n) (1 ∷ 2 ∷ 3 ∷ [])| can
  take a value |refl ∷ refl ∷ refl ∷ []|, note that the first |refl| is of type
  |1 ≡ 1|, and the second is of type |2 ≡ 2| and so on.  Also note that the
  constructors |[]| and |_∷_| are overloaded and they can be used for both
  lists and the type |All|.} We will use it to guarantee that our list will be
  of the exact same length as the list in the existential quantifier, and to
  ensure that each term in the list is of the right type. The second part of
  the product is the remaning continuation, but we are adding the list of
  gathered terms to the context. Since we started the entire process with a
  closed term, we will not have anything else in the context.

  The definition of |entryPoint| requires functions to lift values and
  continuations. We state their types as such:

  \begin{code}
    liftValue : ∀ {Γ τ w} → ℕ
              → Γ ⊢ₒ ↓ τ < w >
              → ℕ × Σ (List (Id × Type × World))
                       (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ ↓ σ < w' > }) newbindings
                       × (Γ +++ toCtx newbindings) ⊢ ↓ τ < w >)
    liftCont : ∀ {Γ w} → ℕ
             → Γ ⊢ₒ ⋆< w >
             → ℕ × Σ (List (Id × Type × World))
                      (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ ↓ σ < w' > }) newbindings
                      × (Γ +++ toCtx newbindings) ⊢ ⋆< w >)
  \end{code}

  Types of these two functions resemble |entryPoint|, except they have a
  natural number in their arguments and outputs, and they account for the
  context of the initial term. The number in the term is a simple hack to
  generate new names for the lambda terms. It is increased by one for each
  lambda and accumulated throughout the entire lifting process.

  The most interesting case in these two functions is how lambdas are handled.

  \begin{code}
    liftValue {Γ}{_}{w} n (`λ x ⦂ σ ⇒ t) with liftCont n t
    ... | n' , xs , Δ , t' =
        suc n'
      , ("_lam" ++ show n' , ` σ cont , w) ∷ xs
      , (`λ x ⦂ σ ⇒ t) ∷ Δ
      , `v ("_lam" ++ show n') (++ʳ Γ (here refl))
  \end{code}

  Our return type is basically a product of four values. Let's go over each:
  \begin{enumerate}[1.]
  \item The accumulator for the name generator. In this case it is increased by
    one because we just used |n'| in naming the lambda.
  \item The first part of the existential |Σ (List (Id × Typeₒ × World)) _|.
    We now have one more lambda to gather, so we have to add one more term with
      the appropriate name, type and world.
  \item The actual term itself to the |All| list we defined above.
  \item What the lambda will be replaced with. Since the lambda now has a name
    and it is in the context of the resulting term, use the |`v| term to refer
      to it instead of having the literal lambda term.
  \end{enumerate}

  The other cases of these two functions consist of recursive calls, list
  append equality proofs and calls to the weakening lemma. The actual code is
  verbose and not very interesting for our purposes.

  % }}}

  % Monomorphization {{{
  \subsection{Lifted Monomorphic}

  Until this point, our definition of |Hyp| for every language contained two
  constructors: one for a specific world, and valid values. However there is no
  way to denote valid values in JavaScript, therefore we want to convert all
  valid values to specific world references. We are defining a new language
  that we will call |LiftedMonomorphic|.  The idea is to add one copy in client
  and another one in server, for each valid value.  Our new |Hyp| definition is
  as follows:
  \begin{code}
    data Hyp : Set where
      _⦂_<_> : (x : Id) (τ : Type) (w : World) → Hyp
  \end{code}

  The |LiftedMonomorphic| languages is in most cases the same as the previous
  language. The only exceptions are the two terms that contain valid values.
  Since we do not have valid values we have to revise them.

  \begin{code}
    `put_`=_`in_ : ∀ {τ w} {m : τ mobile} → (u : Id)
                 → Γ ⊢ ↓ τ < w >
                 → ((u ⦂ τ < client >) ∷ (u ⦂ τ < server >) ∷ Γ) ⊢ ⋆< w >
                 → Γ ⊢ ⋆< w >
  \end{code}

  The first of the terms to revise is putting a mobile term in a valid value.
  Instead of adding a valid value of |u ∼ (λ → τ)| in the context, we put two
  values in different worlds.

  \begin{code}
    `lets_`=_`in_ : ∀ {C w} → (u : Id)
                  → Γ ⊢ ↓ (`⌘ C) < w >
                  → ((u ⦂ C client < client >) ∷ (u ⦂ C server < server >) ∷ Γ) ⊢ ⋆< w >
                  → Γ ⊢ ⋆< w >
  \end{code}

  Similarly for shamrock, we add two different values to the context instead of
  a given valid value. However since |C| is a function |World → Type| we
  actually have to call it with the corresponding world.

  Also for each primitive that is a valid value, such as logging, we define two
  primitives, one copy for client and another for server.

  That concludes the definition of our monomorphic language. We also define and
  prove weakening lemmas for continuation expressions and values, with the
  names |⊆-cont-lemma| and |⊆-term-lemma| respectively.

  \subsubsection{Monomorphization}

  Even though defining the terms that are different in the |LiftedMonomorphic|
  language shows most of the conversion process, we still need to state the
  types of the conversion functions.  Similar to the previous conversions, we
  will have a function to convert continuations and values. We will state their
  types as follows:\footnote{We will use the suffix $_o$ for the types of the
  closure language formalization, and $^m$ for the types of the
  |LiftedMonomorphic| formalization.}

  \begin{code}
    convertValue : ∀ {Γ τ w}
                → Γ ⊢ₒ ↓ τ < w >
                → (convertCtx Γ) ⊢ᵐ ↓ convertType τ < w >
    convertCont : ∀ {Γ w}
                → Γ ⊢ₒ ⋆< w >
                → (convertCtx Γ) ⊢ᵐ ⋆< w >
  \end{code}

  The types of these functions are similar to the ones we had before. For a
  given value or continuation in the previous language, we get a value or
  continuation of the corresponding type and context. What makes this process a
  bit more interesting is that contexts are not in one to one correspondence
  anymore, because we replace every valid value with two things. This means
  |convertCtx| and proofs that show that a given variable is in the context
  will have to change.

  \begin{code}
    convertCtx : Contextₒ → Contextᵐ
    convertCtx [] = []
    convertCtx ((x ⦂ τ < w >) ∷ xs) = (id , convertType τ , w) ∷ convertCtx xs
    convertCtx ((u ∼ C) ∷ xs) = (u ⦂ convertType (C client) < client >) ∷ (u ⦂ convertType (C server) < server >) ∷ convertCtx xs
  \end{code}

  Since a converted context now can be longer than a given context, we have to
  redefine |convert∈|, a function that takes a proof that a hypothesis is in
  the context in the previous language and returns a proof that the converted
  hypothesis is in the converted context in the new language.

  \begin{code}
  hypLocalize : Hypₒ → World → Hypᵐ
  hypLocalize (x ⦂ τ < w >) w' = x ⦂ convertType τ < w >
  hypLocalize (u ∼ C) w = u ⦂ convertType (C w) < w >

  convert∈ : ∀ {ω} → (Γ : Contextₒ) → (h : Hypₒ) → h ∈ Γ → hypLocalize h ω ∈ convertCtx Γ
  convert∈ _ (x ⦂ τ < w >) (here refl) = here refl
  convert∈ {client} _ (u ∼ C) (here refl) = here refl
  convert∈ {server} _ (u ∼ C) (here refl) = there (here refl)
  convert∈ {ω} ((x ⦂ τ < w >) ∷ xs) h (there i) = there (convert∈ {ω} xs h i)
  convert∈ {ω} ((u ∼ C) ∷ xs) h (there i) = there (there (convert∈ {ω} xs h i))
  \end{code}

  Using these functions, it becomes trivial to define the |`v| and |`vval|
  cases of |convertValue|.

  Now let's use all of our definitions and state the overall conversion
  function for our entire program.
  During lambda lifting, we gathered a list of closed terms, i.e.\ terms with
  an empty context. What we are left with is a term that calls certain terms
  from the list we gathered. Our goal with the overall function is to keep the
  same structure, but all the types and terms will be in the new language.
  \begin{code}
  entryPoint : ∀ {w}
             → Σ (List (Id × Typeₒ × World))
                 (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ₒ ↓ σ < w' > }) newbindings
                 × (toCtxₒ newbindings) ⊢ₒ ⋆< w >)
             → Σ (List (Id × Typeᵐ × World))
                 (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ᵐ ↓ σ < w' > }) newbindings
                  × (toCtxᵐ newbindings) ⊢ᵐ ⋆< w >)
  \end{code}
  The actual function definition is trivial but verbose, it converts each term
  separately and then shows that the contexts are still equal.

  % }}}

% }}}

% Formalization of JavaScript {{{

\section{Formalization of JavaScript}
\label{sec:jsformalization}

% JS formalization intro {{{

The last step of our compiler is code generation, and it is not practical to
generate target code directly as a concatenation of strings. The common
practice is to have an abstraction of the target language, and then generate
the code using that abstraction.

However to ensure that we are compiling to a language that executes without
exception; we will formalize a subset of JavaScript that enforces certain type and
context restrictions. A simply typed JavaScript, if you will.

JavaScript is an imperative language that distinguishes between statements and
expressions. We want to reflect the difference between these two. However, it
is considered a good practice to avoid declaring or defining a variable in the
global namespace. The most common way to do so in JavaScript is to define
everything in an anonymous function (i.e.\ lambda) that is instantly called.

\begin{lstlisting}[caption={An anonymous function that is instantly called.},label=jsAnon]
(function() {
  // definitions etc.
})();
\end{lstlisting}

Since JavaScript has function scope, any declaration made with \lstinline{var}
will stay in the scope of the anonymous function and will not be accessible
from outside.

However, notice that the code above has an expression statement, which is a
kind of statement that evaluates an expression and ends. \lstinline{3;} is an
example of it that evaluates a number expression.  A function call is just
another kind of expression, which makes \lstinline{console.log("hello");}
another example of such statements.

Notice that this statement does not add any new declarations to the global
namespace.  We want to disallow declarations to the global namespace, so
variable declarations should not be accessible if it is not in a function
definition. Therefore, we will define two different types, namely statements
and function statements.

Let's start by defining the types that will be used in our JavaScript formalization:

\begin{code}
data Type : Set where
  `Undefined `Bool `Number `String : Type
  `Function : List Type → Type → Type
  `Object : List (Id × Type) → Type
  `Σt[t×[_×t]cont] : Type → Type
\end{code}

This definition tells us that our base types are |`Undefined|, |`Bool|,
|`Number| and |`String|.  The function type takes the list of types to denote
the arguments and a return type.  The object type takes a list of all key names
and the types of data each key holds.\footnote{Remember that JavaScript objects
are like Python dictionaries.} The last one is a hacky solution to the hard
coded existential pair we saw in the previous languages.  In reality it is a
JavaScript object that does not obey the typing rules we want for objects,
therefore we added a separate type to deal with it.

We have the notions of hypothesis and conclusion as we defined in the previous languages.

\begin{code}
data Hyp : Set where
  _⦂_<_> : (x : Id) (τ : Type) (w : World) → Hyp

Context = List Hyp

data Conc : Set where
  _<_> : (τ : Type) (w : World) → Conc
\end{code}

Now we will define three types: statements, function statements and
expressions. Since they are defined mutually recursively, let's go over their
notation first in order to understand the big picture.

We will first define |Stm_<_> : Context → World → Set|,
and |Stm Γ < w >| should read ``the statement under the context |Γ| in the
world |w|''.

We will then define |FnStm_⇓_⦂_<_> : Context → Context → Maybe Type → World → Set|,
and |FnStm Γ ⇓ γ ⦂ mσ < w >| should read ``the function statement under the
context |Γ| that extends the context with |γ| and has returned the
function with type |mσ|, in the world |w|''.

Our last definition will be |_⊢_ (Γ : Context) : Conc → Set|,
and |Γ ⊢ τ < w >| should read ``the expression under the context |Γ|, of
the type |τ|, in the world |w|''.

Now we can move on to the actual definitions of these notions.

% }}}

% Statements {{{
\subsection{Statements}
\label{ssec:statements}

We explained above that defining things in the global namespace is considered
bad practice, and therefore we planned to place all of the code in an anonymous
function that will be called instantly. Therefore, we only need one kind of
statement that can hold the function call.
By definition, we ruled out the possibility of changing the global namespace,
therefore we are not accounting for the context after the
statement.\footnote{Note that this does not mean purity. The function calls we
can make can still have side effects.}

\begin{code}
data Stm_<_> : Context → World → Set where
  `exp : ∀ {Γ τ w} → Γ ⊢ τ < w > → Stm Γ < w >
\end{code}
% }}}

% Function Statements {{{
\subsection{Function Statements}
\label{ssec:fnstm}

Now let's define rules for statements that are allowed in function definitions.

\begin{code}
data FnStm_⇓_⦂_<_> : Context → Context → Maybe Type → World → Set where
  `nop : ∀ {Γ w mσ} → FnStm Γ ⇓ [] ⦂ mσ < w >
  `exp : ∀ {Γ τ w mσ} → Γ ⊢ τ < w > → FnStm Γ ⇓ [] ⦂ mσ < w >
\end{code}

We define a no operation statement for the cases that we do not want to output any real JavaScript statement. Obviously it does not change the context or affect the return value in any way.

Our next definition is the expression statement that we explained earlier. It does not change the local context or the return value in the function.

\begin{code}
  `var : ∀ {Γ τ w mσ} → (id : Id) → (t : Γ ⊢ τ < w >) → FnStm Γ ⇓ (id ⦂ τ < w > ∷ []) ⦂ mσ < w >
\end{code}

Variable declaration is the first kind of statement that can change the
context; it will add a single element to the context.

\begin{code}
  _；_ : ∀ {Γ γ γ' w mσ}
       → FnStm Γ ⇓ γ ⦂ mσ < w >
       → FnStm (γ ++ Γ) ⇓ γ' ⦂ mσ < w >
       → FnStm Γ ⇓ (γ' ++ γ) ⦂ mσ < w >
\end{code}

We are now defining what we can call a combination statement. Since we
determined |FnStm| to be a single entity and not a list of statements, we need
a statement that can hold two different statements.\footnote{Semicolon cannot
be used in names in Agda, so we used the Unicode character U+FF1B, which looks
almost the same.} The context changes in this definition is important in order
to understand our formalization.

Since we have a variable declaration |FnStm|, we know that a given |FnStm| can
possibly change the context, which means we have to take |γ| into account.
Then for the second statement, the initial context will be the resulting
context of the first statement, which is |γ ++ Γ|. Overall, the |FnStm|
resulting from the combination of two smaller ones will have the initial
context |Γ| and will add |γ' ++ γ| to the local context.

\begin{code}
_；return_ : ∀ {Γ γ τ w}
            → FnStm Γ ⇓ γ ⦂ nothing < w >
            → (γ ++ Γ) ⊢ τ < w >
            → FnStm Γ ⇓ γ ⦂ (just τ) < w >
\end{code}

We define a similar statement to return the function we are in. Note that no
other function statement allows a change in the |Maybe Type|\footnote{Remember
that |Maybe| in Agda (and Haskell) is the same as \lstinline{option} type in ML
variants.} argument of the |FnStm|. In the beginning, that argument will start
as |nothing|, because the function has not yet been returned. It can only
change to |just τ| through this return statement we are defining. Therefore
having |just τ| guarantees that the function has a return statement. Moreover,
the structure of this statement encourages us to use it only at the very end of
the |FnStm|.\footnote{It is possible to create a |FnStm| such as
|(`nop ；return `undefined) ； `exp `undefined|, but notice that the second half of
the combination statement will not be executed in reality since the function
will return beforehand.}

Later we will define all functions in a way that the |FnStm| they take as an
argument must have a return statement.

\begin{code}
  `if_`then_`else_ : ∀ {Γ γ γ' w mσ}
                   → Γ ⊢ `Bool < w >
                   → FnStm Γ ⇓ γ ⦂ mσ < w >
                   → FnStm Γ ⇓ γ' ⦂ mσ < w >
                   → FnStm Γ ⇓ γ ∩ γ' ⦂ mσ < w >
\end{code}

JavaScript provides two different kinds of conditionals, ternary expression and
classic imperative if/else. We are choosing to use the latter, and to define
|`if_`then_`else_| as a |FnStm| that takes other function statements.

However two different branches in an if/else block may define different
variables and hence end up with different resulting contexts.  A possible
solution to that is to force the two branches to have exactly the same
resulting contexts, which would turn out to be impractical later in the
conversion from our last language to JavaScript. A simpler option is to have
two different contexts and get their intersection, which means even if two
branches define different variables, we will later only have access to the ones
defined in both.

\begin{code}
  `prim : ∀ {Γ h mσ w} → (x : Prim h) → FnStm Γ ⇓ (h ∷ []) ⦂ mσ < w >
\end{code}

The last |FnStm| we will define is the primitive. Primitives work like they do
in the previous languages, it adds a reference or definition of the primitive
to the local context. The definition of |Prim : Hyp → Set| contains the
corresponding terms for the previous primitives such as |`alert|, |`readFile|,
|`log| etc. In addition, we have two more primitives, socket references for the
client and server. We will go in detail about them in \autoref{sec:tojs}.

% }}}

% Expressions {{{
\subsection{Expressions}
\label{ssec:expressions}

Now let's define the notion of expressions, starting with the simple ones.

\begin{code}
data _⊢_ (Γ : Context) : Conc → Set where
  `string : ∀ {w} → String → Γ ⊢ `String < w >
  `true  : ∀ {w} → Γ ⊢ `Bool < w >
  `false : ∀ {w} → Γ ⊢ `Bool < w >
  `_∧_ : ∀ {w} → Γ ⊢ `Bool < w > → Γ ⊢ `Bool < w > → Γ ⊢ `Bool < w >
  `_∨_ : ∀ {w} → Γ ⊢ `Bool < w > → Γ ⊢ `Bool < w > → Γ ⊢ `Bool < w >
  `¬_  : ∀ {w} → Γ ⊢ `Bool < w > → Γ ⊢ `Bool < w >
  `_===_ : ∀ {τ w} {eq : EqType τ} → Γ ⊢ τ < w > → Γ ⊢ τ < w > → Γ ⊢ `Bool < w >
  `n_  : ∀ {w} → (ℤ ⊎ Float) → Γ ⊢ `Number < w >
  `_≤_ : ∀ {w} → Γ ⊢ `Number < w > → Γ ⊢ `Number < w > → Γ ⊢ `Bool < w >
  `_+_ : ∀ {w} → Γ ⊢ `Number < w > → Γ ⊢ `Number < w > → Γ ⊢ `Number < w >
  `_*_ : ∀ {w} → Γ ⊢ `Number < w > → Γ ⊢ `Number < w > → Γ ⊢ `Number < w >
\end{code}

We have string, boolean and number literals, and simple logical, numerical, and
comparison operations defined on them.  Note that JavaScript does not
differentiate between integers and floating numbers, so we only have one type
|`Number|, whose literal term accepts both |ℤ| and |Float|. \footnote{Remember
that |⊎| is the discriminated union type in Agda standard library, just like
\lstinline{Either} in Haskell.}

The equals operator |_===_| is more interesting than the other ones. We want to
allow only certain types of values to be compared for equality. Functions and
objects do not work properly with the \lstinline{===} operator in JavaScript,
so we will only use the base types. It suffices to say that |EqType : Type → Set|
similar to the |_mobile| we defined in the previous languages, we will skip the
definition and continue JavaScript expressions.

\begin{code}
  `undefined : ∀ {w} → Γ ⊢ `Undefined < w >
\end{code}

In JavaScript, the value \lstinline{undefined} has the type
\lstinline{undefined}. This creates a type inconsistency, because when we
declare a new variable in JavaScript without initiating it with a value, its
initial value and type are \lstinline{undefined}. Then when we assign it a
value, the type of the variable changes. This sort of behavior should not be
allowed in our formalization.

However having an undefined type and value is still useful for other purposes.
If a function is not supposed to return anything, we can use |`Undefined| as
its return type, and return the term |`undefined|, defined above, for
formality.

\begin{code}
  `v : ∀ {τ w} → (x : Id) → (x ⦂ τ < w >) ∈ Γ → Γ ⊢ τ < w >
\end{code}

We define an expression to refer to variables that are in the context.

\begin{code}
  `λ_⇒_ : ∀ {argTypes τ w Γ'} → (ids : List Id)
        → FnStm ((zipWith (_⦂_< w >) ids argTypes) ++ Γ) ⇓ Γ' ⦂ (just τ) < w >
        → Γ ⊢ `Function argTypes τ < w >
  `_·_ : ∀ {argTypes τ w} → Γ ⊢ (`Function argTypes τ) < w >
       → All (λ σ → Γ ⊢ σ < w >) argTypes
       → Γ ⊢ τ < w >
\end{code}

Even though JavaScript is an imperative language, it supports anonymous
(lambda) functions. However anonymous functions take statements, not
expressions.\footnote{It is worth noting that ECMAScript 6, an update to
JavaScript, introduces "arrow functions" that can take expressions.}

Our lambda expression first takes a list of variable names that will be added
to the context with the corresponding types we get from |`Function argTypes τ|,
which tells us that |argTypes| is the list of types of the arguments, and |τ|
is the return type of the function. Notice that the statements in the lambda
are allowed to change the local context inside, but the lambda must have a
return statement inside that returns a value of type |τ|.

Function calls take a function expression and a list of expressions, which are
the arguments to the function.
The list is in a special type called |All|
that makes sure that each expression is of the type of the corresponding
argument.



\begin{code}
`obj : ∀ {w} → (terms : List (Id × Σ Type (λ τ → Γ ⊢ τ < w >)))
      → Γ ⊢ `Object (toTypePairs terms) < w >
`proj : ∀ {keys τ w} → (o : Γ ⊢ `Object keys < w >)
      → (key : Id) → (key , τ) ∈ keys
      → Γ ⊢ τ < w >
\end{code}

Now we define object literals. The type restriction of objects are functions
are similar in our formalization, however this time we will not use the type
|All|, because we already have a definition of |∈| for lists and we want to
make use of that.  We defined our JavaScript type constructor |`Object| to take
|List (Id × Type)|, i.e.\ pairs of key names and JavaScript types of the values
they will hold.

The function |toTypePairs| maps triples |(id , τ , t)| to |(id , τ)|. When it
is applied to the first argument of the constructor |`obj|, it should give us the
pair list that is necessary for the resulting type of the JavaScript object we
are creating.

The next definition we are making is projection on objects, i.e.\ property
access. If we have an object expression and a key that is included in the type
of the object, then we can access the key.


\begin{code}
`packΣ : ∀ {σ w} → (τ : Type)
      → Γ ⊢ `Object (("type" , `String) ∷ ("fst" , τ) ∷
                     ("snd" , `Function (`Object (("type" , `String) ∷ ("fst" , σ) ∷ ("snd" , τ) ∷ []) ∷ []) `Undefined) ∷ []) < w >
      → Γ ⊢ `Σt[t×[ σ ×t]cont] < w >
`proj₁Σ : ∀ {τ σ w} → Γ ⊢ `Σt[t×[ σ ×t]cont] < w > → Γ ⊢ τ < w >
`proj₂Σ : ∀ {τ σ w} → Γ ⊢ `Σt[t×[ σ ×t]cont] < w >
        → Γ ⊢ `Function (`Object (("type" , `String) ∷ ("fst" , σ) ∷ ("snd" , τ) ∷ []) ∷ []) `Undefined < w >
\end{code}

We also define the JavaScript type |`Σt[t×[ σ ×t]cont]| to be constructed using an object with two fields, the first constructed by the type in the existential quantifier, the second is a function that also uses the same type inside.


\begin{code}
`serialize : ∀ {τ w}{m : τ mobile} → Γ ⊢ τ < w > → Γ ⊢ `String < w >
`deserialize : ∀ {τ w}{m : τ mobile} → Γ ⊢ `String < w > → Γ ⊢ τ < w >
\end{code}

We also need to have restricted serialization and deserialization for our
JavaScript expressions. In reality, we will call \lstinline{JSON.stringify} for
|`serialize| and \lstinline{JSON.parse} for |`deserialize|.
Remember that we defined a notion of mobility in our previous languages. We
will define a similar one for JavaScript terms.

\begin{code}
data _mobile : Type → Set where
  `Boolᵐ : `Bool mobile
  `Numberᵐ : `Number mobile
  `Stringᵐ : `String mobile
  `Objectᵐ : ∀ {pairs} → All (λ { ( _ , τ ) → τ mobile }) pairs → (`Object pairs) mobile
\end{code}

Mobility of |`Bool|, |`Number| and |`String| does not need explanation.
Mobility of |`Object|, however, requires all values held in the object to be
mobile as well, using the |All| type we defined earlier. The anomaly in here is
the lack of |`Undefined|, and the reason is that \lstinline{JSON.stringify}
ignores the keys that hold the value \lstinline{undefined}.\footnote{For
example \lstinline{JSON.stringify(\{"a": undefined\})} returns
\lstinline{\{\}}.}


% }}}

That concludes our formalization of JavaScript. Before we move on, we state and define weakening lemmas for all three types we defined above.

\begin{code}
  ⊆-stm-lemma : ∀ {Γ Γ' w} → Γ ⊆ Γ' → Stm Γ < w > → Stm Γ' < w >
  ⊆-fnstm-lemma : ∀ {Γ Γ' γ mσ w} → Γ ⊆ Γ' → FnStm Γ ⇓ γ ⦂ mσ < w > → FnStm Γ' ⇓ γ ⦂ mσ < w >
  ⊆-exp-lemma : ∀ {Γ Γ' τ w} → Γ ⊆ Γ' → Γ ⊢ τ < w > → Γ' ⊢ τ < w >
\end{code}

Their definitions are simple inductions.

% }}}

% Conversion to JavaScript {{{

\section{Conversion to JavaScript}
\label{sec:tojs}

% Types of functions {{{

Now that we defined a very strict subset of JavaScript, we will generate
JavaScript code from our last language.

Before our last step, the structure of a program looks like this: The lambda
lifted monomorphic language gives us a list of closed lambda terms and a term
standing by itself that refers to those lambda terms. What we want to generate
from this initially is a JavaScript statement for the client and the server.
If we remember statements from \autoref{ssec:statements}, they can represent an
entire program on their own, by holding an immediately called anonymous
function that contains the program. The overall function that converts the
program from the lifted monomorphic language to JavaScript is as follows:

\begin{code}
entryPoint : ∀ {w}
            → Σ (List (Id × Typeᵐ × World))
                (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ᵐ ↓ σ < w' > }) newbindings
                               × (LiftedMonomorphic.Types.toCtx newbindings) ⊢ᵐ ⋆< w >)
            → (Stm [] < client >) × (Stm [] < server >)
entryPoint (xs , all , t) with convertλs all
... | (Γ' , Δ') , (cliFnStmLifted , s) , (serFnStmLifted , s')
  with convertCont {toCtx xs}{Γ' +++ []}{Δ' +++ []}{s = ++ˡ ∘ s}{s' = ++ˡ ∘ s'} _ t
... | (δ , cliFnStm) , (φ , serFnStm) =
      `exp ((` `λ [] ⇒ (cliFnStmLifted ； cliFnStm ；return `undefined) · []))
    , `exp ((` `λ [] ⇒ (serFnStmLifted ； serFnStm ；return `undefined) · []))
\end{code}

We already explained the type of this function, but what about its definition?
The pattern matching |(xs , all , t)| represents our program: |xs| is the list
of triples that denote the lifted lambdas, |all| is the proof using the |All|
data type that those triples correspond to actual lambda terms, and |t| is the
remaining program.

We pass |all| to another function |convertλs| in order to convert the lifted
terms to a single function statement that consist of the converted JavaScript
function declared with the proper name. Then we call |convertCont| with the
remaining continuation expression |t|, and this provides us everything we need
for the overall conversion. We call the only constructor of statements, |`exp|
and pass it an anonymous function as we described in
\autoref{sec:jsformalization}.

Before stating the types of |convertλ| and |convertλs|, we have to define the
function |only| that we will often use in our conversion function types in
order to limit the JavaScript contexts in our conversions to a single world.

\begin{code}
  onlyCliCtx : Context → Context
  onlyCliCtx [] = []
  onlyCliCtx ((x ⦂ τ < client >) ∷ xs) = (x ⦂ τ < client >) ∷ onlyCliCtx xs
  onlyCliCtx ((x ⦂ τ < server >) ∷ xs) = onlyCliCtx xs

  onlySerCtx : Context → Context
  onlySerCtx [] = []
  onlySerCtx ((x ⦂ τ < server >) ∷ xs) = (x ⦂ τ < server >) ∷ onlySerCtx xs
  onlySerCtx ((x ⦂ τ < client >) ∷ xs) = onlySerCtx xs

  only : World → Context → Context
  only client xs = onlyCliCtx xs
  only server xs = onlySerCtx xs
\end{code}

Clearly |onlyCliCtx| removes any non-client variable from a given context, and
|onlySerCtx| removes any non-server variable from a context.

Using these definitions, let's state |convertλ| and |convertλs| to understand
|entryPoint| better.

\begin{code}
  convertλ : (id : Id) (τ : Typeᵐ) (w : World) → [] ⊢ᵐ ↓ τ < w >
           → FnStm [] ⇓ ((id ⦂ convertType τ < w >) ∷ []) ⦂ nothing < w >
             × Σ _ (λ Γ → FnStm [] ⇓ Γ ⦂ nothing < client >)
             × Σ _ (λ Δ → FnStm [] ⇓ Δ ⦂ nothing < server >)
  convertλs : ∀ {xs} → All (λ { (_ , σ , w') → [] ⊢ᵐ ↓ σ < w' > }) xs
            → Σ _ (λ { (Γ , Δ) → (FnStm [] ⇓ Γ ⦂ nothing < client > × only client (convertCtx (toCtx xs)) ⊆ Γ)
                                 × (FnStm [] ⇓ Δ ⦂ nothing < server > × only server (convertCtx (toCtx xs)) ⊆ Δ) })
\end{code}

We will not go over their definitions, but their types are the key to
understand the overall structure of our programs. Since the lambda lifted
functions are closed terms, we can say that |convertλ| takes a closed term |[]
⊢ᵐ ↓ τ < w >| and returns a triple that consists of an assignment function
statement for the lambda it just converted, and two pairs of possible
extensions of the context with function statements. The reason we need them is
network communication. In the client and the server, we might need to add new
definitions or make primitive function call for network communication purposes,
and we do not know what might need to be added to the context for that so we
use |Σ| pairs.  If we only had |FnStm [] ⇓ ((id ⦂ convertType τ < w >) ∷ []) ⦂
nothing < w >| as the resulting JavaScript term, that would be very limiting
for cases like that.

Similarly, we define a function |convertλs|, that takes an |All| list of those
closed lambda terms, converts them all to function statements using |convertλ|,
and then accumulates the resulting function statements as a single entity.
Notice that the function statements are in a |Σ| pair, which means that we
cannot guess what their resulting contexts will be. However, there is a
property about their resulting contexts that we can prove.  Since each lifted
function in |xs| will be declared in the corresponding world, we can show that
for all lifted functions, if a function is lifted, then there is an assignment
in the same world in JavaScript to the same name with the converted type of the
lifted function. In our types, this is shown as |only client (convertCtx (toCtx
xs)) ⊆ Γ| and |only server (convertCtx (toCtx xs)) ⊆ Δ)|.

Now that we dealt with the conversion of the lifted functions, we should define
conversion functions for continuation expressions and values in the lifted
monomorphic language.

\begin{code}
    convertCont : ∀ {Γ Δ Φ}
                → {s : only client (convertCtx Γ) ⊆ Δ} → {s' : only server (convertCtx Γ) ⊆ Φ}
                → (w : World)
                → Γ ⊢ᵐ ⋆< w >
                → Σ _ (λ δ → FnStm Δ ⇓ δ ⦂ nothing < client >)
                  × Σ _ (λ φ → FnStm Φ ⇓ φ ⦂ nothing < server >)
    convertValue : ∀ {Γ Δ Φ τ w}
                 → {s : only client (convertCtx Γ) ⊆ Δ} → {s' : only server (convertCtx Γ) ⊆ Φ}
                 → Γ ⊢ᵐ ↓ τ < w >
                 → (only w (convertCtx Γ)) ⊢ⱼ (convertType {w} τ) < w >
                   × Σ _ (λ δ → FnStm Δ ⇓ δ ⦂ nothing < client >)
                   × Σ _ (λ φ → FnStm Φ ⇓ φ ⦂ nothing < server >)
\end{code}

These types might look cryptic at the moment, so let's go step by step. Our
first function |convertCont| converts a continuation expression into two pairs
containing function statements and their resulting contexts.  However, it also
guarantees that when we convert |Γ|, the context of the initial continuation
expression, and take the hypotheses in a specific world using |only|, that
should be a subset of the context of the function statement in the same world.

|convertValue|'s type is slightly more cryptic. We still have the same subset
condition, but we also have a type for the value. The context of the
monomorphic value, |Γ| is related to the context of the resulting value in the
same way. Since we only want contexts that contain variables from a single
world, we say that the context of the resulting value should be the converted
context filtered in favor of the world we are in. This can be stated as |only w
(convertCtx Γ)| in our formalization. A possible question is why we need
function statements in the client and the server when we have a converted
value. The answer to that question is that some values contain continuation
expressions in them, such as lambda functions. When we compile lambda
functions, we want to make sure that we can generate the necessary network
communication code at the same time. One converted expression is not enough to
handle all of that, ergo we need to be able to generate function statements as
well.

% }}}

Now that we have a better idea of the big picture, let's get into the specifics
of this conversion.

\begin{code}
    convertCont {Γ}{Δ}{Φ}{s = s}{s' = s'} client (`if t `then u `else v)
      with convertValue {Γ}{Δ}{Φ}{s = s}{s' = s'} t
    ... | t' , (Δ' , tCli) , (Φ' , tSer)
      with convertCont {Γ}{Δ' +++ Δ}{Φ' +++ Φ}{s = ++ʳ Δ' ∘ s}{s' = ++ʳ Φ' ∘ s'} client u
    ... | (Δ'' , uCli) , (Φ'' , uSer)
      with convertCont {Γ}{Δ' +++ Δ}{Φ' +++ Φ}{s = ++ʳ Δ' ∘ s}{s' = ++ʳ Φ' ∘ s'} client v
    ... | (Δ''' , vCli) , (Φ''' , vSer) =
          (_ , (tCli ； (`if ⊆-exp-lemma (++ʳ Δ' ∘ s) t' `then uCli `else vCli)))
        , (_ , (tSer ； (uSer ； ⊆-fnstm-lemma (++ʳ Φ'') vSer)))
\end{code}

\begin{code}
    convertCont {Γ}{Δ}{Φ}{s = s}{s' = s'} w (`let x `=fst t `in u)
      with convertValue {Γ}{Δ}{Φ}{s = s}{s' = s'} t
    convertCont {Γ}{Δ}{Φ}{s = s}{s' = s'} client (`let x `=fst t `in u) | t' , (Δ' , tCli) , (Φ' , tSer)
      with convertCont {_}{_ ∷ (Δ' +++ Δ)}{Φ' +++ Φ}{s = sub-lemma (++ʳ Δ' ∘ s)}{s' = ++ʳ Φ' ∘ s'} client u
    ... | (Δ'' , uCli) , (Φ'' , uSer) =
          (_ , (tCli ； (`var x (`proj (⊆-exp-lemma (++ʳ Δ' ∘ s) t') "fst" (there (here refl))) ； uCli)))
        , (_ , (tSer ； uSer))
\end{code}

% }}}

% Related Work and Conclusion {{{

\section{Related Work and Conclusion}

% }}}

% End {{{
\bibliographystyle{plain}
\bibliography{paper}
\printindex
\backmatter
\end{document}
% }}}
