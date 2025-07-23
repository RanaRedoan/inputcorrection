*! inputcorrection v1.1 - Improved program with better error handling
*! Author: Your Name
*! Date: 2023-MM-DD

program define inputcorrection
    version 16
    syntax using/, key(string) varnames(string) correction(string) [sheet(string)]
    
    // Preserve original data
    preserve
    
    // Import the correction Excel file
    qui {
        if "`sheet'" == "" {
            import excel "`using'", firstrow clear
        }
        else {
            import excel "`using'", sheet("`sheet'") firstrow clear
        }
        
        // Display the variables in the correction file for debugging
        di as text _n "Variables in correction file:"
        describe, short
        
        // Check if required columns exist
        foreach col in `key' `varnames' `correction' {
            capture confirm variable `col'
            if _rc {
                di as error "Column '`col'' not found in the Excel file"
                di as error "Available columns: " _c
                qui ds
                di as result r(varlist)
                exit 111
            }
        }
        
        // Keep only necessary columns and rename for merging
        keep `key' `varnames' `correction'
        ren (`key' `varnames' `correction') (merge_key variable_name corrected_value)
        
        // Save temporary file
        tempfile corrections
        save `corrections'
        
        // Return to original data
        restore, preserve
        
        // Create merge_key in original data
        gen merge_key = `key'
        
        // Prepare for merging
        merge m:1 merge_key variable_name using `corrections', keep(master match) nogen
        
        // Process corrections
        levelsof variable_name if !missing(corrected_value), local(vars_to_correct)
        
        foreach var in `vars_to_correct' {
            // Check if variable exists in dataset
            capture confirm variable `var'
            if _rc {
                di as error "Variable '`var'' from correction file not found in dataset"
                continue
            }
            
            // Get variable type
            local vartype: type `var'
            
            // Apply corrections for this variable
            if substr("`vartype'", 1, 3) == "str" {
                // String variable
                replace `var' = corrected_value if variable_name == "`var'" & !missing(corrected_value)
                di as text "Applied string corrections for: " as result "`var'"
            }
            else {
                // Numeric variable - attempt destring if needed
                capture confirm numeric variable `var'
                if _rc {
                    di as error "Variable '`var'' is not numeric but correction file contains numeric corrections"
                    continue
                }
                
                // Try to convert corrected_value to numeric
                tempvar numval
                gen `numval' = real(corrected_value) if variable_name == "`var'" & !missing(corrected_value)
                replace `var' = `numval' if variable_name == "`var'" & !missing(`numval')
                drop `numval'
                di as text "Applied numeric corrections for: " as result "`var'"
            }
        }
        
        // Clean up
        drop merge_key variable_name corrected_value
    }
    
    // Final restore
    restore, not
end
