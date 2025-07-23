{smcl}
{* *! version 1.0.0 [Date] [Author]}
{hline}
help for {hi:codebookgen}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:codebookgen} {hline 2}}Enhanced codebook/documentation generator{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd:codebookgen} 
[{varlist}] 
{cmd:using/}
[{cmd:,} 
{cmd:replace}
{cmd:modify}
{cmd:sheet(}{it:string}{cmd:)}
{cmd:addvars(}{it:string}{cmd:)}
{cmd:stats(}{it:string}{cmd:)}
{cmd:format}
{cmd:excelx}
]

{title:Description}

{pstd}
{cmd:codebookgen} creates comprehensive codebooks in Excel format with extended metadata capabilities.
It automatically extracts variable labels, value labels, characteristics, and missing value statistics,
producing professional documentation for your datasets.

{title:Options}

{phang}
{opt using} specifies the output Excel filename (required).

{phang}
{opt replace} overwrites an existing Excel file.

{phang}
{opt modify} appends to an existing Excel file (cannot combine with {opt replace}).

{phang}
{opt sheet(name)} specifies the worksheet name (default is "Codebook").

{phang}
{opt addvars(string)} lists additional characteristics to include as columns 
(e.g., "source validation_notes").

{phang}
{opt stats(string)} specifies additional statistics to include (planned feature).

{phang}
{opt format} applies automatic formatting (column widths, text wrapping).

{phang}
{opt excelx} forces .xlsx format (default uses Stata's default Excel format).

{title:Examples}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. codebookgen using "auto_codebook.xlsx", replace format}{p_end}

{phang2}{cmd:. codebookgen price mpg using "auto_vars.xlsx", sheet(PrimaryVars) addvars(source notes) replace}{p_end}

{phang2}{cmd:. char _dta[source] "Automobile data from Consumer Reports"}{p_end}
{phang2}{cmd:. char price[notes] "Manufacturer's suggested retail price"}{p_end}
{phang2}{cmd:. codebookgen using "auto_docs.xlsx", addvars(notes) replace}{p_end}

{title:Output Structure}

{pstd}
The generated codebook includes these default columns:

{p2colset 9 30 32 2}{...}
{p2col :Variable}Variable name{p_end}
{p2col :Label}Variable label{p_end}
{p2col :Question}Text from {cmd:char [note1]}{p_end}
{p2col :Type}Stata storage type{p_end}
{p2col :Values}Value labels or range{p_end}
{p2col :Missing}Count of missing values{p_end}
{p2col :Obs}Count of non-missing values{p_end}
{p2col :Source}Text from {cmd:char [source]}{p_end}
{p2colreset}{...}

{title:Tips}

{pstd}
1. Use characteristics to store metadata:{p_end}
{phang2}{cmd:. char define foreign[source] "Manufacturer reports"}{p_end}

{pstd}
2. For survey data, store question text:{p_end}
{phang2}{cmd:. char define Q1[note1] "What is your age?"}{p_end}

{pstd}
3. Combine with {help label} commands for complete documentation.

{title:Author}

{pstd}[Your Name]{p_end}
{pstd}[Your Institution]{p_end}
{pstd}Email: {browse "mailto:your.email@example.com":your.email@example.com}{p_end}

{title:Also see}

{psee}
Manual: {help label}, {help char}, {help putexcel}

{psee}
Online: {browse "https://www.stata.com/features/overview/codebooks/":Stata codebook overview}