-- Diff Report : Find and calculate the difference between files CI324 PN FDS Monthly Trial Balance (CSV Format from Portal DWH)
-- Interpreter : (Novan's Modified)lua.exe
-- 10:03 PM Sunday, February 10, 2019 Jakarta City

dofile('get_report_type.lua')
dofile('common.lua')
			
local list_acc = {}
local OUTPUT_FILE = "Delta_Saldo_Deposito"
local f_lines1 = nil
local f_lines2 = nil
local output_sep = nil
local decimal_sep = nil

local res, dummy, ReportFileName1, ReportFileName2, Filter_PN, limit_res, is_foreign = iup.GetParam("Pilih Report CI324 PN dalam Format CSV", nil, "Sumber Data: %m\n Report Posisi Awal: %f[OPEN|*CI324*.csv;*CI324*.gz|CURRENT|NO|NO]\n Report Posisi Akhir: %f[OPEN|*CI324*.csv;*CI324*.gz|CURRENT|NO|NO]\n Personal Number: %s\n Limit Result: %l|10|20|30|50|100|\n Mata Uang asing: %b\n"
,"1. Buka Aplikasi BRISIM (https://brisim.bri.co.id)\n2. Pilih: EDW Reports\n3. Pilih: List EDW Report\n4. Pilih No 216 CI324 - Multi PN - FDs MONTHLY TRIAL BALANCE by PRODUCT TYPE\n6. Download dan Save dalam format CSV", "C:\\Lua\\data\\20201231 CI324Modif.csv.gz","C:\\Lua\\data\\20210131 CI324Modif.csv.gz","",1,0)

data_type, output_sep = ReadRegistry('HKCU\\Control Panel\\International', 'sList')
data_type, decimal_sep = ReadRegistry('HKCU\\Control Panel\\International', 'sDecimal')
if output_sep == decimal_sep then output_sep =';' end
if output_sep == nil then output_sep = ',' end

if ReportFileName1 == "" or ReportFileName2 == "" or ReportFileName1 == nil or ReportFileName2 == nil or res == false then
	print("Please select two reports to be compared")
	os.execute("pause")
	os.exit(-1)
end

-- convert Unicode to ANSI
if ReportFileName1:match('%.gz$') == nil then
	print('Converting '..ReportFileName1..' to ANSI encoding')
	os.execute('type "'..ReportFileName1..'" > '..'tmp.csv')
	os.remove(ReportFileName1)
	os.rename('tmp.csv', ReportFileName1)
	f_lines1 = io.lines
else
	f_lines1 = gzio.lines
end

if ReportFileName2:match('%.gz$') == nil then
	print('Converting '..ReportFileName2..' to ANSI encoding')
	os.execute('type "'..ReportFileName2..'" > '..'tmp.csv')
	os.remove(ReportFileName2)
	os.rename('tmp.csv', ReportFileName2)
	f_lines2 = io.lines
else
	f_lines2 = gzio.lines
end

-- Load first data into table list_acc
local t1 = os.clock()
print('Loading data from '..ReportFileName1)
local no = 1
local sep = ','
local posisi_report1 = ''
local posisi_report2 = ''
local report1_type = ''
local report2_type = ''
for line in f_lines1(ReportFileName1) do
	-- process header
	if no == 1 then
		sep = FindFirstSeparator(line)
		report1_type = Get_Report_Type(line, ReportFileName1)
		if report1_type == nil then
			iup.Message("Error","Report [Awal] yang dipilih bukan Report \"CI324PN\" atau \"CI324\" dalam format CSV.\nSilahkan download ulang dari BRISIM atau \npilih kembali report yang sesuai.")
			return -1
		end
	else
		-- process data
		f = csv.parse(line, sep)
		if f[1] ~= "" then
			if (is_foreign == 1 and f[3] ~= "IDR ") or (is_foreign == 0 and f[3] == "IDR ") then
				posisi_report1 = f[1]
				acc_no = f[6]
				acc_type_tenor = f[5].." - "..f[14]
				acc_maturity = f[12]
				if is_foreign == 1 then acc_name = f[9]..' <b>'..f[3]..'</b>' else acc_name = f[9] end
				if report1_type == "EDW-216-CI324" then
					acc_officer = Rekap_Officer(f[16],f[17],f[18],f[19],f[20],f[21],f[22],f[23])
				elseif report1_type == "DWH-6-CI324" then
					acc_officer = f[17]
				else
					acc_officer = ''
				end
				acc_balance = string.gsub(string.sub(f[8], 1, #f[8]-3), ",", "")
				acc_balance = tonumber(acc_balance)
				if acc_officer:find(Filter_PN,1,true) ~= nil then
					list_acc[acc_no] = {acc_type_tenor, acc_maturity, acc_name, acc_balance, 0, -acc_balance, acc_officer}
				end
			end
		end
	end
	no = no + 1
end

-- Update table list_acc with lastest balance from second data
print('Loading data from '..ReportFileName2)
no = 1
sep = ','
posisi_report2 = ''
-- fo = io.open(OUTPUT_FILE.."_NEW.csv", "w")
-- fo:write('Rekening'..output_sep..'Tipe'..output_sep..'Nama'..output_sep..'Tanggal Buka'..output_sep..'Jatuh Tempo'..output_sep..'Rate'..output_sep..'Tenor'..output_sep..'Rollover'..output_sep..'Currency'..output_sep..'Pokok'..output_sep..'PN_Pengelola\n')
for line in f_lines2(ReportFileName2) do
	-- only process line begin with number, skipping header
	if no == 1 then
		sep = FindFirstSeparator(line)
		report2_type = Get_Report_Type(line, ReportFileName2)
		if report2_type == nil then
			iup.Message("Error","Report [Akhir] yang dipilih bukan Report \"CI324PN\" atau \"CI324\" dalam format CSV.\nSilahkan download ulang dari BRISIM atau \npilih kembali report yang sesuai.")
			return -1
		end
	else
		f = csv.parse(line, sep)
		if f[1] ~= "" then
			if (is_foreign == 1 and f[3] ~= "IDR ") or (is_foreign == 0 and f[3] == "IDR ") then
				posisi_report2 = f[1]
				acc_no = f[6]
				acc_type_tenor = f[5].." - "..f[14]
				acc_maturity = f[12]
				if is_foreign == 1 then acc_name = f[9]..' <b>'..f[3]..'</b>' else acc_name = f[9] end
				if report2_type == "EDW-216-CI324" then
					acc_officer = Rekap_Officer(f[16],f[17],f[18],f[19],f[20],f[21],f[22],f[23])
				elseif report2_type == "DWH-6-CI324" then
					acc_officer = f[17]
				else
					acc_officer = ''
				end
				acc_balance = string.gsub(string.sub(f[8], 1, #f[8]-3), ",", "")
				acc_balance = tonumber(acc_balance)
				if list_acc[acc_no] then
					list_acc[acc_no][5] = acc_balance
					list_acc[acc_no][6] = list_acc[acc_no][5] - list_acc[acc_no][4]
				else
					if acc_officer:find(Filter_PN,1,true) ~= nil then
						list_acc[acc_no] = {acc_type_tenor, acc_maturity, acc_name, 0, acc_balance, acc_balance, acc_officer}
					end
					-- issuedt = csv.parse(f[11],'/')
					-- matdt = csv.parse(f[12],'/')
					-- fo:write(string.format('%s%s%s%s"%s"%s%s/%s/%s%s%s/%s/%s%s"%s"%s%s%s%s%s%s%s"%s"%s%s\n', 
						-- format_account(acc_no), output_sep,
						-- f[5], output_sep,
						-- acc_name, output_sep,
						-- issuedt[1], issuedt[2], issuedt[3], output_sep,
						-- matdt[1], matdt[2], matdt[3], output_sep, 
						-- f[13]:gsub('%.',decimal_sep), output_sep,
						-- f[14], output_sep,
						-- f[15], output_sep,
						-- f[3], output_sep,
						-- format_number(acc_balance), output_sep,
						-- acc_officer))
				end
			end
		end
	end
	no = no + 1
end
-- fo:close()

print('Sorting descending')
sorted_list_acc = {}
for k, v in pairs(list_acc) do
	table.insert(sorted_list_acc, {k, v[1], v[2], v[3], v[4], v[5], v[6], v[7]}) 
end
table.sort(sorted_list_acc, function(a,b) return a[7]<b[7] end)
print("Processing "..tostring(#sorted_list_acc).." rekening")

print('Writing '..OUTPUT_FILE)
if output_sep == 0 then
	output_sep = ','
elseif output_sep == 1 then
	output_sep = ';'
end
if limit_res == 0 then
	limit_res = 10
elseif limit_res == 1 then
	limit_res = 20
elseif limit_res == 2 then
	limit_res = 30
elseif limit_res == 3 then
	limit_res = 50
elseif limit_res == 4 then
	limit_res = 100
end
ii = 0
fo2 = io.open(OUTPUT_FILE..".htm", "w")
fo2:write([=[
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 
<title>BRI Reporting Tool: Delta Deposito CI324</title>
<style type="text/css"> 
body, html  { height: 100%; }
html, body, div, span, applet, object, iframe,
/*h1, h2, h3, h4, h5, h6,*/ p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	font-size: 100%;
	vertical-align: baseline;
	background: transparent;
}
body { line-height: 1; }
ol, ul { list-style: none; }
blockquote, q { quotes: none; }
blockquote:before, blockquote:after, q:before, q:after { content: ''; content: none; }
:focus { outline: 0; }
del { text-decoration: line-through; }
table {border-spacing: 0; }
 
/*------------------------------------------------------------------ */
 body{
	font-family:Arial, Helvetica, sans-serif;
	margin:0 auto;
}
a:link {
	color: #666;
	font-weight: bold;
	text-decoration:none;
}
a:visited {
	color: #666;
	font-weight:bold;
	text-decoration:none;
}
a:active,
a:hover {
	color: #bd5a35;
	text-decoration:underline;
}
 
table a:link {
	color: #666;
	font-weight: bold;
	text-decoration:none;
}
table a:visited {
	color: #999999;
	font-weight:bold;
	text-decoration:none;
}
table a:active,
table a:hover {
	color: #bd5a35;
	text-decoration:underline;
}
table {
	font-family:Arial, Helvetica, sans-serif;
	font-size:12px;
	margin:20px;
	border: 1px solid;
}
table th {
	padding:10px 25px 10px 25px; 
	background: #000000	;
	border-left: 1px solid #a0a0a0;
	color:#ffffff;
}
table th:first-child {
	border-left: 0;
}
table tr {
	text-align: center;
	padding-left:20px;
}
table td:first-child {
	padding-left:20px;
	border-left: 0;
}
table td {
	padding:10px;
	border-top: 0px solid #ffffff;
	border-bottom:1px solid #a0a0a0;
	border-left: 1px solid #a0a0a0;
	
	background: #ffffff;
}
table tr.even td {
	background: #eeeeee;
}
table tr:hover td {
	background: #bbbbff;
}
table td.minus {
	color: #ff0000;
}
table td.plus {
	color: #008800;
} 
</style>
 </head>
 <body>
 <h2>&nbsp;&nbsp;&nbsp;DEPOSITO YANG CAIR (Periode ]=]..posisi_report1..[=[ - ]=]..posisi_report2..[=[)</h2>
 <table cellspacing='0'>
	<thead>
		<tr>
			<th>No Rekening</th>
			<th>Tenor</th>
			<th>Jatuh Tempo</th>
			<th>Nama</th>
			<th>Saldo Awal<br>]=]..posisi_report1..[=[</th>
			<th>Saldo Akhir<br>]=]..posisi_report2..[=[</th>
			<th>Delta</th>
			<th>Pengelola</th>
		</tr>
	</thead>
	<tbody>
]=])
for k, v in pairs(sorted_list_acc) do	
	if ii < limit_res then
		if v[7] ~= 0 then
			fo2:write("<tr><td>"..format_account(v[1]).."</td><td>"..v[2].."</td><td>"..v[3].."</td><td>"..v[4].."</td><td align='right'>"..format_number(v[5]).."</td><td align='right'>"..format_number(v[6]).."</td><td class='minus' align='right'>"..format_number(v[7]).."</td><td align='right'>"..v[8].."</td></tr>\n")
		end
	elseif ii == limit_res then
		fo2:write([=[
	</tbody>
 </table>
 <hr></br><h2>&nbsp;&nbsp;&nbsp;DEPOSITO YANG BARU / ADDON (Periode ]=]..posisi_report1..[=[ - ]=]..posisi_report2..[=[)</h2>
 <table cellspacing='0'>
	<thead>
		<tr>
			<th>No Rekening</th>
			<th>Tenor</th>
			<th>Jatuh Tempo</th>
			<th>Nama</th>
			<th>Saldo Awal<br>]=]..posisi_report1..[=[</th>
			<th>Saldo Akhir<br>]=]..posisi_report2..[=[</th>
			<th>Delta</th>
			<th>Pengelola</th>
		</tr>
	</thead>
	<tbody>
		]=])
	else
		if (#sorted_list_acc - ii) <= limit_res then
			if v[7] ~= 0 then
				fo2:write("<tr><td>"..format_account(v[1]).."</td><td>"..v[2].."</td><td>"..v[3].."</td><td>"..v[4].."</td><td align='right'>"..format_number(v[5]).."</td><td align='right'>"..format_number(v[6]).."</td><td class='plus' align='right'>"..format_number(v[7]).."</td><td align='right'>"..v[8].."</td></tr>\n")
			end
		end
	end
	
	ii = ii + 1
end
fo2:write([=[
	</tbody>
 </table>
 <hr>
 <div align='center' style='font-size:smaller'>BRI Reporting Tool: CI324 Diff<br>Copyright &copy;2013, <b>Dhani Novan</b> (dhani_novan@bri.co.id)</div><br/>
</body>
</html>
]=])
fo2:close()
print('=== Done in '..(os.clock()-t1)..' ===')
os.execute(OUTPUT_FILE..".htm")

-- if iup.Alarm("Open List of New Created Account", "Buka file daftar rekening baru yang dibuat \ndalam periode "..posisi_report1.." sampai "..posisi_report2.." ? " ,"Ya" ,"Tidak") == 1 then
	-- os.execute(OUTPUT_FILE.."_NEW.csv")
-- end
