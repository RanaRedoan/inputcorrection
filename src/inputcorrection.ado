program define inputcorrection
    // Get parameters: 'varnamecol' is now a string, not a list
    syntax using/, idvar(string) varnamecol(string) correction(string)

    // Save the working dataset
    preserve

    // Import the Excel correction file
    tempfile corrections
    import excel `using', firstrow clear
    save `corrections', replace

    // Check required columns exist in the correction file
    use `corrections', clear
    foreach v in `idvar' `varnamecol' `correction' {
        capture confirm variable `v'
        if _rc {
            display as error "Error: Required column '`v'' not found in the correction file."
            exit 198
        }
    }

    // Keep only necessary columns
    keep `idvar' `varnamecol' `correction'

    // List of unique variables to correct
    levelsof `varnamecol', local(varlist_clean)

    // Loop through each variable found in the correction file
    foreach var of local varlist_clean {
        tempfile tmp_`var'
        preserve

        keep if `varnamecol' == "`var'"
        drop `varnamecol'
        rename `correction' corrected_`var'
        save `tmp_`var'', replace

        restore, preserve
        capture confirm variable `var'
        if _rc {
            display as error "Warning: Variable `var' not found in the dataset. Skipping."
            continue
        }

        merge 1:1 `idvar' using `tmp_`var'', nogenerate
        replace `var' = corrected_`var' if !missing(corrected_`var')
        drop corrected_`var'
    }

    restore
end
