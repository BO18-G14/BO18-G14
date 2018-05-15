-------------------- Calibration for BO18-G14 box counting based on size ------------------------------------
--
--  Calibration application for counting boxes based on the detected areal / dimension of each box in correlation with the
-- calibrated heigh for each level. Each box is marked with a black outlined square on a mat surface
--
-- Developed by Melvin L and Mathias G.

-- Declaration of sample colored square to visualy idenify the boxes detected.
local BoxVisual = View.ShapeDecoration.create()
BoxVisual:setLineColor(0,0,255)
BoxVisual:setLineWidth(4)       

--Global variables needed
local viewer = View.create()


-- Create and configure camera
camera = Image.Provider.Camera.create()
config = Image.Provider.Camera.V2DConfig.create()

config = Image.Provider.Camera.V2DConfig.create()
config:setBurstLength(0)     -- Continuous acquisition
config:setFrameRate(1)      -- Framerate in Hz
config:setShutterTime(800)   -- Shutter time in us 
config:setIntLight("OFF") -- Turn of the built in LED light (Currently out of order)


camera:setConfig(config)

-------------------------------------

-- Looping through the functions
local function main()

-- Activate aiming laser
aimingLaser = AimingLight.create()
aimingLaser:activate()


-- Enable camera and take snapshot
  camera:enable()
  
  print("Snapping photo.")
  camera:snapshot()
end


 -- Function trigged trought camera snapshot event
function processImage(im, sensorData)

  --Set image to view for user
  viewer:view(im)
  local img = im
  
  -- Set images data threshold
  img = img:binarize(7,22)
  
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
  
  
  -- Simple filter to avoid detection of other smaler objects in the picture
  if height > 50 and height < 140 then 
    
    
    --For debug / calibration
    print("We found box")
    print("Height: " ..height .. " Ratio: " .. height/width ) 
    
    -- Add visual elements to view
    viewer:add(box,BoxVisual)
    
    -- Calculate the summed value of all detected boxes height   
    TotalBoxValue = TotalBoxValue + height
    
    
      end

    end
   
  end
  
    
  --Print the summed value of all detected boxes height  
  print(TotalBoxValue)
    
   --Display results to view
  viewer:present()
  
end

--Trigger events for main and camera snapshot
Script.register("Engine.OnStarted", main)
camera:register("OnNewImage", processImage)
