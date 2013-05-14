#! /bin/bash
#
#  init.sh
#  create ios project dir like rails dir
#
#  Created by sang alfred on 3/6/13.
#  Copyright (c) 2013 no320.com. All rights reserved.
# 

# ➜  test git:(master) ✗ ls
# app    config db     doc    log    script test   vendor
# ➜  test git:(master) ✗ ls -R
# app    config db     doc    log    script test   vendor
# 
# ./app:
# assets      controllers helpers     models      views
# 
# ./app/assets:
# images
# 
# ./app/assets/images:
# 
# ./app/controllers:
# 
# ./app/helpers:
# 
# ./app/models:
# 
# ./app/views:
# 
# ./config:
# environments initializers locales
# 
# ./config/environments:
# 
# ./config/initializers:
# 
# ./config/locales:
# 
# ./db:
# 
# ./doc:
# 
# ./log:
# 
# ./script:
# 
# ./test:
# 
# ./vendor:
#
#
#
#

mkdir -p src/app/assets/images
mkdir -p src/app/assets/xibs 	#new
mkdir -p src/app/assets/bundles #new
mkdir -p src/app/controllers 
mkdir -p src/app/boards 		#new 
mkdir -p src/app/messages  		#new 
mkdir -p src/app/helpers        
mkdir -p src/app/models      
mkdir -p src/app/views
mkdir -p src/app/apis

mkdir src/db
mkdir src/doc
mkdir src/log
mkdir src/test
mkdir src/script
mkdir src/server

mkdir -p src/config/environments
mkdir -p src/config/initializers
mkdir -p src/config/locales

sqlite3 src/db/sina_finance_ios.db ""

mkdir vendor

touch README.md

mkdir test