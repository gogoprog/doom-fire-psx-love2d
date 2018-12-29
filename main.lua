local pixels = {}
local w = 300
local h = 200
local sx, sy
local palette = {}
local colors= {
    0x07,0x07,0x07,
    0x1F,0x07,0x07,
    0x2F,0x0F,0x07,
    0x47,0x0F,0x07,
    0x57,0x17,0x07,
    0x67,0x1F,0x07,
    0x77,0x1F,0x07,
    0x8F,0x27,0x07,
    0x9F,0x2F,0x07,
    0xAF,0x3F,0x07,
    0xBF,0x47,0x07,
    0xC7,0x47,0x07,
    0xDF,0x4F,0x07,
    0xDF,0x57,0x07,
    0xDF,0x57,0x07,
    0xD7,0x5F,0x07,
    0xD7,0x5F,0x07,
    0xD7,0x67,0x0F,
    0xCF,0x6F,0x0F,
    0xCF,0x77,0x0F,
    0xCF,0x7F,0x0F,
    0xCF,0x87,0x17,
    0xC7,0x87,0x17,
    0xC7,0x8F,0x17,
    0xC7,0x97,0x1F,
    0xBF,0x9F,0x1F,
    0xBF,0x9F,0x1F,
    0xBF,0xA7,0x27,
    0xBF,0xA7,0x27,
    0xBF,0xAF,0x2F,
    0xB7,0xAF,0x2F,
    0xB7,0xB7,0x2F,
    0xB7,0xB7,0x37,
    0xCF,0xCF,0x6F,
    0xDF,0xDF,0x9F,
    0xEF,0xEF,0xC7,
    0xFF,0xFF,0xFF
}

local imageData
local image

function spreadFire(x, y)
    local src = 1 + x + w*y
    local p = pixels[src];
    if p == 1 then
        setPixelColor(x, y-1, 1)
    else
        local r = math.random(0, 3)
        local dst = src -  r
        setPixelColor(x - r, y - 1, p - (r == 3 and 0 or 1))
    end
end

function updateFire()
    for x = 0, w - 1 do
        for y = 1, h - 1 do
            spreadFire(x, y)
        end
    end

    image:replacePixels(imageData)
end

function setPixelColor(x, y, colorIndex)
    local pixelIndex = 1 + x + w*y
    if x < 0 then
        y = y - 1
        x = x + w
    end
    if x >= w or y >= h or x < 0 or y < 0 then return end
    local color = palette[colorIndex]
    pixels[pixelIndex] = colorIndex
    imageData:setPixel(x, y, color.r, color.g, color.b, 1)
end

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("doom-fire-psx-love2d")
    local screenw, screenh = love.graphics.getDimensions()

    imageData = love.image.newImageData(w, h)
    sx = screenw / w
    sy = screenh / h

    for i=0, #colors / 3 - 1 do
        palette[i] = {
            r = colors[i * 3 + 1] / 255,
            g = colors[i * 3 + 2] / 255,
            b = colors[i * 3 + 3] / 255
        }
    end

    for x = 0, w - 1 do
        for y = 0, h - 1 do
            setPixelColor(x, y, 1)
        end
    end

    image = love.graphics.newImage(imageData)

    for x = 0, w - 1 do
        setPixelColor(x, h-1, #palette)
    end
end

local time = 0
local updateTime = 0.1
local frames = 0
local fps = 0
function love.update(dt)
    time = time + dt
    frames = frames  + 1
    if time > updateTime then
        fps = frames / updateTime
        frames = 0
        time = time - updateTime
        updateFire()
    end
end

function love.draw()
    love.graphics.draw(image, 0, 0, 0, sx, sy)
    love.graphics.print('doom-fire-psx-love2d ' .. fps .. 'fps', 0, 0)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end
