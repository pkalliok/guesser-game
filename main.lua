
require 'algo'

local words = {}
local current_word = 'type in some handsome text and press enter'
local state = 'inputting'
local nodes = {}
local radius = 40

function love.draw()
	local xw, yw = love.graphics.getDimensions()
	for i = 1, 7 do
		love.graphics.setColor(i*10,i*10,i*10)
		love.graphics.circle('fill', xw/2, yw/2, 200 - i * 25)
	end
	love.graphics.setColor(255,255,255)
	if state == 'inputting' then
		love.graphics.print(current_word)
		return
	end
	local xc, yc = avg_position(nodes)
	love.graphics.print(xc .. '/' .. yc)
	for k, v in ipairs(nodes) do
		local r,g,b = v.color
		local x = v.loc.x - xc + xw/2
		local y = v.loc.y - yc + yw/2
		love.graphics.setColor(r,g,b)
		love.graphics.circle('fill', x, y, radius)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(v.w, x-radius, y-12, radius*2, 'center')
	end
end

function love.update(dt)
	nodes = attract_all(repulse_words(nodes))
end

function love.load()
	love.keyboard.setKeyRepeat(true)
end

function love.textinput(text)
	current_word = current_word .. text
end

function jitter(n, variance)
	return n + love.math.random(variance) - love.math.random(variance)
end

function rand_comp()
	return jitter(100, 50)
end

function word_to_bubble(w)
	return {w = w, loc = {x = jitter(0, 150), y = jitter(0, 100)},
		color = {rand_comp(), rand_comp(), rand_comp()}}
end

function love.keypressed(key)
	if key == 'return' and current_word == '' then
		state = 'iterating'
		nodes = map(word_to_bubble, words)
		return
	end
	if key == 'return' then
		table.insert(words, current_word)
		current_word = ''
		return
	end
	if key == 'backspace' then
		current_word = current_word:sub(1, -2)
		return
	end
end

