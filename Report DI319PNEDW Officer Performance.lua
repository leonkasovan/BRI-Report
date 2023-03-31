-- Display Performance each funding officer based on DI319PN EDW Current Account Balance (CSV Format from DWH BRISIM)
-- There is bug in report DI319PN. There are double data. So we have to remove duplicate date. We can use Notepad2 : Edit -> Block -> Sort Lines : Merge Duplicate Line
-- Interpreter : (Novan's Modified)lua.exe
-- 20:32 12 May 2022, Rawamangun
dofile('get_report_type.lua')
dofile('common.lua')

local list_RM = {}
-- output : list of summary account and its officer
-- 0. Personal Number and Officer Name: key
-- 1. Account Officer Name
-- 2. Count of baseline account
-- 3. Sum of baseline account balance

local OUTPUT_FILE = "Tabungan_Bulanan.htm"
local OUTPUT_NO_PN_FILE = "Tabungan_tanpa_PN.csv"
local output_sep = "|"

local res, tmp, pengelola, ReportFileName1 = iup.GetParam("Pick Reports DI319 in CSV Format", nil, [=[
Sumber Data : %m\n
%t\n
Pengelola: %l|RM Dana|RM Kredit|\n
Report DI319 : %f[OPEN|*DI319*.csv;*DI319*.txt;*DI319*.gz|CURRENT|NO|NO]\n
]=]
,"1. Buka Aplikasi BRISIM (https://brisim.bri.co.id)\n2. Pilih: EDW Reports\n3. Pilih: List EDW Report\n4. Pilih No 212. DI319 - Multi PN - SAVINGS ACCOUNT MONTHLY TRIAL BALANCE\n6. Download dan Save dalam format CSV", 0, 'E:\\BRI-Report\\data\\DI319 MULTI PN no_report 212.csv')
if ReportFileName1 == "" or res == false then
	print("Please select report to be analized")
	os.exit(-1)
end

-- convert Unicode to ANSI
local f_lines1
if ReportFileName1:match('%.gz$') == nil then
print('Converting '..ReportFileName1..' to ANSI encoding')
os.execute('type "'..ReportFileName1..'" > '..'tmp.csv')
os.remove(ReportFileName1)
os.rename('tmp.csv', ReportFileName1)
	f_lines1 = io.lines
else
	f_lines1 = gzio.lines
end

-- Load first data (current report) into table list_acc
t1 = os.clock()
print('Loading data from '..ReportFileName1)
local no = 1
local sep = ','
local posisi_report1 = ''
for line in f_lines1(ReportFileName1) do
	-- process header
	if no == 1 then
		sep = FindFirstSeparator(line)
		report1_type = Get_Report_Type(line, ReportFileName1)
		if report1_type ~= "EDW-212-DI319/DWH-1-DI319" then
			iup.Message("Error","Report yang dipilih bukan EDW Report No 212 DI319 - Multi PN - SAVINGS ACCOUNT MONTHLY TRIAL BALANCE (dalam format CSV).\nSilahkan download ulang dari BRISIM atau \npilih kembali report yang sesuai.")
			return -1
		end
	else
		-- process data
		f = csv.parse(line, sep)
		if f[1] ~= "" then
			posisi_report1 = f[1]
			this_year = string.sub(posisi_report1,-4)
			acc_dateopen = f[9]	-- mm/dd/yyyy
			mm = tonumber(acc_dateopen:match('%d+'))
			if string.sub(acc_dateopen,-4) == this_year then
				if pengelola == 1 then
					acc_RM = f[24]	-- RM Kredit only, pengelola == 1
				else
					acc_RM = f[23]	-- RM Dana only, pengelola == 0
				end
				acc_balance = string.gsub(string.sub(f[10], 1, #f[10]-3), ",", "")
				acc_balance = tonumber(acc_balance)
				if acc_RM ~= "" then
					local lRM
					
					if list_RM[acc_RM] == nil then
						list_RM[acc_RM] = {0,0,0,0,0,0,0,0,0,0,0,0,'','','','','','','','','','','',''}
						lRM = list_RM[acc_RM]
						lRM[mm] = 1
						lRM[mm+12] = string.format("%s - %s [%s]",f[5] ,f[7], f[15])
						lRM["total_account"] = 1
						lRM["total_balance"] = acc_balance
					else
						lRM = list_RM[acc_RM]
						lRM[mm] = lRM[mm] + 1
						-- if #(lRM[mm+12]) < 1024 then
							lRM[mm+12] = lRM[mm+12]..'&#13;'..string.format("%s - %s [%s]",f[5] ,f[7], f[15])
						-- end
						lRM["total_account"] = lRM["total_account"] + 1
						lRM["total_balance"] = lRM["total_balance"] + acc_balance
					end
				else	-- rekening tidak ber PN
					if f[30]=="0" then	-- rekening tidak ber PN
						local lRM

						acc_RM = "-"
						if list_RM[acc_RM] == nil then
							list_RM[acc_RM] = {0,0,0,0,0,0,0,0,0,0,0,0,'','','','','','','','','','','',''}
							lRM = list_RM[acc_RM]
							lRM[mm] = 1
							lRM[mm+12] = string.format("%s - %s [%s]",f[5] ,f[7], f[15])
							lRM["total_account"] = 1
							lRM["total_balance"] = acc_balance
							os.remove(OUTPUT_NO_PN_FILE)
							save_file(string.format("sep=%s\nNo%sRekening%sNama%sType%sSaldo\n%03d%s%s%s%s%s%s%s%s\n"
							, output_sep, output_sep, output_sep, output_sep, output_sep
							, lRM["total_account"], output_sep, f[5], output_sep, f[7], output_sep, f[15], output_sep, format_number(acc_balance))
							, OUTPUT_NO_PN_FILE)
						else
							lRM = list_RM[acc_RM]
							lRM[mm] = lRM[mm] + 1
							-- if #(lRM[mm+12]) < 1024 then
								lRM[mm+12] = lRM[mm+12]..'&#13;'..string.format("%s - %s [%s]",f[5] ,f[7], f[15])
							-- end
							lRM["total_account"] = lRM["total_account"] + 1
							lRM["total_balance"] = lRM["total_balance"] + acc_balance
							save_file(string.format("%03d%s%s%s%s%s%s%s%s\n", lRM["total_account"], output_sep, f[5], output_sep, f[7], output_sep, f[15], output_sep, format_number(acc_balance)), OUTPUT_NO_PN_FILE)
						end
					end
				end
			end
		end
	end
	no = no + 1
end
--this_month = tonumber(posisi_report1:match('%/%d+%/'))
this_month = tonumber(string.sub(posisi_report1,-7,-6))

--for k, v in pairs(list_RM) do
--	print(k, v[1], v[2], v[3], v[4], v["total_account"], v["total_balance"])
--end
fo2 = io.open(OUTPUT_FILE, "w")
fo2:write([=[
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 
<title>BRI Reporting Tool: Akuisisi Tabungan DI319</title>
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
	cursor: pointer;
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

textarea {
	font-family: Courier;
	font-size:12px;
	margin:20px;
	border: 1px solid;
	width: 40%;
	background: #ffbbbb;
	height: 300px;
}
</style>
<script>
function sortTable(table, col, reverse) {
    var tb = table.tBodies[0], // use `<tbody>` to ignore `<thead>` and `<tfoot>` rows
        tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
        i;
    reverse = -((+reverse) || -1);
	if (col) {	// col 1 (Jan), col 2 (feb), etc, sort by number
		tr = tr.sort(function (a, b) { // sort rows
			return reverse * (a.cells[col].textContent.trim() - b.cells[col].textContent.trim());
		});
	}else{	// col 0 (PN) sort by string
		tr = tr.sort(function (a, b) { // sort rows
			return reverse // `-1 *` if want opposite order
				* (a.cells[col].textContent.trim() // using `.textContent.trim()` for test
					.localeCompare(b.cells[col].textContent.trim())
				   );
		});
	}
    for(i = 0; i < tr.length; ++i) tb.appendChild(tr[i]); // append each row in order
}

function makeSortable(table) {
    var th = table.tHead, i;
    th && (th = th.rows[0]) && (th = th.cells);
    if (th) i = th.length;
    else return; // if no `<thead>` then do nothing
    while (--i >= 0) (function (i) {
        var dir = 1;
        th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
    }(i));
}

function makeAllSortable(parent) {
    parent = parent || document.body;
    var t = parent.getElementsByTagName('table'), i = t.length;
    while (--i >= 0) makeSortable(t[i]);
}

window.onload = function () {makeAllSortable();};
</script>
 </head>
 <body>
 <h2>&nbsp;&nbsp;&nbsp;Kinerja RM untuk akuisisi Tabungan s/d periode ]=]..posisi_report1..[=[</h2>
 <table cellspacing='0'>
	<thead>
		<tr>
			<th>PN - Nama RM</th> 
]=])
for ii = 1, this_month do
	fo2:write('			<th>Bulan '..ii..'<br>(rekening)</th>')
end
fo2:write([=[
			<th>Total Rekening</th>
			<th>Total Saldo<br>(rupiah)</th>
		</tr>
	</thead>
	<tbody>
]=])
for k, v in pairs(list_RM) do
	fo2:write('			<tr><td>'..k..'</td>')
	for ii = 1, this_month do
		if v[ii] > 0 then
		fo2:write('			<td><a onclick="navigator.clipboard.writeText(this.title)" href="#" title="'..v[ii+12]..'">'..v[ii]..'</a></td>\n')
		else
		fo2:write('			<td>'..v[ii]..'</td>\n')
		end
	end
	fo2:write('			<td><b>'..v["total_account"]..'</b></td><td align="right"><b>'..format_number(v["total_balance"])..'</b></td></tr>')
end
fo2:write([=[
	</tbody>
 </table>
 <br>
 &nbsp;&nbsp;&nbsp;<b>Rekening Tabungan tanpa PN Pengelola</b><br>
 <textarea>]=]
 ..load_file(OUTPUT_NO_PN_FILE)..
 [=[</textarea>
 <br>
 &nbsp;&nbsp;&nbsp;Buka file dengan klik di <a href="]=]..OUTPUT_NO_PN_FILE..[=[">sini</a>
 <hr>
 <div align='center' style='font-size:smaller'>BRI Reporting Tool: DI319 EDW<br>Copyright &copy;2022, <b>Dhani Novan</b> (dhani_novan@bri.co.id)</div><br/>
</body>
</html>
]=])
fo2:close()
print('=== Done in '..(os.clock()-t1)..' ===')
os.execute(OUTPUT_FILE)
os.execute("pause")
