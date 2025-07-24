{smcl}
{* *! version 1.0 24 Jul 2025}{...}
{title:Title}
2
{hi:inputcorrection} {hline 2} Apply text corrections or translations from Excel to a Stata dataset

{title:Syntax}

{p 8 15 2}
{cmd:inputcorrection} {cmd:using} {it:filename.xlsx}, {opt idvar(varname)} {opt varnamecol(varname)} {opt correction(varname)}

{title:Description}

{pstd}
{cmd:inputcorrection} applies corrected or translated text values from an Excel file to your current Stata dataset. 
It is especially useful for updating open-ended or text-based survey responses using post-fieldwork edits made by analysts or translators.

{pstd}
The correction file must be in {bf:long format}, where each row contains an {bf:ID}, the {bf:variable name to update}, and the {bf:corrected value}.

{title:Options}

{phang}
{opt using filename.xlsx} 
    Specifies the Excel file containing the corrections or translations. The file must include columns for ID, variable name, and corrected value.

{phang}
{opt idvar(varname)} 
    Specifies the name of the unique identifier column, which must exist in both the dataset and the Excel file.

{phang}
{opt varnamecol(varname)} 
    Specifies the name of the column in the Excel file that contains the names of variables to update.

{phang}
{opt correction(varname)} 
    Specifies the name of the column in the Excel file that contains the corrected or translated text.

{title:Requirements}

{pstd}
Your Excel file must contain at least the following columns:
{pmore}
- {it:idvar}: the unique identifier for each observation
{pmore}
- {it:varnamecol}: the name of the variable to be updated
{pmore}
- {it:correction}: the new text value to insert into the dataset

{pstd}
The variables listed in the Excel file under {opt varnamecol()} must already exist in the Stata dataset.

{title:Example}

{phang2}{cmd:. use survey_data.dta, clear}
{phang2}{cmd:. inputcorrection using "corrections.xlsx", idvar(id) varnamecol(variable) correction(translated)}

{pstd}
This example loads your main dataset, then applies corrections found in {it:corrections.xlsx}. Each corrected value replaces the value in the matching variable and observation based on {it:id} and {it:variable name}.

{title:Author}

{pstd}
Developed by {bf:Md. Redoan Hossain Bhuiyan}  
Email: {browse "mailto:redoanhossain630@gmail.com":redoanhossain630@gmail.com}  
GitHub: {browse "https://github.com/ranaredoan/inputcorrection":github.com/yourusername/inputcorrection}

{title:Version}

{pstd}
1.0 — July 24, 2025

{title:License}

{pstd}
MIT License. Feel free to use, modify, and share.

{title:See Also}

{pstd}
{help import excel}, {help merge}, {help replace}

