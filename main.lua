-- JX 7694754
--
--Set this to 1 if you're impatient:
-- trainer.maxIteration = 25 
---------------------------------------
--Main
---------------------------------------
require 'torch'
require 'math'
require 'nn'

get_model = require 'get_model'
get_data = require 'get_data'

----------------------------------------------------
-- create/train a model and perform gradient descent 
----------------------------------------------------

local model, criterion = get_model()
local dataset = get_data()

local trainer = nn.StochasticGradient(model, criterion)
trainer.learningRate = 1e-1
trainer.momentum = 0.1
trainer.maxIteration = 100

trainer:train(dataset)

---------------------------------------
--Testing
---------------------------------------
local testSize = 8000
local testFile = torch.DiskFile('py/test.txt', 'r')
local result = torch.Tensor(testSize,4)
local averageresult = torch.Tensor(testSize,1)
--For testing, set model to eval
model:evaluate()

err = 0
local inputLine = torch.IntStorage(10)
for i=1,testSize do 
   --xlua.progress(i, testSize)
   testFile:readInt(inputLine)
   local input = torch.Tensor(10)
   for j=1,10 do 
      input[j] = inputLine[j]
   end

   local index = input[10] + input[9]*10 + input[8]*100 + input[7]*1000 + input[6] * 10000 + input[5] * 100000 + input[4] * 1000000 + input[3] * 10000000 + input[2] * 100000000 + input[1] * 1000000000
   local label = testFile:readInt()
   local indextensor = torch.Tensor{index}

   --1x4 tensor
   local pred = model:forward(indextensor)
   result[i] = pred
   local entityLabel = 1
   local thresholdValue = -1000000
   for k=1,4 do
      -- Some really crappy classifying 
      -- 1 = Other, 2 = Organization, 3 = Person, 4 = Location
      if result[i][k] > thresholdValue then
	 entityLabel = k
	 thresholdValue = result[i][k]
      end
   end

   --Check errors..
   local err1 = 0
   if (label - entityLabel) > 0 then
      err1 = 1
   end
   err = err + err1
end

print(result)
print('^^^ Classifier vectors ^^^')
print('Total error:' .. err)
print('Average Error Per Word:' .. err/testSize)

testFile:close()
