*! inputcorrection v1.3 - Fixed merge issue
program define inputcorrection
    version 16
    syntax using/, key(string) varnames(string) correction(string) [sheet(string) debug]
    
    if "`debug'" != "" {
        di as text _n"=== DEBUG MODE ==="
        set trace on
    }
    
    preserve
    
    // 1. Import correction file
    qui {
        if "`sheet'" == "" {
            import excel "`using'", firstrow clear
        }
        else {
            import excel "`using'", sheet("`sheet'") firstrow clear
        }
        
        // Verify columns exist
        foreach col in `key' `varnames' `correction' {
            capture confirm variable `col'
            if _rc {
                di as error "Column '`col'' not found in Excel file"
                di as error "Available columns: " _c
                qui ds
                di as result r(varlist)
                exit 111
            }
        }
        
        // Keep and rename without using temporary names
        keep `key' `varnames' `correction'
        rename `key' merge_key
        rename `varnames' var_to_correct
        rename `correction' corrected_val
        
        tempfile corrections
        save `corrections'
        
        // 2. Merge with original data
        restore, preserve
        gen merge_key = `key'
        
        merge m:1 merge_key var_to_correct using `corrections', ///
            keep(master match) nogen
        
        // 3. Apply corrections
        levelsof var_to_correct if !missing(corrected_val), local(vars_to_correct)
        
        foreach var in `vars_to_correct' {
            capture confirm variable `var'
            if _rc {
                di as error "Variable '`var'' not found in dataset"
                continue
            }
            
            local vartype: type `var'
            
            if substr("`vartype'", 1, 3) == "str" {
                replace `var' = corrected_val if var_to_correct == "`var'" & !missing(corrected_val)
                di "Corrected string variable: `var'"
            }
            else {
                tempvar numval
                gen `numval' = real(corrected_val) if var_to_correct == "`var'" & !missing(corrected_val)
                replace `var' = `numval' if var_to_correct == "`var'" & !missing(`numval')
                drop `numval'
                di "Corrected numeric variable: `var'"
            }
        }
        
        drop merge_key var_to_correct corrected_val
    }
    
    restore, not
    
    if "`debug'" != "" {
        set trace off
        di as text _n"=== DEBUG COMPLETE ==="
    }
end
