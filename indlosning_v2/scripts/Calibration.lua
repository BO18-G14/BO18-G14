-------------------- BO18-G14  Calibration ------------------------------------
---
--
-- Calibration coded used to define values for each level of boxes
--
--


--Start of Global Scope--------------------------------------------------------
local Level = View.ShapeDecoration.create()
Level:setLineColor(0,0,255)
Level:setLineWidth(4)       

local viewer = View.create()

camera = Image.Provider.Camera.create()
config = Image.Provider.Camera.V2DConfig.create()

config:setBurstLength(0)     -- Continuous acquisition
config:setFrameRate(1)      -- Hz
config:setShutterTime(1000)   -- us


camera:setConfig(config)
-------------------------------------

--End of Global Scope----------------------------------------------------------- 


--Start of Function and Event Scope---------------------------------------------

-- Looping through the functions
local function main()

---Create and enable laser for easy camera placment
aimingLaser = AimingLight.create()
aimingLaser:activate()

 --- aimingLaser:deactivate()
print("App finished.")

-- Create and configure camera
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
  
  -- Set images data threshold
  img = img:binarize(6,22)

  
  -- Display binarized image
  viewer:add(img)

  
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
  if height/width > 0.8 and height/width < 1.2 then
  
    print("We found box")
    print(height.. " - "..width .. "Ratio: " .. height/width ) 
    viewer:add(box,Level)

  end
    
  end
  
  --Display results  
  viewer:present()
  
end

--Trigger events for main and camera snapshot
Script.register("Engine.OnStarted", main)
camera:register("OnNewImage", processImage)

--End of Function and Event Scope-------------------------------------------------- 