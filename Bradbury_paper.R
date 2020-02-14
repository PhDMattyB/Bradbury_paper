##############################
## Bradbury paper
##
## Matt Brachmann (PhDMattyB)
##
## 2020-02-13
##
##############################

dir.create('~/PhD/SNP Demographic modelling/Bradbury_paper')

setwd('~/PhD/SNP Demographic modelling/Bradbury_paper/')

library(rsed)
library(tidyverse)

theme_set(theme_bw())

# Other packages to load


## Read in the data and filter for the specific morph combos
PED = read_tsv('Nov052018_plink_input_icelandic_matt.ped')

data = PED %>% 
  filter(`#FamilyID` %in% c('2', '3')) %>% 
  select(IndividualID) 

##The grouping for the morphs from the ped file with all icelandic populations:
##  1. T.LGB
##  2. V.BR
##  3. V.SIL
##  4. S.PL
##  5. S.PI
##  6. T.PL
##  7. T. SB
##  8. S.LGB
##  9. G.SB
##  10. G.PI
##  11. Mjoavatn
##  12. Fljotaa

## randomly sample 30 individuals from the population
data = data[sample(nrow(data), 30),]

## write a txt file with the indivdual names for each popn
data %>% 
  arrange() %>% 
  write_tsv('Vatnshlidarvatn_RandoIndividual.txt')

# Make axiom dictionary ---------------------------------------------------
data = read_tsv('Mjoavatn_RandoIndividual.txt') %>% 
  arrange(IndividualID)

axiom_dir = read_tsv('SNPChip_Samples_Final.txt') %>% 
  # filter(Population %in% c('Mjoavatn',
  #                          'Flottaa')) %>%
  filter(Population == 'Mjoavatn') %>%
  select(custid, sample, sex_from_genotype)

id = sed_substitute(axiom_dir$sample, 
                    "-", 
                    "") %>% 
  as_tibble()

big_data = bind_cols(axiom_dir, 
                     id) %>% 
  rename(IndividualID = value)

# cel_dict = inner_join(big_data, 
#                      data, 
#                      by = 'IndividualID') %>% 
#   select(custid) %>% 
#   write_tsv('Mjoavatn_cel_list.txt')

dict = inner_join(big_data, 
                      data, 
                      by = 'IndividualID') %>% 
  write_tsv('Mjoavatn_dict.txt')

# Make cel list -----------------------------------------------------------

gal_cel = read_tsv('Galtabol_cel_list.txt')
thing_cel = read_tsv('Thingvallavatn_cel_list.txt')
svin_cel = read_tsv('Svinavatn_cel_list.txt')
vatn_cel = read_tsv('Vatnshlidarvatn_cel_list.txt')
mjoa_cel = read_tsv('Mjoavatn_cel_list.txt')
flj_cel = read_tsv('Fljotaa_cel_list.txt')

full_cel_list = bind_rows(gal_cel, thing_cel)
full_cel_list = bind_rows(full_cel_list, svin_cel)
full_cel_list = bind_rows(full_cel_list, vatn_cel)
full_cel_list = bind_rows(full_cel_list, mjoa_cel)
full_cel_list = bind_rows(full_cel_list, flj_cel) 

full_cel_list = sed_substitute(full_cel_list$custid, 
                               "_call_code", 
                               "") %>% 
  as_tibble() %>% 
  rename(cel_files = value)


write_tsv(full_cel_list, 
          'Bradbury_cel_list_iceland.txt')


# get cel files -----------------------------------------------------------

setwd('C:/Users/Matt Brachmann/AxiomSuiteAnalysis/Axiomdata/')

files = read_tsv('Bradbury_cel_list_iceland.txt')
list = as.list(files)

vector = as.vector(unlist(list))

# dir.create('C:/Users/Matt Brachmann/AxiomSuiteAnalysis/Axiomdata/concat_file')

file.copy(from = vector, 
          to = "C:/Users/Matt Brachmann/AxiomSuiteAnalysis/Axiomdata/Bradbury_cel_files",
          overwrite = T, 
          recursive = F,
          copy.mode = T)

## may need the arr files

arr_files = sed_substitute(files$cel_files,
                           ".CEL", 
                           ".ARR") %>% 
  as_tibble() %>% 
  rename(arr_files = value)

arr_list = as.list(arr_files)
arr_vector = as.vector(unlist(arr_list))

file.copy(from = arr_vector, 
          to = "C:/Users/Matt Brachmann/AxiomSuiteAnalysis/Axiomdata/Bradbury_cel_files",
          overwrite = T, 
          recursive = F, 
          copy.mode = T)
  


