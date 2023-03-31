-- common function used in script

function format_account(s)
    local rek_len = string.len(s)
    if rek_len >= 12 and rek_len <=15 then
        s = string.rep("0",15-rek_len)..s
        s = string.sub(s,1,-12).."-"..string.sub(s,-11,-10).."-"..string.sub(s,-9,-4).."-"..string.sub(s,-3,-2).."-"..string.sub(s,-1,-1)
    end
    return s
end

function format_number(v)
	local s
	local unary
	
	if v < 0 then
		s = tostring(-v)
		unary = "-"
	else
		s = tostring(v)
		unary = ""
	end
    
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return unary..string.sub(s, 1, pos).. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function FindFirstSeparator(line)
	local sep,c
	
	sep = ','
	for c in line:gmatch(".") do
		if c == ',' then
			sep = ',' break
		elseif c == ';' then
			sep = ';' break
		elseif c == ':' then
			sep = ':' break
		elseif c == '|' then
			sep = '|' break
		end
	end
	return sep
end

function Rekap_Officer(cs, rm_dana, rm_kredit, rm_merchant, rm_ro, rm_sp, rm_pab, rm_referal)
	local res = {}
	
	if #cs ~= 0 then res[#res+1] = "CS: "..cs end
	if #rm_dana ~= 0 then res[#res+1] = "RM Dana: "..rm_dana end
	if #rm_kredit ~= 0 then res[#res+1] = "RM Kredit: "..rm_kredit end
	if #rm_merchant ~= 0 then res[#res+1] = "RM Merchant: "..rm_merchant end
	if #rm_ro ~= 0 then res[#res+1] = "RO: "..rm_ro end
	if #rm_sp ~= 0 then res[#res+1] = "SP: "..rm_sp end
	if #rm_pab ~= 0 then res[#res+1] = "PAB: "..rm_pab end
	if #rm_referal ~= 0 then res[#res+1] = "Referal: "..rm_referal end
	return table.concat(res,"<br>")
end

function ReadRegistry(key, value)
	local fi, data, content, data_type
	
	fi = io.popen(string.format('reg QUERY "%s" /v %s', key, value))
	data = nil
	if fi then
		content = fi:read("*a")
		data_type, data = content:match(value..'%s+(%S+)%s+(.+)\n\n')
		fi:close()
	end

	return data_type, data
end

function save_file(content, filename)
	local fo
	
	fo = io.open(filename, "a")
	if fo == nil then
		print('Error open a file '..filename)
		return false
	end
	fo:write(content)
	fo:close()
	return true
end

function load_file(filename)
	local fi, content

	fi = io.open(filename, "r")
	if fi == nil then
		print("[error] Load file "..filename)
		return nil
	end
	content = fi:read("*a")
	fi:close()
	return content
end
