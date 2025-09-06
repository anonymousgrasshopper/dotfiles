;; Disable spell checking inside math and source code in LaTeX

;; inline math: \(...\)
((inline_formula) @nospell)

;; displayed equation: \[...\]
((displayed_equation) @nospell)

;; environments that contain math, e.g. equation, align, gather, etc.
((math_environment) @nospell)

;; inline/displayed math environments like \begin{equation}...\end{equation}
((math_environment (text) @nospell))

;; source code blocks, e.g. \begin{asy}...\end{asy} or \begin{verbatim}...\end{verbatim}
((source_code) @nospell)
