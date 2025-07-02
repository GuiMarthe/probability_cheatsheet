#!/bin/bash

# Font Comparison Script for Probability Cheatsheet
# This script creates separate PDFs for each font option

echo "Creating font comparison PDFs..."

# Create base template
cat > font_sample.tex << 'EOF'
\documentclass[10pt]{article}
\usepackage{multicol}
\usepackage{calc}
\usepackage{ifthen}
\usepackage{geometry}
\usepackage{graphicx}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{latexsym, marvosym}
\usepackage{array}
\usepackage{booktabs}
\usepackage{enumitem}
\setlist[description]{leftmargin=0pt}
\usepackage{xfrac}
\usepackage[T1]{fontenc}

FONTPACKAGE

% Custom commands from template
\newcommand{\var}{\textrm{Var}}
\newcommand{\cov}{\textrm{Cov}}
\newcommand{\N}{\mathcal{N}}
\newcommand{\Bern}{\textrm{Bern}}
\newcommand{\Bin}{\textrm{Bin}}
\newcommand{\Pois}{\textrm{Pois}}

\geometry{top=1cm,left=2cm,right=2cm,bottom=2cm}
\pagestyle{empty}

\begin{document}

\begin{center}
{\Large\bfseries FONTNAME Font Sample}\\
{\large Probability Cheatsheet Content}
\end{center}

\vspace{0.5cm}

\section{Fundamental Definitions}
\begin{description}
    \item[Random Variable] A function $X: \Omega \to \mathbb{R}$ that assigns a real number to each outcome in the sample space $\Omega$.
    \item[Independence] Events $A$ and $B$ are independent if:
    \begin{align*}
        P(A \cap B) &= P(A)P(B) \\
        P(A|B) &= P(A)
    \end{align*}
\end{description}

\section{Key Probability Rules}
\textbf{Bayes' Theorem:} $P(A|B) = \frac{P(B|A)P(A)}{P(B)}$

\textbf{Law of Total Probability:} For partition $\{B_i\}$: $P(A) = \sum_{i} P(A|B_i)P(B_i)$

\section{Expected Value}
The average value of a random variable:
\[E(X) = \sum_{x} x \cdot P(X = x) \text{ (discrete)}\]
\[E(X) = \int_{-\infty}^{\infty} x f(x) dx \text{ (continuous)}\]

\textbf{Linearity:} $E(aX + bY + c) = aE(X) + bE(Y) + c$

\textbf{Variance:} $\var(X) = E(X^2) - [E(X)]^2$

\section{Common Distributions}
\textbf{Binomial:} $X \sim \Bin(n, p)$ has PMF $P(X = k) = \binom{n}{k} p^k (1-p)^{n-k}$

Properties: $E(X) = np$, $\var(X) = np(1-p)$

\textbf{Poisson:} $X \sim \Pois(\lambda)$ has PMF $P(X = k) = \frac{\lambda^k e^{-\lambda}}{k!}$

Properties: $E(X) = \lambda$, $\var(X) = \lambda$

\textbf{Normal:} $X \sim \N(\mu, \sigma^2)$ has PDF:
\[f(x) = \frac{1}{\sqrt{2\pi\sigma^2}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}\]

Properties: $E(X) = \mu$, $\var(X) = \sigma^2$

\vspace{1cm}
\begin{center}
\rule{\textwidth}{0.4pt}

\textbf{Package to use:} \texttt{PACKAGECODE}

\rule{\textwidth}{0.4pt}
\end{center}

\end{document}
EOF

# Font configurations
declare -A fonts
fonts["Computer_Modern"]="% Default LaTeX font (no package needed)|No package needed"
fonts["Times_New_Roman"]="\usepackage{newtxtext,newtxmath}|\\\usepackage{newtxtext,newtxmath}"
fonts["Palatino"]="\usepackage{mathpazo}|\\\usepackage{mathpazo}"
fonts["Charter"]="\usepackage{charter}|\\\usepackage{charter}"

# Generate PDFs for each font
for font_name in "${!fonts[@]}"; do
    IFS='|' read -r package_line package_display <<< "${fonts[$font_name]}"

    # Create specific font file
    sed -e "s/FONTPACKAGE/$package_line/g" \
        -e "s/FONTNAME/$font_name/g" \
        -e "s/PACKAGECODE/$package_display/g" \
        font_sample.tex > "${font_name,,}_sample.tex"

    # Compile PDF
    echo "Compiling $font_name..."
    pdflatex -interaction=nonstopmode "${font_name,,}_sample.tex" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "✓ ${font_name}_sample.pdf created successfully"
    else
        echo "✗ Failed to compile $font_name"
    fi
done

# Clean up temporary files
rm -f font_sample.tex
rm -f *.aux *.log *.synctex.gz

echo ""
echo "Font comparison complete! Review the following PDFs:"
for font_name in "${!fonts[@]}"; do
    echo "  - ${font_name,,}_sample.pdf"
done

echo ""
echo "To apply a font to your main cheatsheet:"
echo "1. Choose your preferred font from the samples above"
echo "2. Add the corresponding package line to probability_cheatsheet.tex"
echo "3. Recompile your main document"
