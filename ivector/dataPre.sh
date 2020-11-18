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



guss_num=512
ivector_dim=200
lda_dim=50
nj=1
exp=exp/ivector_gauss${guss_num}_dim${ivector_dim}
homePath=/home/sasini/Ucsc
set -e # exit on error

####### Bookmark: scp prep #######

#local/timit_data_prep.sh $homePath/Research/ASR_DATA/mymodel/AISH
#local/data_prep.sh $homePath/Research/ASR_DATA/mymodel/train data/local/train data/train
local/data_prep.sh $homePath/Research/ASR_DATA/mymodel/testex data/local/test data/test

###### Bookmark: MFCC extraction ######

mfccdir=mfcc
for x in test; do
  steps/make_mfcc.sh --cmd "$train_cmd" --nj $nj data/$x exp/make_mfcc/$x $mfccdir
  sid/compute_vad_decision.sh --nj $nj --cmd "$train_cmd" data/$x exp/make_mfcc/$x $mfccdir
  utils/fix_data_dir.sh data/$x
done

###### Bookmark: split the test to enroll and eval ######
mkdir -p data/test/enroll data/test/eval
cp data/test/{spk2utt,feats.scp,vad.scp} data/test/enroll
cp data/test/{spk2utt,feats.scp,vad.scp} data/test/eval
local/split_data_enroll_eval.py data/test/utt2spk  data/test/enroll/utt2spk  data/test/eval/utt2spk
trials=data/test/test.trials
local/produce_trials.py data/test/eval/utt2spk $trials
utils/fix_data_dir.sh data/test/enroll
utils/fix_data_dir.sh data/test/eval


exit 0
