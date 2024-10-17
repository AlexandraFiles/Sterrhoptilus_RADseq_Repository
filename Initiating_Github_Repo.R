# Create the GitHub repository through an R project

# install usethis package (if needed)
install.packages("usethis")

# step 1 (create the project: this creates a new folder)
usethis::create_project("C:/Users/tangl/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/GitHub2")  # usually opens a new Rstudio

# step 2 (connect it with git; answer the questions in the console)
usethis::use_git()  # commit changes; restart RStudio

# connecting package to GitHub
## make changes in the directory, save changes and/or files, and commit changes
## e.g., create a new script write something in there, save file in folder "R"
## commit changes

## store your token (copy and paste token)
gitcreds::gitcreds_set()

## connect to github
usethis::use_github()

# final initial step (encouraged based open science principles)
usethis::use_readme_rmd()
