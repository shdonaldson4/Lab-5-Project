#install.packages("here")
#install.packages("rio")
#install.packages("tidyverse")
#install.packages("janitor")
#install.packages("skimr")
#install.packages("dplyr")
#install.packages("ggplot2")
library(here)
library(rio)
library(tidyverse)
library(janitor)
library(skimr)
library(dplyr)
library(ggplot2)

here()

here(“data”)

list.files(here("data")) #lists files in a filder. "List all the files in the folder called "data"

here("data", "Project_Reads_Scores.csv") #Look in the folder called "data" and open the file called "P..."

#install.packages("rio")

library(rio) #imports many different types! Just needs the file path info
import(here("data", "Project_Reads_Scores.csv"))

project_reads_scores <- import(here("data", "Project_Reads_Scores.csv"))
exam1 <- import(here("data", "exam1.csv"))
eclsk <- import(here("data", "ecls-k_samp.sav"))
fatality <- import(here("data", "Fatality.txt"))

#the alternative would be to copy and paste the file path from wherever you have it, and change the slash directions
#can also import from the drop-down in the environment

#read from the web (i.e., github!). Don't forget the quotes around the weblink
pubschls <- import("https://github.com/datalorax/ncme_18/raw/master/data/pubschls.csv",
                   setclass = "tbl_df")

pubschls

#To export or save, say what you want to save (the data.frame), and where it's going to go, with the extension you want (.sav, .dta, .txt)
export(exam1, here("data", "exam1.sav"))
export(exam1, here("data", "exam1.txt"))
export(exam1, here("data", "exam1.dta"))

#CONVERT - takes one file and converts it to another format
convert(here("data", "ecls-k_samp.sav"), 
        here("data", "ecls-k_samp.dta"))

#with SPSS, it saves two variable types. In rio, you can transform the data into the character or factor version
#("yes/no") vs. (1 vs. 0)

eclsk %>%
  select(child_id:ethnic) %>% 
  head()
#so far we don't know what the 1's and 0's mean

eclsk %>% 
  characterize() %>% 
  select(child_id:ethnic) %>% 
  head()


#read it in as a tibble, 2 ways:
library(rio)
reads <- import(here("data", "Project_Reads_Scores.csv"), setclass = "tbl_df")

#above same as below
reads <- import(here("data", "Project_Reads_Scores.csv")) %>%
  as_tibble()

reads <- reads %>% 
  clean_names()
reads

dim(reads) #dimenstions
str(reads) #gives structure of variables
skim(reads) #breakdown of the data

#skim specific varialbes
select(reads, contains("score")) #select all the variables that contain the name score

#ANOMALY IN THE READS DATA
reads %>%
  count(student_id) #count number of rows per studentID. It looks like 3 rows tells us an average for all students.

#If we just want to work with individual studentIDS, must remove these rows
reads <- reads %>% 
  filter(student_id != "All Students (Average)") # != says does not equal

#SELECT HELPER FUNCTIONS
starts_with() #select all variables that start with
ends_with() #select columns that end with
contains() #select all varaibles the include the word ----

#You can mix types and helper functions
reads %>% 
  select(student_id, 1, starts_with("total"))

#You can also use select to rearrange your columns
reads %>% 
  select(student_id, 1, starts_with("total"), everything())

#Calculate means by test site
reads %>%
  group_by(test_site) %>%
  summarize(mean = mean(post_test_score))

theme_set(theme_minimal(base_size = 25))
reads %>%
  group_by(test_site) %>%
  summarize(mean = mean(post_test_score)) %>%
  ggplot(aes(test_site, mean)) +
  geom_col(alpha = 0.8)


#group by sex and ethnicity
eclsk  <- eclsk %>%
  characterize() %>%
  janitor::clean_names() %>%
  as_tibble()


ecls_smry <- eclsk %>%
  group_by(sex, ethnic) %>%
  summarize(t1r_mean = mean(t1rscale))
ecls_smry







