#### Execution


Run using 
cd /torch-implementation
./th -i main.lua


#### Data

All Raw data used is public domain. So they can be distributed -
however they are not included to save space in the handin.

Wikipedia revisions: http://homepages.inf.ed.ac.uk/kwoodsen/wiki.html
Word embeddings+hash: http://ronan.collobert.com/senna/



#### Known Issues

- The ending feature vector is length 4 on purpose (at the time), since this was an experimental approach (The ending results weren't significant (~80%), as you can see). Feel free to fix that and get better results.


####  Optional: Generating your own data

This comes with all of the scripts used to generate my own data
To do so, you require the NER system
created from http://nlp.stanford.edu/software/CRF-NER.shtml

---This is because data used for NLP -- and NER -- is either expensive (in the $000s) or
require an application to NIST with permission from supervisor. We have to be
creative and generate our own training/test data. For the sake of a working demo, the labelled
through these means are adequate.

1. Download http://homepages.inf.ed.ac.uk/kwoodsen/wiki.html
   Place the rev-split folder in the /data folder 
3. Run concat.py (You may need to filter out some punctuation after)
3. Download http://nlp.stanford.edu/software/CRF-NER.shtml
4. Retreive the results.txt (what was concat) and place it
   in the same location as the stanford jars
   Then run:  (receives input.txt)
   java -mx500m -cp stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier
   classifiers/english.all.3class.distsim.crf.ser.gz -textFile input.txt -outputFormat tsv > output.txt
   NOTE: This requires java 1.8. Detailed instructions http://nlp.stanford.edu/software/crf-faq.shtml.

5. Obtain the resulting output.txt and place it in the /data folder
6. Download http://ronan.collobert.com/senna/
   Place hash and embeddings folder in the same /dir as .py files
7. Run generateData.py
      Make sure it sees /embedding /hash and the corresponding files
      NOTE* This step is LONG. It takes takes about ~2> hours to generate the data.
      (Essentially we are filtering the embeddings to only have words that we have)

      NOTE* The file obtained will be contiguous ints. I ran a vim command to
      add a whitepsace between each int. This is REQUIRED. 

7. After obtaining data.txt (as welll as embedded.txt/hash.txt) 
   split data.txt into train.txt and test.txt. The ratio is often 1:3 


####  Installing Torch
Easy way: https://github.com/torch/distro
Detailed way: https://github.com/nagadomi/waifu2x


####  LUARocks Packages
LUA luajit LUAROCKS should be downloaded with your Torch.
There are many package dependencies for torch files, and I did not kepe track of them

If you run into dependency issues, look for the missing file/symbol error.
If there's lua.51 folder in that error, then you're missing a package.
Check /lua51/__NAME__ for package name then type

   luarocks install __NAME__


-------------------------
NERdemo
-------------------------
This was a helpful start into torch and NER (learning purposes). This is a different approach and structure than the ones generally introduced by the other well-formatted demos. Highly recommended to not deploy in any setting.

Tested on Ubuntu 14.04
