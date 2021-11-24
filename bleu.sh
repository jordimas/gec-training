srcModelName=${PWD##*/}
regex='([a-z]{3})-([a-z]{3})'
[[ $srcModelName =~ $regex ]]
srcLanguage=${BASH_REMATCH[1]}
tgtLanguage=${BASH_REMATCH[2]}

# test data set
echo "Test data set" > bleu.txt
onmt-main --config data.yml --auto_config infer --features_file src-test.txt.token > predictions.txt.token
perl ../multi-bleu.perl tgt-test.txt.token < predictions.txt.token 
python3 ../sentencepiece-bleu.py
perl ../multi-bleu.perl tgt-test.txt < predictions.txt >> bleu.txt
sacrebleu tgt-test.txt -i predictions.txt -m bleu >> bleu.txt

# Gleu
../../../gec-training/gleu/compute_gleu -s src-test.txt -r tgt-test.txt -o predictions.txt
cat bleu.txt
