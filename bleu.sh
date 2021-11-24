srcModelName=${PWD##*/}
regex='([a-z]{3})-([a-z]{3})'
[[ $srcModelName =~ $regex ]]
srcLanguage=${BASH_REMATCH[1]}
tgtLanguage=${BASH_REMATCH[2]}

# test data set
onmt-main --config data.yml --auto_config infer --features_file src-test.txt.token > predictions.txt.token
#perl ../multi-bleu.perl tgt-test.txt.token < predictions.txt.token 
python3 ../sentencepiece-bleu.py
echo "multi-bleu.perl" > bleu.txt
perl ../multi-bleu.perl tgt-test.txt < predictions.txt >> bleu.txt
echo "sacrebleu" >> bleu.txt
sacrebleu tgt-test.txt -i predictions.txt -m bleu >> bleu.txt
# Gleu
echo "GLEU" >> bleu.txt
../../../gec-training/gleu/compute_gleu -s src-test.txt -r tgt-test.txt -o predictions.txt >> bleu.txt
cat bleu.txt
