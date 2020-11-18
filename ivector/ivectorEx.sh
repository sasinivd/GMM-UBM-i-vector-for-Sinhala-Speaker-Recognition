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
lda_dim=150
nj=1
exp=exp/ivector_gauss${guss_num}_dim${ivector_dim}
homePath=/home/sasini/Ucsc
set -e # exit on error


#train ivector
sid/train_ivector_extractor.sh --cmd "$train_cmd" \
  --ivector-dim $ivector_dim --num-iters 5 $exp/full_ubm/final.ubm data/train \
  $exp/extractor

###### Bookmark: i-vector extraction ######
#extract train ivector
sid/extract_ivectors.sh --cmd "$train_cmd" --nj $nj \
  $exp/extractor data/train $exp/ivector_train
#extract enroll ivector
sid/extract_ivectors.sh --cmd "$train_cmd" --nj $nj \
  $exp/extractor data/test/enroll  $exp/ivector_enroll
#extract eval ivector
sid/extract_ivectors.sh --cmd "$train_cmd" --nj $nj \
  $exp/extractor data/test/eval  $exp/ivector_eval



exit 0
