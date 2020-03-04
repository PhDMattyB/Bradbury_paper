##############################
## AFS Parents
##
## Matt Brachmann (PhDMattyB)
##
## 2020-02-25
##
##############################

setwd('~/PhD/SNP Demographic modelling/Bradbury_paper/AFS_Parents/')

library(tidyverse)
library(rsed)

set.seed(1738)

parents = read_tsv('AFS_Parent_list.txt')
parents = parents[sample(nrow(parents), 30),]
arrange(parents) %>% View()

map = read_tsv('AFS_Parents.map')

header = c('Sample_id', map$`Marker ID`)
unmade_ped = read_tsv('AFS_Parents.ped', 
                      col_names = header)

head(unmade_ped)
header_ped = unmade_ped[-1,]

id = header_ped %>% 
  select(Sample_id) %>% 
  arrange(Sample_id)

write_tsv(id, 'AFS_Parent_id.csv')

## Manipulated this file in Excel to get the ped columns
## I did it in Excel because I was lazy and this needed to get done

id = read_csv('AFS_Parent_id.csv')

formated_ped = bind_cols(id, header_ped) %>% 
  select(-Sample_id)

write_tsv(formated_ped, 
          'AFS_Parent_genotypes.ped')
