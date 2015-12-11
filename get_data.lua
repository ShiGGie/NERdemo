---------------------------------------
--Get the training data
---------------------------------------
require 'torch'

function get_data()
   -- Must be set in terms of number of word-labels
   --trainSize = 24000
   --testSize = 8000
   local trainSize = 24000

   -- create training data set
   local inputFile = torch.DiskFile('py/train.txt', 'r')
   local inputLine = torch.IntStorage(10)

   dataset = {}
   function dataset:size() return trainSize end

   -------------------------
   --Data is setup as : 
   -- First 10 ints : Indexes to the lookup table (Or basically syncs with hash/embed text files for correct word mebeddings)
   -- Last int : The true label
   -- ---------------------
   for i=1,dataset:size() do 
      --display progress
      --xlua.progress(i, dataset:size())
      
      inputFile:readInt(inputLine)
      local input = torch.Tensor(10)
      for j=1,10 do 
	 input[j] = inputLine[j]
      end

      local index = input[10] + input[9]*10 + input[8]*100 + input[7]*1000 + input[6] * 10000 + input[5] * 100000 + input[4] * 1000000 + input[3] * 10000000 + input[2] * 100000000 + input[1] * 1000000000
      local label = inputFile:readInt()
      local indextensor = torch.Tensor{index}
      local indexlabel = torch.Tensor{label}
      dataset[i] = {indextensor,indexlabel} 
      --
      --Ohmyf. Took forever to figure out {index} is required for Tensor and not index.
      --print(lookupWordT:forward(torch.Tensor{index}))
   end
   inputFile:close()

   return dataset
end

return get_data
