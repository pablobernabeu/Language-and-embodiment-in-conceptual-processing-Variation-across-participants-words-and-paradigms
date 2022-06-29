

# Part of Study 1: Semantic priming

# Convergence diagnostics

# Following Brauer and Curtin (2018), avoid removing random slopes to prevent an inflation of the Type I error rate.
# As a sanity check, refit mixed-effects model with several optimizers. This check is done by comparing the results 
# from these optimizers. If they are similar, especially for the fixed effects, then the results are likely valid,
# even in the presence of convergence warnings (see https://cran.r-project.org/web/packages/lme4/lme4.pdf).

library(dplyr)  # Data wrangling
library(dfoptim)  # Refit model with various optimizers using lme4::allFit()
library(optimx)  # Refit model with various optimizers using lme4::allFit()
library(lme4)   # Main analysis and adjustment of effect labels
library(parallel)   # Allow parallel processing using several cores

# Data set below created in the script 'semanticpriming_data_preparation.R',
# which is stored in the folder 'semanticpriming/data'
semanticpriming = 
  read.csv('semanticpriming/data/final_dataset/semanticpriming.csv')

# Model below created in the script 'semanticpriming_lmerTest.R', which
# is stored in the folder 'semanticpriming/power_analysis/model'
semanticpriming_lmerTest = 
  readRDS('semanticpriming/power_analysis/model/results/semanticpriming_lmerTest.rds')

allFit(semanticpriming_lmerTest, 
       
       # Set maximum iterations to 1m to facilitate convergence 
       # (Brauer & Curtin, 2018; Singmann & Kellen, 2019)
       maxfun = 1e6,
       
       # Use 7 cores in parallel for faster computation
       ncpus = 7) %>%
  
  # Save
  saveRDS('semanticpriming/model/model_diagnostics/results/semanticpriming_allFit_convergence.rds')

# Load the result back in, if needed later
semanticpriming_allFit_convergence =
  readRDS('semanticpriming/model/model_diagnostics/results/semanticpriming_allFit_convergence.rds')

# Load function to plot fixed effects across different optimizers
source('R_functions/plot.fixef.allFit.R')

# Main effects
(
  plot.fixef.allFit(semanticpriming_allFit_convergence, 
                    select_predictors = c('z_target_word_frequency',
                                          'z_target_number_syllables',
                                          'z_word_concreteness_diff',
                                          'z_attentional_control',
                                          'z_vocabulary_size',
                                          'z_recoded_participant_gender',
                                          'z_cosine_similarity',
                                          'z_visual_rating_diff',
                                          'z_recoded_interstimulus_interval'),
                    y_title = 'Effect size (Predicted RT (*z*)beta;)',
                    decimal_points = 2, multiply_y_axis_limits = 1.3) +
    theme(plot.margin = margin(15, 15, 15, 15))
) %>%
  # Save plot
  ggsave(filename = 'semanticpriming/model/model_diagnostics/plots/main_effects_semanticpriming_allFit_convergence.pdf', 
         device = cairo_pdf, width = 9, height = 10.5, dpi = 900)

# Interactions
(
  plot.fixef.allFit(semanticpriming_allFit_convergence, 
                    select_predictors = c('z_word_concreteness_diff:z_vocabulary_size',
                                          'z_word_concreteness_diff:z_recoded_interstimulus_interval',
                                          'z_word_concreteness_diff:z_recoded_participant_gender',
                                          'z_attentional_control:z_cosine_similarity',
                                          'z_attentional_control:z_visual_rating_diff',
                                          'z_vocabulary_size:z_cosine_similarity',
                                          'z_vocabulary_size:z_visual_rating_diff',
                                          'z_recoded_participant_gender:z_cosine_similarity',
                                          'z_recoded_participant_gender:z_visual_rating_diff',
                                          'z_recoded_interstimulus_interval:z_cosine_similarity',
                                          'z_recoded_interstimulus_interval:z_visual_rating_diff'),
                    y_title = 'Effect size (Predicted RT (*z*)beta;)',
                    decimal_points = 3, multiply_y_axis_limits = 1.3) +
    theme(plot.margin = margin(15, 15, 15, 15))
) %>%
  # Save plot
  ggsave(filename = 'semanticpriming/model/model_diagnostics/plots/interactions_semanticpriming_allFit_convergence.pdf', 
         device = cairo_pdf, width = 9, height = 11.6, dpi = 900)

# Free up some memory
rm(semanticpriming_allFit_convergence)

