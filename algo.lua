
function indent(n)
	local result = ''
	for i = 1, n do
		result = result .. ' '
	end
	return result
end

function deep_tostr(obj, lev)
	if type(obj) ~= 'table' then
		return indent(lev) .. tostring(obj)
	end
	local result = indent(lev) .. '{\n'
	for k, v in pairs(obj) do
		local ks = ' (@ ' .. tostring(k) .. '),\n'
		result = result .. deep_tostr(v, lev+1) .. ks
	end
	return result .. indent(lev) .. '}'
end

function pp(obj)
	print(deep_tostr(obj, 0))
end

function memoize(f)
	local memory = {}
	return function(a, b)
		local val = memory[a .. '/' .. b]
		if val then return val end
		val = f(a, b)
		memory[a .. '/' .. b] = val
		return val
	end
end

function real_edit_dist(s1, s2)
	if s1 == '' then return s2:len() end
	if s2 == '' then return s1:len() end
	if s1:sub(1,1) == s2:sub(1,1) then
		return edit_dist(s1:sub(2), s2:sub(2))
	end
	return 1 + math.min(edit_dist(s1, s2:sub(2)), edit_dist(s1:sub(2), s2))
end

edit_dist = memoize(real_edit_dist)

function similarity(s1, s2)
	local max_distance = s1:len() + s2:len() 
	local correct = max_distance - edit_dist(s1, s2)
	return correct / (max_distance + 1)
end

function repulse(p1, p2)
	local xdiff = p1.x - p2.x
	local ydiff = p1.y - p2.y
	local dist_nz = xdiff * xdiff + ydiff * ydiff + 1
	return {x = p1.x + 7 * xdiff / dist_nz, y = p1.y + 7 * ydiff / dist_nz}
end

function merge_bang(t1, t2)
	for k, v in pairs(t2) do t1[k] = v end
	return t1
end

function merge(t1, t2)
	return merge_bang(merge_bang({}, t1), t2)
end

function associate(t, k, v)
	return merge(t, {[k] = v})
end

function reduce(f, acc, vals)
	for k, v in ipairs(vals) do acc = f(acc, v) end
	return acc
end

function map(f, vals)
	local result = {}
	for k, v in ipairs(vals) do table.insert(result, f(v)) end
	return result
end

function sum(x, y)
	return x + y
end

function field(key)
	return function(table) return table[key] end
end

function avg_position(words)
	local locs = map(field('loc'), words)
	local xsum = reduce(sum, 0, map(field('x'), locs))
	local ysum = reduce(sum, 0, map(field('y'), locs))
	return xsum / #locs, ysum / #locs
end

function repulse_word(w, points)
	local loc = reduce(repulse, w.loc, points)
	return associate(w, 'loc', loc)
end

function repulse_words(words)
	local locs = map(field('loc'), words)
	function rp_word(w) return repulse_word(w, locs) end
	return map(rp_word, words)
end

function attract(w1, w2)
	local xdiff = w2.loc.x - w1.loc.x
	local ydiff = w2.loc.y - w1.loc.y
	local dist_nz = math.sqrt(xdiff * xdiff + ydiff * ydiff) + 1
	local sc = similarity(w1.w, w2.w) / dist_nz
	local new_loc = {x = w1.loc.x + xdiff * sc, y = w1.loc.y + ydiff * sc}
	return associate(w1, 'loc', new_loc)
end

function attract_all(words)
	return map(function (w) return reduce(attract, w, words) end, words)
end

