--[[
Copyright (c) 2016 Bue Grønlund

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local Piskel = {}

local function extractImageDataList(raw_layer, width, height)
  local base64 = string.sub(raw_layer.base64PNG, 23)
  local file_data = love.filesystem.newFileData(base64, raw_layer.name, "base64")
  local image_data = love.image.newImageData(file_data)
  local image_data_width = image_data:getWidth()

  local image_data_frames = {}

  for i = 1, raw_layer.frameCount do
    local image_data_frame = love.image.newImageData(width, height)

    local sx = math.floor(((i - 1) * width) % image_data_width / width) * width
    local sy = math.floor(((i - 1) * width) / image_data_width) * height

    image_data_frame:paste(image_data, 0, 0, sx, sy, width, height)
    image_data_frames[i] = image_data_frame
  end

  return image_data_frames
end

function Piskel.parse_file(filepath)
  local file_json, _ = love.filesystem.read(filepath)
  local file_parsed = Piskel.decode_json(file_json)

  if file_parsed.modelVersion ~= 2 then
    error("Incompatible Piskel model version: " .. file_parsed.modelVersion)
  end

  local layer  = {}
  local piskel = file_parsed.piskel
  local width  = piskel.width
  local height = piskel.height

  for _, layer_json in ipairs(piskel.layers) do
    local raw_layer = Piskel.decode_json(layer_json)
    local imageDataList = extractImageDataList(raw_layer, width, height)
    local images = {}

    for i, image_data in ipairs(imageDataList) do
      images[i] = love.graphics.newImage(image_data)
    end

    layer[raw_layer.name] = {
      opacity           = raw_layer.opacity,
      imageDataList     = imageDataList,
      images            = images
    }
  end

  return {
    name        = piskel.name,
    description = piskel.description,
    fps         = piskel.fps,
    width       = width,
    height      = height,
    layer       = layer
  }
end

return Piskel
