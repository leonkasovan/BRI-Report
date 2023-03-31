-- Diff Report : Find and calculate the difference between files DI319PN Saving Account Balance (CSV Format from Portal DWH)
-- Interpreter : (Novan's Modified)lua.exe
-- 7:57 PM Thursday, April 25, 2013 Raha City

dofile('get_report_type.lua')
dofile('common.lua')

local list_acc = {}
local OUTPUT_FILE = "Delta_Saldo_Tabungan"
local f_lines1 = nil
local f_lines2 = nil
local output_sep = nil
local decimal_sep = nil

local res, dummy, ReportFileName1, ReportFileName2, limit_res, is_foreign = iup.GetParam("Pilih Report DI319 dalam Format CSV (Sumber: DWH)", nil, [=[
Sumber Data: %m\n
Report Posisi Awal: %f[OPEN|*DI319*.csv;*DI319*.gz|CURRENT|NO|NO]\n
Report Posisi Akhir: %f[OPEN|*DI319*.csv;*DI319*.gz|CURRENT|NO|NO]\n
Limit Result: %l|10|20|30|50|100|\n
Mata Uang asing: %b\n
]=]
,"1. Buka Aplikasi BRISIM (https://brisim.bri.co.id)\n2. Pilih: EDW Reports\n3. Pilih: List EDW Report\n4. Pilih No 212. DI319 - Multi PN - SAVINGS ACCOUNT MONTHLY TRIAL BALANCE\n6. Download dan Save dalam format CSV", "C:\\Lua\\data\\20210131 DI319 MULTI PN.csv.gz","C:\\Lua\\data\\20210225 DI319 MULTI PN.csv.gz",1,0)

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
			iup.Message("Error","Report [Awal] yang dipilih bukan Report \"DI319 PN\" atau \"DI319 MULTI PN\" dalam format CSV.\nSilahkan download ulang dari BRISIM atau \npilih kembali report yang sesuai.")
			return -1
		end
	else
		-- process data
		f = csv.parse(line, sep)
		if f == nil then
			iup.Message("Error","Report [Awal] ada kesalahan data pada baris "..tostring(no-1)..".\nKoreksi data tsb dan ulangi prosesnya.")
			return -1
		end
		if f[1] ~= "" then
			if (is_foreign == 1 and f[3] ~= "IDR ") or (is_foreign == 0 and f[3] == "IDR ") then
				posisi_report1 = f[1]
				acc_no = f[5]
				
				if report1_type == "EDW-212-DI319/DWH-1-DI319" then
					acc_cif = f[6]..' - '..f[15]
				elseif report1_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_cif = f[6]..' - '..f[14]
				else
					acc_cif = f[6]
				end
				
				if is_foreign == 1 then acc_name = f[7]..' <b>'..f[3]..'</b>' else acc_name = f[7] end
				
				if report1_type == "DI319MULTIPN" then
					acc_officer = Rekap_Officer(f[25],f[26],f[27],f[28],f[29],f[30],f[31],f[32])
				elseif report1_type == "EDW-212-DI319/DWH-1-DI319" then
					acc_officer = Rekap_Officer(f[22],f[23],f[24],f[25],f[26],f[27],f[28],f[29])
				elseif report1_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_officer = Rekap_Officer(f[21],f[22],f[23],f[24],f[25],f[26],f[27],f[28])
				elseif report1_type == "DWH-2-DI319" then
					acc_officer = f[17]..'-'..f[18]
				else
					acc_officer = f[8]
				end
				
				if report1_type == "EDW-212-DI319/DWH-1-DI319" or report1_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_balance = f[10]
				else
					acc_balance = f[11]
				end
				acc_balance = string.gsub(string.sub(acc_balance, 1, #acc_balance-3), ",", "")
				acc_balance = tonumber(acc_balance)
				
				list_acc[acc_no] = {acc_cif, acc_name, acc_balance, 0, -acc_balance, acc_officer}
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
-- fo:write('Rekening'..output_sep..'Tipe'..output_sep..'Nama'..output_sep..'Tanggal Buka'..output_sep..'Saldo'..output_sep..'PN_Pengelola\n')
for line in f_lines2(ReportFileName2) do
	-- only process line begin with number, skipping header
	if no == 1 then
		sep = FindFirstSeparator(line)
		report2_type = Get_Report_Type(line, ReportFileName2)
		if report2_type == nil then
			iup.Message("Error","Report [Akhir] yang dipilih bukan Report \"DI319 PN\" atau \"DI319 MULTI PN\" dalam format CSV.\\nSilahkan download ulang dari BRISIM atau \\npilih kembali report yang sesuai.")
			return -1
		end
	else
		f = csv.parse(line, sep)
		if f == nil then
			iup.Message("Error","Report [Akhir] ada kesalahan data pada baris "..tostring(no-1)..".\nKoreksi data tsb dan ulangi prosesnya.")
			return -1
		end
		if f[1] ~= "" then
			if (is_foreign == 1 and f[3] ~= "IDR ") or (is_foreign == 0 and f[3] == "IDR ") then
				posisi_report2 = f[1]
				acc_no = f[5]
				
				if report2_type == "EDW-212-DI319/DWH-1-DI319" then
					acc_cif = f[6]..' - '..f[15]
				elseif report2_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_cif = f[6]..' - '..f[14]
				else
					acc_cif = f[6]..' - '..f[16]
				end
				
				if is_foreign == 1 then acc_name = f[7]..' <b>'..f[3]..'</b>' else acc_name = f[7] end
				
				if report2_type == "DI319MULTIPN" then
					acc_officer = Rekap_Officer(f[25],f[26],f[27],f[28],f[29],f[30],f[31],f[32])
				elseif report2_type == "EDW-212-DI319/DWH-1-DI319" then
					acc_officer = Rekap_Officer(f[22],f[23],f[24],f[25],f[26],f[27],f[28],f[29])
				elseif report2_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_officer = Rekap_Officer(f[21],f[22],f[23],f[24],f[25],f[26],f[27],f[28])
				elseif report2_type == "DWH-2-DI319" then
					acc_officer = f[17]..'-'..f[18]
				else
					acc_officer = f[8]
				end
				
				if report2_type == "EDW-212-DI319/DWH-1-DI319" or report2_type == "EDW-212-DI319/DWH-1-DI319v2" then
					acc_balance = f[10]
				else
					acc_balance = f[11]
				end
				acc_balance = string.gsub(string.sub(acc_balance, 1, #acc_balance-3), ",", "")
				acc_balance = tonumber(acc_balance)
				if list_acc[acc_no] then
					list_acc[acc_no][4] = acc_balance
					list_acc[acc_no][5] = list_acc[acc_no][4] - list_acc[acc_no][3]
					list_acc[acc_no][6] = acc_officer
				else
					list_acc[acc_no] = {acc_cif, acc_name, 0, acc_balance, acc_balance, acc_officer}
					-- if report2_type == "EDW-212-DI319/DWH-1-DI319" then
						-- dd = csv.parse(f[9],'/')
						-- fo:write(string.format('%s%s%s%s"%s"%s%s/%s/%s%s"%s"%s%s\n', 
						-- format_account(acc_no), output_sep,
						-- f[15], output_sep,
						-- acc_name, output_sep,
						-- dd[2], dd[1], dd[3], output_sep,
						-- format_number(acc_balance), output_sep,
						-- acc_officer))
					-- else
						-- dd = csv.parse(f[10],'/')
						-- fo:write(string.format('%s%s%s%s"%s"%s%s/%s/%s%s"%s"%s%s\n', 
						-- format_account(acc_no), output_sep,
						-- f[16], output_sep,
						-- acc_name, output_sep,
						-- dd[2], dd[1], dd[3], output_sep,
						-- format_number(acc_balance), output_sep,
						-- acc_officer))
					-- end
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
	table.insert(sorted_list_acc, {k, v[1], v[2], v[3], v[4], v[5], v[6]}) 
end
table.sort(sorted_list_acc, function(a,b) return a[6]<b[6] end)
print("Processing "..tostring(#sorted_list_acc).." rekening")

print('Writing '..OUTPUT_FILE..'.htm')
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
 
<title>BRI Reporting Tool: Delta Tabungan DI319</title>
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
 <h2>&nbsp;&nbsp;&nbsp;REKENING TABUNGAN YANG SALDONYA TURUN ]=]..string.format("(Periode %s - %s) %s",posisi_report1, posisi_report2, report2_type)..[=[</h2>
 <table cellspacing='0'>
	<thead>
		<tr>
			<th>No Rekening</th>
			<th>CIF<br>Type</th>
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
		if tonumber(v[6]) ~= 0 then
			fo2:write("<tr><td>"..format_account(v[1]).."</td><td>"..v[2].."</td><td>"..v[3].."</td><td align='right'>"..format_number(v[4]).."</td><td align='right'>"..format_number(v[5]).."</td><td class='minus' align='right'>"..format_number(v[6]).."</td><td align='right'>"..v[7].."</td></tr>\n")
		end
	elseif ii == limit_res then
		fo2:write([=[
	</tbody>
 </table>
 <hr></br><h2>&nbsp;&nbsp;&nbsp;REKENING TABUNGAN YANG SALDONYA NAIK ]=]..string.format("(Periode %s - %s) %s",posisi_report1, posisi_report2, report2_type)..[=[</h2>
 <table cellspacing='0'>
	<thead>
		<tr>
			<th>No Rekening</th>
			<th>CIF<br>Type</th>
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
			if tonumber(v[6]) ~= 0 then
				fo2:write("<tr><td>"..format_account(v[1]).."</td><td>"..v[2].."</td><td>"..v[3].."</td><td align='right'>"..format_number(v[4]).."</td><td align='right'>"..format_number(v[5]).."</td><td class='plus' align='right'>"..format_number(v[6]).."</td><td align='right'>"..v[7].."</td></tr>\n")
			end
		end
	end
	
	ii = ii + 1
end
fo2:write([=[
	</tbody>
 </table>
 <hr>
 <div align='center' style='font-size:smaller'>BRI Reporting Tool: DI319 Diff<br>Copyright &copy;2013, <b>Dhani Novan</b> (dhani_novan@bri.co.id)</div><br/>
</body>
</html>
]=])
fo2:close()
print('=== Done in '..(os.clock()-t1)..' ===')
os.execute(OUTPUT_FILE..".htm")

-- if iup.Alarm("Open List of New Created Account", "Buka file daftar rekening baru yang dibuat \ndalam periode "..posisi_report1.." sampai "..posisi_report2.." ? " ,"Ya" ,"Tidak") == 1 then
	-- os.execute(OUTPUT_FILE.."_NEW.csv")
-- end
--os.execute("pause")
