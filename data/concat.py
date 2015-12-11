#***************************************************
# This file was used to concat /rev-split into a single
# text file. (Where sentences were from wikipedia 
# http://homepages.inf.ed.ac.uk/kwoodsen/wiki.html
#  All *.old/*.lines files were deleted beforehand
#
#
#***************************************************
import glob

def main():
   read_files = glob.glob("rev-split/*.new")

   with open("result.txt", "wb") as outfile:
      for f in read_files:
	 with open(f, "rb") as infile:
	    outfile.write(infile.read())
   
   print("\n(Done.)")
if __name__ == "__main__":
   main()

