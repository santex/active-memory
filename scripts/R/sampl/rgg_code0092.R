require("vcd")

data(UCBAdmissions)

ucb <- cotab_coindep(UCBAdmissions, condvars = "Dept", type = "assoc", n = 5000, margins = c(3, 1, 1, 3))
cotabplot(~ Admit + Gender | Dept, data = UCBAdmissions, panel = ucb)
