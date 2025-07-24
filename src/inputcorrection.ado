program define inputcorrection
    version 14.0
    syntax using/, idvar(string) varnamecol(string) correction(string)

    // Save the current dataset name and location
    tempfile dataset
    save `dataset', replace

    // Load corrections from Excel
    tempfile corrections
    import excel `using', firstrow clear
    save `corrections', replace

    // Check required columns exist
    use `corrections', clear
    foreach col in `idvar' `varnamecol' `correction' {
        capture confirm variable `col'
        if _rc {
            di as error "Error: Required column '`col'' not found in the correction file."
            exit 198
        }
    }

    // Keep necessary columns only
    keep `idvar' `varnamecol' `correction'

    // Get unique list of variables to correct
    levelsof `varnamecol', local(varlist_clean)

    // Loop over each variable
    foreach var of local varlist_clean {
        tempfile tmp_`var'

        // Extract corrections for this variable
        use `corrections', clear
        keep if `varnamecol' == "`var'"
        drop `varnamecol'
        rename `correction' corrected_`var'
        save `tmp_`var'', replace

        // Merge with main dataset and apply corrections
        use `dataset', clear
        capture confirm variable `var'
        if _rc {
            di as error "Warning: Variable `var' not found in the dataset. Skipping."
            continue
        }

        merge 1:1 `idvar' using `tmp_`var'', nogenerate
        replace `var' = corrected_`var' if !missing(corrected_`var')
        drop corrected_`var'
        save `dataset', replace
    }

    // Restore the updated dataset
    use `dataset', clear
end
