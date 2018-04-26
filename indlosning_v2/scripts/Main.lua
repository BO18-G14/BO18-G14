
-------------------- BO18-G14 box counting based on size ------------------------------------
--
--  Application for counting boxes based on the detected areal / dimension of each box in correlation with the
-- calibrated heigh for each level. Each box is marked with a black outlined square on a mat surface
--
-- Developed by Melvin L and Mathias G.


-- Declaration for different colored squares to visualy idenify the boxes from each level to end user.
local Level1 = View.ShapeDecoration.create()
Level1:setLineColor(255,0,127)
Level1:setLineWidth(4)           -- Wine Red

local Level2 = View.ShapeDecoration.create()
Level2:setLineColor(255,0,255)
Level2:setLineWidth(4)            -- Pink

local Level3 = View.ShapeDecoration.create()
Level3:setLineColor(127,0,255)
Level3:setLineWidth(4)             -- Purple

local Level4 = View.ShapeDecoration.create()
Level4:setLineColor(0,0,255)
Level4:setLineWidth(4)             -- Blue

local Level5 = View.ShapeDecoration.create()
Level5:setLineColor(0,255,255)
Level5:setLineWidth(4)             -- Light Blue

local Level6 = View.ShapeDecoration.create()
Level6:setLineColor(0,255,0)
Level6:setLineWidth(4)             -- Green

local Level7 = View.ShapeDecoration.create()
Level7:setLineColor(128,255,0)
Level7:setLineWidth(4)             -- Light Green

local Level8 = View.ShapeDecoration.create()
Level8:setLineColor(255,255,0)
Level8:setLineWidth(4)            -- Yellow

local Level9 = View.ShapeDecoration.create()
Level9:setLineColor(255,128,0)
Level9:setLineWidth(4)             -- Orange

local Level10 = View.ShapeDecoration.create()
Level10:setLineColor(255,0,0)
Level10:setLineWidth(4)             -- Red

local ResultTextVisual = View.ShapeDecoration.create()
ResultTextVisual:setLineColor(0,255,0)        -- Green

local ResultText = Text.create()

--Global variables needed
local Level1Offset,Level2Offset,Level3Offset,Level4Offset,Level5Offset,Level6Offset,Level7Offset,Level8Offset,Level9Offset,Level10Offset
local Level1Blobs,Level2Blobs,Level3Blobs,Level4Blobs,Level5Blobs,Level6Blobs,Level7Blobs,Level8Blobs,Level9Blobs,Level10Blobs
local BaseHeightMin,BaseHeightMax
local viewer = View.create()

-- Create and configure camera
camera = Image.Provider.Camera.create()

config = Image.Provider.Camera.V2DConfig.create()
config:setBurstLength(0)     -- Continuous acquisition
config:setFrameRate(1)      -- Framerate in Hz
config:setShutterTime(800)   -- Shutter time in us 
config:setIntLight("OFF") -- Turn of the built in LED light (Currently out of order)

camera:setConfig(config)
-------------------------------------

-- Main function / start
local function main()

   -- Enable the on-board camera and take a snapshot
  camera:enable()
  
  print("Snapping photo.")
  camera:snapshot()
end


 -- Function trigged after camera snapshot event
