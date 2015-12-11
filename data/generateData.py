#!/usr/bin/python

import sys
import os
import re
import string

def isNotEmpty(s):
   if s is None or s == '':
      return False
   else:
      return True

def convertlabels(label):
   newlabel = 0
   if label == 'O':
      newlabel = 1
   elif label == 'ORGANIZATION':
      newlabel = 2
   elif label == 'PERSON':
      newlabel = 3
   elif label == 'LOCATION':
      newlabel = 4
   return newlabel

#Filter, convert data to readable format.
def createNERData():
   fhash = open('./hash/words.lst')
   fembed = open('./embeddings/embeddings.txt')
   f_hash = open('./hash.txt','w')
   f_embed = open('./embed.txt','w')
   f_data = open('./data.txt','w')
   fhash.seek(0)
   fembed.seek(0)
   counter = 1
   
   dict = {}
   exclude = set(string.punctuation)

   with open('labels.txt','r') as flabels:
      for labelline in flabels:
	 if not labelline.isspace():
	    lword = labelline.split()
	    lword[0] = lword[0].strip().lower()
	    lword[1] = lword[1].strip()

	    lword[0] = ''.join(ch for ch in lword[0] if ch not in exclude)
	    if lword[0] is None or lword[0].isspace():
	       continue
	    if dict.has_key(lword[0]):
	       continue
	    dict[lword[0]] = 1 #for collision detection, want unique 
	    

	    #Look for word in hash
	    print "---------{},{}".format(lword[0],lword[1])
	    found = False
	    for hline in fhash:
	       eline = fembed.readline() # same line position
	       expr = lword[0]+'[\\W]'
	       boo = re.match(expr,hline)
	       #loss of information: Only finds one match, and does not account for other matches with punc.
	       if boo:
		  found = True
		  break

	    #insert to file if found
	    if found:
		  newlabel = convertlabels(lword[1])

		  id = str(counter)
		  f_embed.write(eline)
		  f_hash.write(hline)
		  f_data.write(id.zfill(10) + str(newlabel) + '\n')

		  counter = counter + 1
		  if counter > 1000000000:
		     break

	    fhash.seek(0)
	    fembed.seek(0)

   fhash.close()
   fembed.close()
   f_hash.close()
   f_embed.close()
   f_data.close()

	       
def main():
      createNERData()
      print("\n(Done.)")

if __name__ == "__main__":
      main()

