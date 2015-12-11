---------------------------------------
--Create the model/criterion
---------------------------------------
require 'torch'
require 'nn'
--require 'optim'   -- an optimization package, for online and batch methods

function get_model()

   local lookupWordT = nn.LookupTable(36000,50) -- Obtain row for given index when called with :forward
   --lookupOurW = nn.LookupTable(4,1) -- Obtain row for given index when called with :forward
   --lookupOurW.weight = torch.Tensor(4):fill(0.25)

   -- initialize lookup table with filtered embeddings from SENNA (http://ronan.collobert.com/senna/)
   local embeddingsFile = torch.DiskFile('py/emb.txt')
   local embedding = torch.DoubleStorage(50)
   embeddingsFile:readDouble(embedding)
   for i=1,36000 do 
      embeddingsFile:readDouble(embedding)
      local emb = torch.Tensor(50)
      for j=1,50 do 
	 emb[j] = embedding[j]
      end
      lookupWordT.weight[i] = emb
   end

   ------------------------------------------------------------------------------
   -- MODEL
   ------------------------------------------------------------------------------
   local model = nn.Sequential()
   local ninputs = 50
   local nhiddenlayers = 25
   local noutputs = 4 --4 classes

   -- Standard two-layer neural network. 250 parameter linear function is applied to form 125 outputs.
   model:add(lookupWordT)
   model:add(nn.Reshape(ninputs)) --extraneous only required for parallel/join table
   model:add(nn.Linear(ninputs,nhiddenlayers))
   model:add(nn.HardTanh()) -- The 125 outputs get converted into signals. Up to you to choose ReLU and non-linearity friends
   model:add(nn.Linear(nhiddenlayers,noutputs)) -- Outputs get transformed to classifier vector.
   model:add(nn.LogSoftMax()) -- a softmax is applied, ready for criterion function


  ------------------------------------------------------------------------------
  -- LOSS FUNCTION
  ------------------------------------------------------------------------------
  --mlp:add(nn.Euclidean(n, m)) -- outputs a vector of distances
  --mlp:add(nn.MulConstant(-1)) -- distance to similarity
  --criterion = nn.MultiLabelMarginCriterion()
  local criterion = nn.ClassNLLCriterion()

  return model, criterion
end

return get_model


   --pairedT = nn.ParallelTable() -- The inputs go through two different layers IN PARALLEL
   --pairedT:add(lookupWordT) -- to dim 50 For our words
   --pairedT:add(lookupOurW) -- to dim 5 For our labels
   --model:add(pairedT)

   -- Each word repr[50] is joined with our own weights[1] for specialized NER
   -- 50*5 (Our dimensions from lookup table) Reshaped to a 1D tensor, for further processing
   --joinedT = nn.JoinTable(2) 
   --
