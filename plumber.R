# plumber.R
# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
# 
#     http://aws.amazon.com/apache2.0/
# 
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

library(aws.signature)
library(aws.s3)
library(tree)
library(colorspace)
library(jsonlite)

# Setup parameters
# Container directories
prefix = "/opt/ml"
bucket.name = "sagemaker-handson-2-<userid>" # PLESAE REPLACE <userid> with YOURID
model.folder = "model"

use_credentials(profile = "handson2", file = file.path(prefix, "credentials"))

# Save model file in S3 to local project
save_object("model.tar.gz", file = "model.tar.gz", bucket = file.path(bucket.name, model.folder))
system("tar -xvzf model.tar.gz")
# Load model file to R project
load("model.Rdata")
summary(model)

#' Ping to show server is there
#' @get /ping
function() {
  return('')
}

#' Parse input and return prediction from model
#' @param req The http request sent
#' @post /invocations
function(req) {
  
  col = fromJSON(req$postBody)
  
  r = col$r
  g = col$g
  b = col$b
  
  lab = as(RGB(r/255, g/255, b/255), "LAB")
  dat = as.data.frame(coords(lab))
  
  result = predict(model, dat)
  result = colnames(result)[which.max(result)]
  
  result
}