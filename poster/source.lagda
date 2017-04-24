\RequirePackage{amsmath}
\documentclass[25pt, a0paper, landscape, margin=25.4mm]{tikzposter}
\def\textmu{}

%include agda.fmt

\usepackage{natbib, textgreek, bussproofs, epigraph, float,
            enumerate, url, xcolor, graphicx, listings, xfrac}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{filecontents}
\usepackage{color}


  % Math and code commands {{{
  \newcommand{\nop}[0]{} % used to reconcile vim folds and latex curly braces
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

\newcommand{\T}[1]{\texttt{#1}}

\usepackage{more}

\title{Thinking Outside the $\Box$: \\ Verified Compilation of ML5 to JavaScript}
\institute{Wesleyan University} % See Section 4.1
\author{Joomy Korkut}

\usetheme{Simple}  % See Section 5

\begin{document}
\definecolor{myblue}{RGB}{89,65,242}
\colorlet{titlebgcolor}{myblue}
\colorlet{innerblocktitlefgcolor}{myblue}
\colorlet{blocktitlefgcolor}{myblue}

\maketitle  % See Section 4.1

\begin{columns}  % See Section 4.4

\column{0.33}

\block{Abstract}{
  % \coloredbox[bgcolor=blue,fgcolor=white]{}:w

  \Large
  Curry-Howard correspondence describes a language that corresponds to
  propositional logic.  Since modal logic is an extension of propositional logic,
  then what language corresponds to modal logic? If there is one, then what is
  it good for?  Murphy's dissertation\cite{tom7} argues that a programming
  language designed based on modal type systems can provide elegant
  abstractions to organize local resources on different computers.  In this
  thesis, I limit his argument to simple web programming and claim that a modal
  logic based language provides a way to write readable code and correct web
  applications. To do this, I defined a minimal language called ML5 in the Agda
  proof assistant and then implemented a compiler to JavaScript for it and
  proved its static correctness. The compiler is a series of type directed
  translations through fully formalized languages, the last one of which is a
  very limited subset of JavaScript.  As opposed to Murphy's compiler, this one
  compiles to JavaScript both on the front end and back end. (targeting Node.js)
  Currently the last step of conversion to JavaScript is not entirely complete.
  We have not specified the conversion rules for the modal types, and network
  communication only has a partially working proof-of-concept.
}
\block{Background}{

  Modal logic is a broad field that includes various kinds of logic that deal
  with relational structures that have different perspectives of truth.
  We call these perspectives of truth,
  ``possible worlds''. Each world holds a possibly different set of truths.
  Now we do not have the ``$A$ true'' judgment, we specify the world and say
  ``$A$ true at world $w$''. Our notation for that is $A$<$w$>.

  The intuitionistic modal logic IS5$^\cup$ allows data transition
  from any world to another. Traditionally modal logic has the $\Box$
  connective, which means a proposition is correct for all world, and the
  $\Diamond$ connective, which means a proposition is correct for some world.
  We replace them with the hybrid connectives \verb|at|, $\forall$ and
  $\exists$, such that $\Box P = \forall \omega . P\ |at|\ \omega$ and
  $\Diamond P = \exists \omega . P\ |at|\ \omega$.

  We then define the language Lambda 5 based on the proof terms of IS$5^\cup$,
  and we include a notion of mobility that oversees what can be transferred
  between worlds.  The relationship between modal logic rules and proof terms
  in Lambda 5 should resemble how propositional logic and simply typed lambda
  calculus are related in Curry-Howard correspondence, i.e.\ modal
  propositions will be types in Lambda 5, and proof trees will be Lambda 5
  expressions.

}

\column{0.33}
\block{Type-Directed Translation}{
  \Large

Our compiler has 5 conversion steps before JavaScript:\\
  \begin{enumerate}[(1)]
    \item \textbf{ML5}: an Agda formalization of Lambda 5
  \item \textbf{Continuation-passing style:} Considering that most actions in JavaScript
  are run through callbacks, this process is necessary to move us closer to
    JavaScript, our final target language.
  \item \textbf{Closure conversion}: We eventually want to hoist all lambdas in a program
  to the top, so that we can call them by their names during network
    communication.  However, this is not possible because these functions
    contain bound variables from previous definitions.  That is why we create
    closures to get rid of these bound variables.
  \item \textbf{Lambda lifting}: Now that functions do not have any other bound variables
  other than the argument of the function they are in, we can hoist the functions.
\item \textbf{Monomorphic}: Before conversion to JavaScript, we have to monomorphize
  valid values into values in specific worlds.
\end{enumerate}


}

\block{Formalization of JavaScript}{
  \Large

To prevent runtime errors in the code we generate, we will formalize a
  subset of JavaScript that enforces certain type and context restrictions.  We
  are defining three syntactic categories for our formalization: statements,
  function statements and expressions.\smallskip


|Stm Γ < w >| should read ``the statement under the context |Γ| in the
world |w|''.\smallskip

|FnStm Γ ⇓ γ ⦂ mσ < w >| should read ``the function statement under the
context |Γ| that extends the context with |γ| and has returned the
function with type |mσ|, in the world |w|''. |FnStm| can only be used in
lambda terms.\smallskip

|Γ ⊢ τ < w >| should read ``the expression under the context |Γ|, of
the type |τ|, in the world |w|''.
}

\column{0.33}
\block{Conversion to JavaScript}{
  \Large
We are defining functions to convert continuation expressions and expressions
to JavaScript expressions and function statements.

\begin{code}
convertCont : ∀ {Γ Δ Φ}
  → {s : only client (convertCtx Γ) ⊆ Δ}
  → {s' : only server (convertCtx Γ) ⊆ Φ}
  → (w : World)
  → Γ ⊢ᵐ ⋆< w >
  → Σ _ (λ δ → FnStm Δ ⇓ δ ⦂ nothing < client >)
    × Σ _ (λ φ → FnStm Φ ⇓ φ ⦂ nothing < server >)
convertValue : ∀ {Γ Δ Φ τ w}
  → {s : only client (convertCtx Γ) ⊆ Δ}
  → {s' : only server (convertCtx Γ) ⊆ Φ}
  → Γ ⊢ᵐ ↓ τ < w >
  → (only w (convertCtx Γ)) ⊢ⱼ (convertType {w} τ) < w >
    × Σ _ (λ δ → FnStm Δ ⇓ δ ⦂ nothing < client >)
    × Σ _ (λ φ → FnStm Φ ⇓ φ ⦂ nothing < server >)
\end{code}

After we get a |FnStm|, we will put it in an anonymous function and call that
immediately, which keeps everything we defined in the local context and
encapsulates our program.
At the end, we can have a huge function composition that serves as a compiler
pipeline from ML5 to JavaScript. Its definition is as follows:

\begin{code}
compileToJS : [] ⊢₅ `Unit < client > → String × String
compileToJS = (clientWrapper *** serverWrapper)
            ∘ (stmSource *** stmSource)
            ∘ LiftedMonomorphicToJS.entryPoint
            ∘ LiftedMonomorphize.entryPoint
            ∘ LambdaLifting.entryPoint
            ∘ CPStoClosure.convertCont
            ∘ ML5toCPS.convertExpr (λ v → CPS.Terms.`halt)
\end{code}

}

\block{References}{
  \bibliographystyle{plain}
  \renewcommand{\section}[2]{}%
  \bibliography{paper}
}
\end{columns}


\end{document}
