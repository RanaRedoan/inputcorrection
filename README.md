# 📊 inputcorrection: Apply Text Corrections or Translations from Excel to a Stata Dataset

`inputcorrection` is a Stata program that applies **corrected or translated text values** from an Excel file to your current dataset.  
It is especially useful for updating open-ended or text-based survey responses based on post-fieldwork edits by analysts or translators.

---

## 🚀 Installation

You can install the command directly from GitHub:
```stata
net install inputcorrection, from("https://raw.githubusercontent.com/RanaRedoan/inputcorrection/main") replace
```
## 📖 Syntax
```stata
inputcorrection using filename.xlsx, idvar(varname) varnamecol(varname) correction(varname)
```

##📌 Options (Required)
`using "filename.xlsx"` → Specifies the Excel file containing corrections or translations. The file must include columns for ID, variable name, and corrected value.
`idvar(varname)` → Specifies the unique identifier column in both your dataset and the Excel file.
`varnamecol(varname)` → Specifies the column in the Excel file that contains variable names to update.
`correction(varname)` → Specifies the column in the Excel file that contains corrected or translated values.

## 📊 Description
inputcorrection updates your Stata dataset by replacing values with corrected or translated text from an Excel file.
The correction file must be in long format, with each row containing:

1. Unique ID
2. Variable name to update
3. Corrected value

### Requirements:
- The Excel file must have at least three columns: ID (`idvar`), variable name (`varnamecol`), and corrected value (`correction`).
- Variables listed in  `varnamecol()` must already exist in the Stata dataset.
This tool ensures that your dataset reflects post-fieldwork corrections efficiently, maintaining proper alignment between `IDs` and `variables`.

## 💻 Example
Apply corrections from an Excel file:
```stata
use "Dataset.dta", clear
inputcorrection using "corrections.xlsx", idvar(key) varnamecol(variable) correction(translated)
```
This example loads your main dataset, then applies corrections from corrections.xlsx.
Each corrected value replaces the value in the matching variable and observation based on ID and variable name.

---

**# Example Correction Sheet (corrections.xlsx)**
```text
id     variable         original                       translated
---------------------------------------------------------------------------
1001   question1        apnar nam ki?                  What is your name?
1001   question2        apnar boyosh koto?             How old are you?
1002   question1        apni kothay thaken?            Where do you live?
1003   question3        kichu bolte chan?              Would you like to say something?
```
You can create this sheet manually or using inputcorrection itself, ensuring the columns for ID, variable names, and corrections/translations are present.

## 🤝 Contribution
Pull requests and suggestions are welcome!
If you find issues or have feature requests, please open an Issue in the repository.

## 👨‍💻 Author
Md. Redoan Hossain Bhuiyan
📧 redoanhossain630@gmail.com

## 📌 License
This project is licensed under the MIT License.