# ped file formating -----------------------------------------------------------
setwd('~/PhD/SNP Demographic modelling/Bradbury_paper/')

map = read_tsv('Bradbury_icelandic_samples.map')
header = c('Sample_id', map$`Marker ID`)
unmade_ped = read_tsv('Bradbury_icelandic_samples.ped', 
                      col_names = header)
dim(unmade_ped)
header_ped = unmade_ped[-1,]
# dim(header_ped)

id = header_ped %>% 
  select(Sample_id) %>% 
  arrange(Sample_id)
# dim(id)
write_tsv(id, 'Bradbury_individual_id.txt')
## write the tsv of the custid.

## make the dictionary file so we don't fuck this up
gal_id = read_tsv('Galtabol_dict.txt') %>% 
  arrange(IndividualID)
gal_label = rep('Galtabol', length(gal_id$custid)) %>% 
  as_tibble()
gal_id = bind_cols(gal_id, gal_label)

vatn_id = read_tsv('Vatnshlidarvatn_dict.txt') %>% 
  arrange(IndividualID)
vatn_label = rep('Vatnshlidarvatn', length(vatn_id$custid)) %>% 
  as_tibble()
vatn_id = bind_cols(vatn_id, vatn_label)

thing_id = read_tsv('Thingvallavatn_dict.txt') %>% 
  arrange(IndividualID)
thing_label = rep('Thingvallavatn', length(thing_id$custid)) %>% 
  as_tibble()
thing_id = bind_cols(thing_id, thing_label)

svin_id = read_tsv('Svinavatn_dict.txt') %>% 
  arrange(IndividualID)
svin_label = rep('Svinavatn', length(svin_id$custid)) %>% 
  as_tibble()
svin_id = bind_cols(svin_id, svin_label)

mjoa_id = read_tsv('Mjoavatn_dict.txt') %>% 
  arrange(IndividualID)
mjoa_label = rep('Mjoavatn', length(mjoa_id$custid)) %>% 
  as_tibble()
mjoa_id = bind_cols(mjoa_id, mjoa_label)

flj_id = read_tsv('Fljotaa_dict.txt') %>% 
  arrange(IndividualID)
flj_label = rep('Fljotaa', length(flj_id$custid)) %>% 
  as_tibble()
flj_id = bind_cols(flj_id, flj_label)

dict_id = bind_rows(gal_id, 
               vatn_id)
dict_id = bind_rows(dict_id, thing_id)
dict_id = bind_rows(dict_id, svin_id)
dict_id = bind_rows(dict_id, mjoa_id)
dict_id = bind_rows(dict_id, flj_id) %>% 
  rename(pop = value)

dict_id = mutate(.data = dict_id,
                        `#FamilyID` = as.factor(case_when(
                          pop == 'Galtabol' ~ '1',
                          pop == 'Svinavatn' ~ '2',
                          pop == 'Thingvallavatn' ~ '3',
                          pop == 'Vatnshlidarvatn' ~ '4',
                          pop == 'Mjoavatn' ~ '5',
                          pop == 'Fljotaa' ~ '6')))

dict_id = dict_id %>%
  select(`#FamilyID`, 
         IndividualID,
         sex_from_genotype,
         pop, 
         sample, 
         custid) %>% 
  arrange(custid)

PaternalID = rep(0, length(dict_id$IndividualID)) %>% 
  as_tibble() %>% 
  rename(PaternalID = value)
MaternalID = rep(0, length(dict_id$IndividualID)) %>% 
  as_tibble() %>% 
  rename(MaternalID = value)
Phenotype = rep(0, length(dict_id$IndividualID)) %>% 
  as_tibble() %>% 
  rename(Phenotype = value)

dict_id = bind_cols(dict_id, 
                    PaternalID)
dict_id = bind_cols(dict_id, 
                    MaternalID)
dict_id = bind_cols(dict_id, 
                    Phenotype)

write_csv(dict_id, 
          'Bradbury_genomic_labels.csv')


# make plink input file ---------------------------------------------------
genotypic_labels = read_csv('Bradbury_genomic_labels.csv') %>% 
  arrange(custid)

PED = header_ped %>% 
  arrange(Sample_id)

plink = bind_cols(genotypic_labels, 
                  PED) %>% 
  select(-pop, 
         -sample,
         -custid, 
         -Sample_id) %>% 
  rename(Sex = sex_from_genotype)

write_tsv(plink, 
          'Bradbury_plink_input.ped')
