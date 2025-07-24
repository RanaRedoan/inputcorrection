program define inputcorrection
    version 14.0
    syntax using/, idvar(string) varnamecol(string) correction(string)

    // Save the current dataset temporarily
    tempfile dataset
    save `dataset', replace

    // Import correction Excel
    tempfile corrections
    import excel `using', firstrow clear
    save `corrections', replace

    // Verify required columns exist
    use `corrections', clear
    foreach col in `idvar' `varnamecol' `correction' {
        capture confirm variable `col'
        if _rc {
            di as error "Error: Required column '`col'' not found in the correction file."
            exit 198
        }
    }

    // Keep only required columns
    keep `idvar' `varnamecol' `correction'

    // Get list of variables to update
    levelsof `varnamecol', local(varlist_clean)

    // Loop over each variable
    foreach var of local varlist_clean {
        tempfile tmp_`var'

        // Extract corrections for this variable
        use `corrections', clear
        keep if `varnamecol' == "`var'"
        drop `varnamecol'
        rename `correction' corrected
        save `tmp_`var'', replace

        // Merge and apply corrections
        use `dataset', clear
        capture confirm variable `var'
        if _rc {
            di as error "Warning: Variable `var' not found in dataset. Skipping."
            continue
        }

        merge 1:1 `idvar' using `tmp_`var'', nogenerate
        replace `var' = corrected if !missing(corrected)
        drop corrected
        save `dataset', replace
    }

    // Restore updated dataset
    use `dataset', clear
end
