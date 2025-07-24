{smcl}
{* *! version 1.0 24 Jul 2025}{...}
{title:inputcorrection — Apply text corrections or translations from Excel to a Stata dataset}

{title:Syntax}

{p 8 15 2}
{cmd:inputcorrection} {cmd:using} {it:filename.xlsx}, 
{opt idvar(varname)} 
{opt varnamecol(varname)} 
{opt correction(varname)}

{title:Description}

{pstd}
{cmd:inputcorrection} applies corrected or translated text values from an Excel file to your current Stata dataset. 
It is especially useful for updating open-ended or text-based survey responses using post-fieldwork edits made by analysts or translators.

{pstd}
The correction file must be in {bf:long format}, where each row contains:
{bf:an ID}, the {bf:variable name to update}, and the {bf:corrected value}.

{title:Options}

{phang}
{opt using filename.xlsx}  
Specifies the Excel file containing the corrections or translations. 
The file must include columns for ID, variable name, and corrected value.

{phang}
{opt idvar(varname)}  
Specifies the name of the unique identifier column. 
This column must exist in both the dataset and the Excel file.

{phang}
{opt varnamecol(varname)}  
Specifies the name of the column in the Excel file that contains the names of variables to update.

{phang}
{opt correction(varname)}  
Specifies the name of the column in the Excel file that contains the corrected or translated values.

{title:Requirements}

{pstd}
Your Excel file must contain at least the following columns:

{pmore}
- {bf:idvar}: the unique identifier for each observation (e.g. respondent ID)

{pmore}
- {bf:varnamecol}: the name of the variable to be updated (e.g. "question1", "comments")

{pmore}
- {bf:correction}: the new text value to insert into the dataset

{pstd}
The variables listed in the Excel file under {opt varnamecol()} must already exist in the Stata dataset.

{title:Example}

{phang}{cmd: use "Dataset.dta, clear}{p_end}
{phang}{cmd: inputcorrection using "corrections.xlsx", idvar(key) varnamecol(variable) correction(translated)}{p_end}

{pstd}
This example loads your main dataset, then applies corrections found in {cmd:corrections.xlsx}. 
Each corrected value replaces the value in the matching variable and observation based on {cmd:id} and {cmd:variable}.

{title:Author}

{p 4 4 2}
Md. Redoan Hossain Bhuiyan{p_end}
{p 4 4 2}
Email: redoanhossain630@gmail.com{p_end}

{title:License}

{pstd}
MIT License. Feel free to use, modify, and share.

{title:See Also}

{psee}
{help exportopenended}, {help biascheck}, {help optcounts}, {help codebookgen}
