#!/bin/bash
# Copyright 2017 Beijing Shell Shell Tech. Co. Ltd. (Authors: Hui Bu)
#           2017 Jiayu Du
#           2017 Chao Li
#           2017 Xingyu Na
#           2017 Bengu Wu
#           2017 Hao Zheng
# Apache 2.0

# This is a shell script that we demonstrate speech recognition using AIShell-1 data.
# it's recommended that you run the commands one by one by copying and pasting into the shell.
# See README.txt for more info on data required.
# Results (EER) are inline in comments below

. ./cmd.sh
. ./path.sh



guss_num=2048
ivector_dim=200
lda_dim=100
nj=1
exp=exp/ivector_gauss${guss_num}_dim${ivector_dim}
homePath=/home/sasini/Ucsc
trials=data/test/test.trials
set -e # exit on error



###### Bookmark: scoring ######

# basic cosine scoring on i-vectors
local/cosine_scoring.sh data/test/enroll data/test/eval \
  $exp/ivector_enroll $exp/ivector_eval $trials $exp/scores

# cosine scoring after reducing the i-vector dim with LDA
local/lda_scoring.sh data/train data/test/enroll data/test/eval \
  $exp/ivector_train $exp/ivector_enroll $exp/ivector_eval $trials $exp/scores $lda_dim

# cosine scoring after reducing the i-vector dim with PLDA
local/plda_scoring.sh data/train data/test/enroll data/test/eval \
  $exp/ivector_train $exp/ivector_enroll $exp/ivector_eval $trials $exp/scores

# print eer
for i in cosine lda plda; do
  eer=`compute-eer <(python local/prepare_for_eer.py $trials $exp/scores/${i}_scores) 2> /dev/null`
  printf "%15s %5.2f \n" "$i eer:" $eer
done > $exp/scores/results.txt

cat $exp/scores/results.txt

exit 0
