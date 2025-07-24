# 📦 inputcorrection

**`inputcorrection`** is a lightweight, automated Stata program that updates your dataset using corrected or translated text stored in an Excel file. It’s ideal for fieldwork or surveys where open-ended text responses are later translated or cleaned (e.g., Bangla written in English letters translated into formal English).

---

## 🚀 Installation

To install directly from GitHub:

```stata
net install inputcorrection, from("https://raw.githubusercontent.com/yourusername/inputcorrection/main/")
**
## Syntax**

inputcorrection using filename.xlsx, idvar(varname) varnamecol(varname) correction(varname)

**# Example**
use example_data.dta, clear

inputcorrection using "corrections.xlsx", ///
    idvar(id) ///
    varnamecol(variable) ///
    correction(translated)

browse
save example_data_corrected.dta, replace


**# Example Correction Sheet (corrections.xlsx)**

id     variable         original                       translated
---------------------------------------------------------------------------
1001   question1        apnar nam ki?                  What is your name?
1001   question2        apnar boyosh koto?             How old are you?
1002   question1        apni kothay thaken?            Where do you live?
1003   question3        kichu bolte chan?              Would you like to say something?


