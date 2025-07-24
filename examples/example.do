// -------------------------------------------------------------------------
// Example: Apply translated corrections to open-ended responses
// Author: Md. Redoan Hossain Bhuiyan
// -------------------------------------------------------------------------

// 1. Load the dataset (sample)
use "example_data.dta", clear

// 2. Apply corrections from the Excel file
//    This uses the inputcorrection.ado program you've developed
inputcorrection using "corrections.xlsx", ///
    idvar(id) ///
    varnamecol(variable) ///
    correction(translated)

// 3. Browse the updated dataset (optional)
browse

// 4. Save updated dataset
save "example_data_corrected.dta", replace

// 5. Done
display as result "✅ Corrections applied and saved to example_data_corrected.dta"
