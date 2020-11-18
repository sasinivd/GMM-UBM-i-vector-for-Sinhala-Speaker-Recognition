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



guss_num=256
ivector_dim=200
lda_dim=50
nj=1
exp=exp/ivector_gauss${guss_num}_dim${ivector_dim}
homePath=/home/sasini/Ucsc
set -e # exit on error



###### Bookmark: i-vector train ######
# train diag ubm
sid/train_diag_ubm.sh --nj $nj --cmd "$train_cmd" --num-threads 16 \
  data/train $guss_num $exp/diag_ubm
#train full ubm
sid/train_full_ubm.sh --nj $nj --cmd "$train_cmd" data/train \
  $exp/diag_ubm $exp/full_ubm



exit 0
