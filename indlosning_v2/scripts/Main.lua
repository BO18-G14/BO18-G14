
-------------------- BO18-G14  Calibration ------------------------------------
---
--
-- Main sample for counting boxes based on the detected areal / size and height placement.
--
--




--Start of Global Scope--------------------------------------------------------

local Level1 = View.ShapeDecoration.create()
Level1:setLineColor(0,0,255)
Level1:setLineWidth(4)           -- Blue

local Level2 = View.ShapeDecoration.create()
Level2:setLineColor(255,0,0)
Level2:setLineWidth(4)            -- Red

local Level3 = View.ShapeDecoration.create()
Level3:setLineColor(0,255,0)
Level3:setLineWidth(4)             -- Green

local Level4 = View.ShapeDecoration.create()
Level4:setLineColor(255,255,0)
Level4:setLineWidth(4)             -- Yellow

local Level5 = View.ShapeDecoration.create()
Level5:setLineColor(255,128,0)
Level5:setLineWidth(4)             -- Orange

local Level6 = View.ShapeDecoration.create()
Level6:setLineColor(128,0,128)
Level6:setLineWidth(4)             -- Purple

local Level7 = View.ShapeDecoration.create()
Level7:setLineColor(128,64,0)
Level7:setLineWidth(4)             -- Brown

local Level8 = View.ShapeDecoration.create()
Level8:setLineColor(255,0,128)
Level8:setLineWidth(4)             -- Pink

local Level9 = View.ShapeDecoration.create()
Level9:setLineColor(255,255,255)
Level9:setLineWidth(4)             -- White

local Level10 = View.ShapeDecoration.create()
Level10:setLineColor(0,0,0)
Level10:setLineWidth(4)             -- Black

local ResultText = Text.create()

--Decleration of global varibals necessery for calucaltion
local Level1Offset,Level2Offset,Level3Offset,Level4Offset,Level5Offset
local BaseLevel1Height,BaseLevel2Height,BaseLevel3Height,BaseLevel4Height,BaseLevel5Height
local Level1Blobs,Level2Blobs,Level3Blobs,Level4Blobs,Level5Blobs,Level6Blobs,Level7Blobs
local Level8Blobs,Level9Blobs,Level10Blobs,BaseHeightMin,BaseHeightMax

-- Defination of the "view" interface for end-user
local viewer = View.create()

-- Create and configure camera
camera = Image.Provider.Camera.create()

config = Image.Provider.Camera.V2DConfig.create()
config:setBurstLength(0)     -- Continuous acquisition
config:setFrameRate(1)      -- Hz
config:setShutterTime(1000)   -- us

camera:setConfig(config)
-------------------------------------

--End of Global Scope----------------------------------------------------------- 


--Start of Function and Event Scope---------------------------------------------

-- Snap photo for processing. 
local function main()
  camera:enable()
  print("Snapping photo.")
  camera:snapshot()
  print("App finished.")
end


 -- Function trigged trought camera snapshot event
function processImage(im, sensorData)

  --Set image to view for user
  viewer:view(im)
  local img = im
  
  -- Binarize image for data-extraction 
  img = img:binarize(7,33)

  -- Display binarized image
  viewer:add(img)
  

  BaseMargin = 1.7
 
  BaseLevel1Height = 59
  BaseLevel2Height = 64
  BaseLevel3Height = 68
  BaseLevel4Height = 73
  BaseLevel5Height = 77
 
 -- Set's pre-calibrated box dimensions
  BaseHeightMax = 59 + BaseMargin
  BaseHeightMin = 59 - BaseMargin
  
  
--Resets local variables for box counting
  Level1Offset = BaseHeightMax/BaseHeightMax
  Level2Offset = 1.08
  Level3Offset = 1.15
  Level4Offset = 1.24
  Level5Offset = 1.32
  
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
  
  antallesker = 0

  
  
  -- Finding blobs / box
  local objectRegion = img:threshold(0,150)
  local blobs = objectRegion:findConnected(100)
  
  -- Analyzing each blob and visualizing the result  
  for i = 1, #blobs do
    
    --Locate features / blobs
    local feature = Image.PixelRegion.getElongation(blobs[i],img)
    local box = Image.PixelRegion.getBoundingBoxOriented(blobs[i],img)
    local center, width, height, rotation = box:getRectangleParameters()
    
    -- If the blob dimension qulaifies as a square box
    if width/height > 0.85 and width/height < 1.15 then
    
    --For debug
    print("We found box")
    print(height)
    
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
   
    print("---Level 3 ---- " .. Level3Offset)
    print("om " .. height.. " < " .. BaseHeightMax * Level3Offset)
    print("om " .. height.. " > " .. BaseHeightMin * Level3Offset)
    
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
   
    
     --Calculate amount of boxses found
     antallesker = (Level10Blobs * 10) + (Level9Blobs * 9) + (Level8Blobs * 8) + (Level7Blobs * 7) + (Level6Blobs * 6) + (Level5Blobs * 5) + (Level4Blobs * 4) + (Level3Blobs * 3) + (Level2Blobs * 2) + (Level1Blobs * 1)
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
     print("Vi fant " , antallesker , " esker")
     
     ResultText:setText("Antall esker = "..antallesker)
     ResultText:setPosition(30,30)
     Text.setSize(ResultText, 50)
     viewer:add(ResultText, textDecoration)
    end
    
    
  end
  --Display results  
  viewer:present()
  
end

--Trigger events for main and camera snapshot
Script.register("Engine.OnStarted", main)
camera:register("OnNewImage", processImage)

--End of Function and Event Scope-------------------------------------------------- 