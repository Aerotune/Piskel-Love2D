# Introduction
PiskelLove is a library to parse `.piskel` files from Piskel http://www.piskelapp.com/ in Löve2D https://love2d.org/

## Installation
Move `piskel.lua` to your project and set a `json_decode` function for the library to use.

    local Piskel = require "piskel.lua"
    local json = require "json.lua"
    -- Set json function for Piskel to use
    Piskel.decode_json = json.decode


I'm currently using https://github.com/rxi/json.lua

## Parse .piskels
Now you can parse `.piskel` files like this:

    local run_loop = Piskel.parse_file('run_loop.piskel')

The format returned by `Piskel.parse_file(filepath)` follows the json format used by PiskelApp e.g:

    {
      name        = name,
      description = description,
      fps         = fps,
      width       = width,
      height      = height,
      layer       = {
        ["layer_name"] = {
          opacity = opacity,
          images = images,
          imageDataList = imageDataList
        },
        ...
      }
    }

`layer` is a table with the layer name as the key. Note that in piskel app you can have multiple layers with the same name while this parser will overwrite existing layers with the same name.

`opacity` is a number between 0 and 1

`imageDataList` is a Löve `ImageData` list

`images` is a Löve `Image` list

# Todo:

* Make the parser more versatile with parsing different .piskel formats (Works with latest piskel version 15 june 2017)