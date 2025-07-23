*! inputcorrection v1.0 - Program to apply corrections from Excel to Stata dataset
*! Author: Your Name
*! Date: 2023-MM-DD
*! GitHub: https://github.com/yourusername/inputcorrection

program define inputcorrection
    version 16
    syntax using/, key(varname) varnames(string) correction(string) [sheet(string)]
    
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
        
        // Check if required columns exist
        capture confirm variable `key' `varnames' `correction'
        if _rc {
            di as error "One or more specified columns (`key', `varnames', `correction') not found in the Excel file"
            exit 111
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
                di as error "Variable `var' from correction file not found in dataset"
                continue
            }
            
            // Get variable type
            local vartype: type `var'
            
            // Apply corrections for this variable
            if substr("`vartype'", 1, 3) == "str" {
                // String variable
                replace `var' = corrected_value if variable_name == "`var'" & !missing(corrected_value)
            }
            else {
                // Numeric variable - attempt destring if needed
                capture confirm numeric variable `var'
                if _rc {
                    di as error "Variable `var' is not numeric but correction file contains numeric corrections"
                    continue
                }
                
                // Try to convert corrected_value to numeric
                tempvar numval
                gen `numval' = real(corrected_value) if variable_name == "`var'" & !missing(corrected_value)
                replace `var' = `numval' if variable_name == "`var'" & !missing(`numval')
                drop `numval'
            }
            
            di as text "Applied corrections for variable: " as result "`var'"
        }
        
        // Clean up
        drop merge_key variable_name corrected_value
    }
    
    // Final restore
    restore, not
end