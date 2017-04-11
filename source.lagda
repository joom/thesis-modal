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
              enumerate, url, xcolor, graphicx, hyperref, listings}
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
  \DeclareUnicodeCharacter{8709}{$\varnothing$} % overwriting \emptyset
  \DeclareUnicodeCharacter{8984}{$\shamrock$}
  \DeclareUnicodeCharacter{10626}{$\col$}
  \DeclareUnicodeCharacter{65307}{$;$}
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
  propositional logic.  Since modal logic is an extension of propositional logic,
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

  % The pair of those, $\mathfrak{F} = (W,R)$ is called a frame.
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
  means that $A$ is true for some world. The inference rules for $\Box$ and
  $\Diamond$ are in \autoref{fig:is5cupBoxDiamond}.

  % todo box definition doesn't fit kripke semantics:
  % box means A holds for all worlds accessible from the  current one
  % "forall" only holds bc we're using IS5
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

  % Validity {{{
  \subsubsection{Validity}

  % todo validity judgment
  % todo shamrock

  % }}}

  % Mobility {{{
  \subsection{Lambda 5 and Mobility}

  We stated the rules of modal logic in the previous section, and now we want
  to convert each rule to a proof term, and hence define a language that we
  will call Lambda 5. \footnote{I should note that our Lambda 5 definition is
  different from the one defined in \cite{tom7}. Our definition includes
  $\forall$ and $\exists$ for worlds, while \cite{tom7} uses $\Box$ and
  $\Diamond$ instead. Since this thesis is more about the compilation process
  than logic itself, I chose to fast-forward to quantifiers.}
  The relationship between modal logic rules and proof
  terms in Lambda 5 should resemble how propositional logic and simply typed
  lambda calculus are related in Curry-Howard correspondence.  In simpler
  words, modal propositions will be types in Lambda 5, and proof trees will be
  Lambda 5 expressions. \autoref{fig:l5term} shows the proof terms of Lambda 5.

  \begin{figure}[ht]
    \caption{Proof terms of Lambda 5}
    \label{fig:l5term}
    \begin{center}
    \end{center}\bigskip
  \end{figure}

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
      \hskip 1.5em
      \AxiomC{}
      \RightLabel{$\shamrock_m$} % shamrock mobile
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
  % todo reference to validity section

  \begin{code}
    data Hyp : Set where
      _⦂_<_> : (x : Id) (τ : Type) (w : World) → Hyp
      _∼_ : (u : Id) → (World → Type) → Hyp
  \end{code}

  We should start with what comes after the $\vdash$. We will call this
  small judgment a conclusion.

  \begin{code}
    data Conc : Set where
      _<_> : (τ : Type) (w : World) → Conc
      ↓_<_> : (τ : Type) (w : World) → Conc
  \end{code}
  % }}}

  % CPS {{{
  \subsection{CPS}

  \subsubsection{Conversion from MinML5 to CPS}
  % }}}
c
  % Closure conversion {{{
  \subsection{Closure conversion}

  \subsubsection{Conversion from CPS to the closure conversion language}
  % }}}

  % Lambda lifting {{{
  \subsection{Lambda lifting}
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
                 (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ₒ ↓ σ < w' > }) newbindings
                 × (toCtx newbindings) ⊢ ⋆< w >)
  \end{code}
  The program structure in the previous language is just a closed continuation
  |[] ⊢ₒ ⋆< w >|.  In the new structure, we will have a list of closed terms,
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
              → ℕ × Σ (List (Id × Typeₒ × World))
                       (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ₒ ↓ σ < w' > }) newbindings
                       × (Γ +++ toCtx newbindings) ⊢ₒ ↓ τ < w >)
    liftCont : ∀ {Γ w} → ℕ
             → Γ ⊢ₒ ⋆< w >
             → ℕ × Σ (List (Id × Typeₒ × World))
                      (λ newbindings → All (λ { (_ , σ , w') → [] ⊢ₒ ↓ σ < w' > }) newbindings
                      × (Γ +++ toCtx newbindings) ⊢ₒ ⋆< w >)
  \end{code}

  Types of these two functions resemble |entryPoint|, except they have a
  natural number in their arguments and outputs, and they account for the
  context of the initial term. The number in the term is a simple hack to
  generate new names for the lambda terms. It is increased by one for each
  lambda and accumulated throughout the entire lifting process.

  The most interesting case in these two function is how lambdas are handled.

  \begin{code}
    liftValue {Γ}{_}{w} n (`λ x ⦂ σ ⇒ t) with liftCont n t
    ... | n' , xs , Δ , t' =
      suc n'
      , ("_lam" ++ show n' , ` σ cont , w) ∷ xs
      , (`λ x ⦂ σ ⇒ t) ∷ Δ
      , `v ("_lam" ++ show n') (++ʳ Γ (here refl))
  \end{code}

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

  \subsubsection{Conversion to LiftedMonomorphic}

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

The last step of our compiler is code generation, and it is not practical to
generate target code directly as a concatenation of strings. The common
practice is to have an abstraction of the target language, and then generate
the code using that abstraction.

However to ensure that we are compiling to a language that executes without
exception; we will formalize a subset of JavaScript that enforces certain type and
context restrictions. A simply typed JavaScript, if you will. % TODO

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

% Statements {{{
\subsection{Statements}

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
client and server. We will go in detail about them in the section of conversion
to JS. % TODO reference

% }}}

% Expressions {{{
\subsection{Expressions}

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

% }}}

% Conversion to JavaScript {{{

\section{Conversion to JavaScript}

The $\lambda$-lifted monomorphic language gives us a list of lambda terms and a
term standing by itself that refers to those lambda terms.



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