function processImage(im, sensorData)

  --Push the raw  image to the end-user 
  viewer:view(im)
  local img = im
  
  -- Set image data threshold
  img = img:binarize(6,33)
  
  -- Display binarized image
  viewer:add(img)
  

  BaseMargin = 0.9
 
 -- Set pre-calibrated box dimensions
  BaseHeightMax = 62.75 + BaseMargin
  BaseHeightMin = 62.75 - BaseMargin
  
  Level1Offset = BaseHeightMax/BaseHeightMax
  Level2Offset = 1.04
  Level3Offset = 1.08
  Level4Offset = 1.12
  Level5Offset = 1.17
  Level6Offset = 1.22
  Level7Offset = 1.28
  Level8Offset = 1.34
  Level9Offset = 1.41
  Level10Offset = 1.49
  
  --Reset local variables for box counting
  Level1Blobs = 0
  Level2Blobs = 0 
  Level3Blobs = 0
  Level4Blobs = 0
  Level5Blobs = 0
  Level6Blobs = 0
  Level7Blobs = 0
  Level8Blobs = 0
  Level9Blobs = 0
  Level10Blobs = 0
  
  BoxCount = 0

  
  
  -- Locate blobs / objects in the picture. 
  local objectRegion = img:threshold(0,150)
  local blobs = objectRegion:findConnected(100)
  
  -- Analyzing each blob
  for i = 1, #blobs do
    
    --Extract features from blobs
    local feature = Image.PixelRegion.getElongation(blobs[i],img)
    local box = Image.PixelRegion.getBoundingBoxOriented(blobs[i],img)
    local center, width, height, rotation = box:getRectangleParameters()
    
    -- If the blob dimension qualifies as a square 
    if width/height > 0.75 and width/height < 1.25 then
   
    
    --Identify level 1 blobs
    if height<BaseHeightMax and height>BaseHeightMin then 
      viewer:add(box,Level1)
      Level1Blobs = Level1Blobs + 1
    end
    
   
    --Identify level 2 blobs
    if height<(BaseHeightMax*Level2Offset) and height>(BaseHeightMin*Level2Offset) then 
      viewer:add(box,Level2)
      Level2Blobs = Level2Blobs + 1
    end
   

    --Identify level 3 blobs
    if height<(BaseHeightMax*Level3Offset) and height>(BaseHeightMin*Level3Offset) then
      viewer:add(box,Level3)
      Level3Blobs = Level3Blobs + 1
    end
    
    --Identify level 4 blobs
    if height<(BaseHeightMax*Level4Offset) and height>(BaseHeightMin*Level4Offset) then
      viewer:add(box,Level4)
      Level4Blobs = Level4Blobs + 1
    end
    
    --Identify level 5 blobs
    if height<(BaseHeightMax*Level5Offset) and height>(BaseHeightMin*Level5Offset) then
      viewer:add(box,Level5)
      Level5Blobs = Level5Blobs + 1
    end
    
     --Identify level 6 blobs
    if height<(BaseHeightMax*Level6Offset) and height>(BaseHeightMin*Level6Offset) then
      viewer:add(box,Level6)
      Level6Blobs = Level6Blobs + 1
    end
    
     --Identify level 7 blobs
    if height<(BaseHeightMax*Level7Offset) and height>(BaseHeightMin*Level7Offset) then
      viewer:add(box,Level7)
      Level7Blobs = Level7Blobs + 1
    end
    
    
     --Identify level 8 blobs
    if height<(BaseHeightMax*Level8Offset) and height>(BaseHeightMin*Level8Offset) then
      viewer:add(box,Level8)
      Level8Blobs = Level8Blobs + 1
    end

     --Identify level 9 blobs
    if height<(BaseHeightMax*Level9Offset) and height>(BaseHeightMin*Level9Offset) then
      viewer:add(box,Level9)
      Level9Blobs = Level9Blobs + 1
    end
   
  
     --Identify level 10 blobs
    if height<(BaseHeightMax*Level10Offset) and height>(BaseHeightMin*Level10Offset) then
      viewer:add(box,Level10)
      Level10Blobs = Level10Blobs + 1
    end
  end
  
   --Calculate amount of boxses found on each level
     BoxCount = (Level10Blobs * 10) + (Level9Blobs * 9) + (Level8Blobs * 8) + (Level7Blobs * 7) + (Level6Blobs * 6) + (Level5Blobs * 5) + (Level4Blobs * 4) + (Level3Blobs * 3) + (Level2Blobs * 2) + (Level1Blobs * 1)
     
   -- Mainly for debug / calibration purposes   
     print("Antall level 1 " , Level1Blobs)
     print("Antall level 2 " , Level2Blobs)
     print("Antall level 3 " , Level3Blobs)
     print("Antall level 4 " , Level4Blobs)
     print("Antall level 5 " , Level5Blobs)
     print("Antall level 6 " , Level6Blobs)
     print("Antall level 7 " , Level7Blobs)
     print("Antall level 8 " , Level8Blobs)
     print("Antall level 9 " , Level9Blobs)
     print("Antall level 10 " , Level10Blobs)
     print("Vi fant " , BoxCount , " esker")
     
     
  -- Prepare result to end user
     ResultText:setText("Antall esker = "..BoxCount)
     ResultText:setPosition(30,30)
     Text.setSize(ResultText, 50)
     viewer:add(ResultText, ResultTextVisual)
     
    end
    
    
  --Display results  
  viewer:present()
  
  Script.sleep(5000)
  
  
  print("Snapping photo.")
  camera:snapshot()
end

--Trigger events for main and camera snapshot
Script.register("Engine.OnStarted", main)
camera:register("OnNewImage", processImage)

