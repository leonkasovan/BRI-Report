-- Lua Script : batch upload for entry QRIS data via agen.bri.co.id
-- Dhani Novan, 22 Agustus 2021, Otista
--dofile('strict.lua')
local field = {}
local sep = ';'

-- sl_ag_branch=3230&
--local sl_ag_branch = "0933" --form3
--now auto from account no

-- sl_mdr_stday=today date + 1
local sl_mdr_stday = os.date("%d", os.time()+86400)


-- csrf_test_name=1f065753c1da72b079a8fc70bb49e53f&
local csrf_test_name -- grabbed from generated Form

-- sl_signer=dki1_signer_mocash&
local sl_signer = "dki1_signer_mocash"

-- txt_ag_no_app=B.12%2FRWS-VIII%2FOPS%2F20%2F2021&
local txt_ag_no_app_start_no = 100 --form1
local txt_ag_no_app_format = "B.%d/MKR/OPS/"..os.date("%m/%Y")	-- replace / => %2F	form2

-- sl_pks_day=20&
local sl_pks_day = os.date("%d")

-- sl_pks_mth=08&
local sl_pks_mth = os.date("%m")

-- sl_pks_year=2021&
local sl_pks_year = os.date("%Y")

-- sl_ag_coo=&
local sl_ag_coo = ""

-- txt_ag_name=ADI+SUMAMAN&
-- local txt_ag_name = field[1]

-- sl_ag_type=30&
local sl_ag_type = "30"

-- sl_ag_type_ojk=1&
local sl_ag_type_ojk = "1"

-- sl_ag_tipe_usaha=999&
local sl_ag_tipe_usaha = "999"

-- poscode_jenisusahalp=525400&
local poscode_jenisusahalp = "525400"

-- txt_ag_usaha=DAGANG+SEPATU&
local txt_ag_usaha = "Perdagangan Umum"

-- txt_ag_siup=&
local txt_ag_siup = ""

-- txt_ag_owner=ADI&
-- local txt_ag_owner = field[2]

-- txt_ag_no_ktp=3304042507920002&
-- local txt_ag_no_ktp = field[4]

-- txt_ag_NPWP_1=&
local txt_ag_NPWP_1 = ""

-- txt_ag_NPWP_2=&
local txt_ag_NPWP_2 = ""

-- txt_ag_NPWP_3=&
local txt_ag_NPWP_3 = ""

-- txt_ag_NPWP_4=&
local txt_ag_NPWP_4 = ""

-- txt_ag_NPWP_5=&
local txt_ag_NPWP_5 = ""

-- txt_ag_NPWP_6=&
local txt_ag_NPWP_6 = ""

-- sl_ag_sex=laki-laki&
local sl_ag_sex = "laki-laki"

-- txt_ag_phone=081890330221&
-- local txt_ag_phone = field[5]

-- txt_ag_email=&
-- txt_ag_email = "kanca.otista@gmail.com"
local txt_ag_email = ""

-- txt_ag_add=BONJOK+&
-- local txt_ag_add = field[6]

-- sl_ag_almt_prov=31&
local sl_ag_almt_prov = "31"

-- sl_ag_almt_kab_kota=31.75&
local sl_ag_almt_kab_kota = "31.74"

-- sl_ag_almt_kec=31.75.06&
local sl_ag_almt_kec = "31.74.01"

-- sl_ag_almt_kel = 31.75.06.1005&
local sl_ag_almt_kel = "31.74.01.1002"

-- poscode_addag=13950&
--local poscode_addag = field[7]

-- txt_ag_picpn=00170403&
--local txt_ag_picpn = "00161631"
--local txt_ag_picpn = trim(field[8])

-- pic_name=1&
local pic_name = "1"

-- txt_ag_picnm=Pahlawan+Budi+Laksono&
--local txt_ag_picnm = "Miski Kamal Maeri"
--local txt_ag_picnm = trim(field[9])

-- chk_st_aufi=1&
local chk_st_aufi = "1"

-- txt_st_name=ADI+SUMAMAN&
-- local txt_st_name = field[2]

-- sl_st_type=00&
local sl_st_type = "00"

-- sl_st_kriteria=UMI&
local sl_st_kriteria = "UMI"

-- st_jenismcc=5999&
local st_jenismcc = "5999"

-- sl_st_mcag=2&
local sl_st_mcag = "2"

-- txt_st_url=&
local txt_st_url = ""

-- txt_st_phonotif=081890330221&
-- local txt_st_phonotif = field[5]

-- txt_st_email=&
local txt_st_email = ""

-- txt_st_account=323001019452539&
-- local txt_st_account = field[7]

-- txt_st_add=BONJOK+&
-- local txt_st_add = field[6]

-- sl_st_almt_prov=31&
local sl_st_almt_prov = sl_ag_almt_prov

-- sl_st_almt_kab_kota=31.75&
local sl_st_almt_kab_kota = sl_ag_almt_kab_kota

-- sl_st_almt_kec = 31.75.06&
local sl_st_almt_kec = sl_ag_almt_kec

-- sl_st_almt_kel=31.75.06.1005&
local sl_st_almt_kel = sl_ag_almt_kel

-- txt_sl_cpnm=ADI&
-- local txt_sl_cpnm = field[2]

-- txt_sl_cpphone=081890330221&
-- local txt_sl_cpphone = field[5]

-- rad_st_mdr=yes&
local rad_st_mdr = "yes"

-- sl_mdr_stmth=08&
local sl_mdr_stmth = os.date("%m")

-- sl_mdr_styea=2021&
local sl_mdr_styea = os.date("%Y")

-- rad_mdr_type=1&
local rad_mdr_type = "1"

-- txt_mdr_val=1&
local txt_mdr_val = "1"

-- rad_st_pro=no&
local rad_st_pro = "no"

-- sl_pr_stday=00&
local sl_pr_stday = "00"

-- sl_pr_stmth = 00&
local sl_pr_stmth = "00"

-- sl_pr_styea = 2021&
local sl_pr_styea = "2021"

-- sl_pr_fnday=00&
local sl_pr_fnday = "00"

-- sl_pr_fnmth = 00&
local sl_pr_fnmth = "00"

-- sl_pr_fnyea=2021&
local sl_pr_fnyea = "2021"

-- rad_pr_type=2&
local rad_pr_type = "2"

-- txt_pr_valbri=0&
local txt_pr_valbri = "0"

-- txt_pr_valmch=0&
local txt_pr_valmch = "0"

-- txt_pr_max=0&
local txt_pr_max = "0"

-- bt_submit=S+I+M+P+A+N
local bt_submit = "S+I+M+P+A+N"

local html_header = 
[=[
<!DOCTYPE html>
 <table cellspacing='0'>
		<tr>
			<th>Nama Merchant/Toko</th>
			<th>Nama Pemilik</th>
			<th>No Rekening</th>
			<th>NIK/Nomor KTP</th>
			<th>Nomor HP</th>
			<th>Alamat Usaha</th>
			<th>Kode Pos Usaha</th>
			<th>PN Prakarsa</th>
			<th>Nama Pemrakarsa</th>
			<th>Kode Agen</th>
		</tr>
]=]

local char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

function urlencode(url)
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w _%%%-%.~%/%:])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
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

function trim(s)
	return s:match "^%s*(.-)%s*$"
end

--[1]NAMA TOKO;[2]NAMA PEMILIK;[3]REKENING;[4]KTP;[5]TELEPON;[6]ALAMAT;[7]KODEPOS;[8]PN;[9]NAMA MANTRI;[10]ID AGEN
function GeneratePostData(field)
	local mytable = {};
	
	mytable[#mytable+1] = "csrf_test_name="..csrf_test_name
	mytable[#mytable+1] = "sl_signer="..sl_signer
	mytable[#mytable+1] = "txt_ag_no_app="..urlencode(string.format(txt_ag_no_app_format, txt_ag_no_app_start_no))
	mytable[#mytable+1] = "sl_pks_day="..sl_pks_day
	mytable[#mytable+1] = "sl_pks_mth="..sl_pks_mth
	mytable[#mytable+1] = "sl_pks_year="..sl_pks_year
	mytable[#mytable+1] = "sl_ag_coo="..sl_ag_coo
	mytable[#mytable+1] = "txt_ag_name="..urlencode(trim(field[1]))
	mytable[#mytable+1] = "sl_ag_type="..sl_ag_type
	mytable[#mytable+1] = "sl_ag_type_ojk="..sl_ag_type_ojk
	mytable[#mytable+1] = "sl_ag_tipe_usaha="..sl_ag_tipe_usaha
	mytable[#mytable+1] = "poscode_jenisusahalp="..poscode_jenisusahalp
	mytable[#mytable+1] = "txt_ag_usaha="..txt_ag_usaha
	mytable[#mytable+1] = "txt_ag_siup="..txt_ag_siup
	mytable[#mytable+1] = "txt_ag_owner="..urlencode(trim(field[2]))
	mytable[#mytable+1] = "txt_ag_no_ktp="..trim(field[4])
	mytable[#mytable+1] = "txt_ag_NPWP_1="..txt_ag_NPWP_1
	mytable[#mytable+1] = "txt_ag_NPWP_2="..txt_ag_NPWP_2
	mytable[#mytable+1] = "txt_ag_NPWP_3="..txt_ag_NPWP_3
	mytable[#mytable+1] = "txt_ag_NPWP_4="..txt_ag_NPWP_4
	mytable[#mytable+1] = "txt_ag_NPWP_5="..txt_ag_NPWP_5
	mytable[#mytable+1] = "txt_ag_NPWP_6="..txt_ag_NPWP_6
	mytable[#mytable+1] = "sl_ag_sex="..sl_ag_sex
	mytable[#mytable+1] = "txt_ag_phone="..trim(field[5])
	mytable[#mytable+1] = "txt_ag_email="..txt_ag_email
	mytable[#mytable+1] = "txt_ag_add="..urlencode(trim(field[6]))
	mytable[#mytable+1] = "sl_ag_almt_prov="..sl_ag_almt_prov
	mytable[#mytable+1] = "sl_ag_almt_kab_kota="..sl_ag_almt_kab_kota
	mytable[#mytable+1] = "sl_ag_almt_kec="..sl_ag_almt_kec
	mytable[#mytable+1] = "sl_ag_almt_kel="..sl_ag_almt_kel
	mytable[#mytable+1] = "poscode_addag="..trim(field[7])
	mytable[#mytable+1] = "sl_ag_branch="..trim(field[3]):sub(1,4)
	mytable[#mytable+1] = "txt_ag_picpn="..trim(field[8])
	mytable[#mytable+1] = "pic_name="..pic_name
	mytable[#mytable+1] = "txt_ag_picnm="..urlencode(trim(field[9]))
	mytable[#mytable+1] = "chk_st_aufi="..chk_st_aufi
	mytable[#mytable+1] = "txt_st_name="..urlencode(trim(field[1]))
	mytable[#mytable+1] = "sl_st_type="..sl_st_type
	mytable[#mytable+1] = "sl_st_kriteria="..sl_st_kriteria
	mytable[#mytable+1] = "st_jenismcc="..st_jenismcc
	mytable[#mytable+1] = "sl_st_mcag="..sl_st_mcag
	mytable[#mytable+1] = "txt_st_url="..txt_st_url
	mytable[#mytable+1] = "txt_st_phonotif="..trim(field[5])
	mytable[#mytable+1] = "txt_st_email="..txt_st_email
	mytable[#mytable+1] = "txt_st_account="..trim(field[3])
	mytable[#mytable+1] = "txt_st_add="..urlencode(trim(field[6]))
	mytable[#mytable+1] = "sl_st_almt_prov="..sl_st_almt_prov
	mytable[#mytable+1] = "sl_st_almt_kab_kota="..sl_st_almt_kab_kota
	mytable[#mytable+1] = "sl_st_almt_kec="..sl_st_almt_kec
	mytable[#mytable+1] = "sl_st_almt_kel="..sl_st_almt_kel
	mytable[#mytable+1] = "txt_sl_cpnm="..urlencode(trim(field[2]))
	mytable[#mytable+1] = "txt_sl_cpphone="..trim(field[5])
	mytable[#mytable+1] = "rad_st_mdr="..rad_st_mdr
	mytable[#mytable+1] = "sl_mdr_stday="..sl_mdr_stday
	mytable[#mytable+1] = "sl_mdr_stmth="..sl_mdr_stmth
	mytable[#mytable+1] = "sl_mdr_styea="..sl_mdr_styea
	mytable[#mytable+1] = "rad_mdr_type="..rad_mdr_type
	mytable[#mytable+1] = "txt_mdr_val="..txt_mdr_val
	mytable[#mytable+1] = "rad_st_pro="..rad_st_pro
	mytable[#mytable+1] = "sl_pr_stday="..sl_pr_stday
	mytable[#mytable+1] = "sl_pr_stmth="..sl_pr_stmth
	mytable[#mytable+1] = "sl_pr_styea="..sl_pr_styea
	mytable[#mytable+1] = "sl_pr_fnday="..sl_pr_fnday
	mytable[#mytable+1] = "sl_pr_fnmth="..sl_pr_fnmth
	mytable[#mytable+1] = "sl_pr_fnyea="..sl_pr_fnyea
	mytable[#mytable+1] = "rad_pr_type="..rad_pr_type
	mytable[#mytable+1] = "txt_pr_valbri="..txt_pr_valbri
	mytable[#mytable+1] = "txt_pr_valmch="..txt_pr_valmch
	mytable[#mytable+1] = "txt_pr_max="..txt_pr_max
	mytable[#mytable+1] = "bt_submit="..bt_submit
	return table.concat(mytable, '&')
end

function write_result(fname, data)
	local fo
	
	fo = io.open(fname,"a")
	if fo ~= nil then
		fo:write(data..'\n')
		fo:close()
	else
		fo = io.open(fname,"w")
		fo:write(string.format("[1]Nama Merchant/Toko%s[2]Nama Pemilik Rekening%s[3]No Rekening (wajib 15 digit)%s[4]Nomor KTP (wajib 16 digit)%s[5]Nomor HP untuk sms notifikasi%s[6]Alamat Usaha%s[7]Kode Pos Usaha%s[8]Personal Number%s[9]Nama Pemrakarsa%s[10]Kode Agen\n",sep,sep,sep,sep,sep,sep,sep,sep,sep))
		fo:write(data..'\n')
		fo:close()
	end
end
	
function write_result_as_htm(fname, data)
	local fo
	
	fo = io.open(fname..".htm","a")
	if fo ~= nil then
		fo:write(data..'\n')
		fo:close()
	else
		fo = io.open(fname..".htm","w")
		fo:write(html_header)
		fo:write(data..'\n')
		fo:close()
	end
end

function check_data(field)
	local err_desc
	
	if trim(field[5]):sub(1,2) ~= "08" then -- no HP
		err_desc = "Format No HP salah, harus diawali dengan 08xxxxxxxx"
		print(trim(field[5]), err_desc)
		return false, err_desc
	elseif #trim(field[3]) ~= 15 then -- Rekening
		err_desc = "Format No rekening salah, panjang HARUS 15 digit"
		print(trim(field[3]), err_desc)
		return false, err_desc
	elseif #trim(field[4]) ~= 16 then -- KTP
		err_desc = "Format NIK/No_KTP salah, panjang HARUS 16 digit"
		print(trim(field[4]), err_desc)
		return false, err_desc
	elseif trim(field[4]):sub(13,16) == "0000" then	-- KTP
		err_desc = "Format NIK/No_KTP salah, 4 digit belakang tidak boleh 0000"
		print(trim(field[4]), err_desc)
		return false, err_desc
	end
	return true, ""
end

res, dummy, txt_ag_no_app_start_no, txt_ag_no_app_format, QRIS_filename, cookies_filename = iup.GetParam("QRIS Batch Entry", nil, "Petunjuk: %m\nNo Awal Surat: %i\nFormat Surat: %s\nQRIS Data File: %f[OPEN|*.csv|CURRENT|NO|NO]\nCookies File: %f[OPEN|*.txt|CURRENT|NO|NO]\n"
,"1. Buka Aplikasi Portal Agen (https://agen.bri.co.id)\n2. Login dan masuk menu Tambah Data Agen\n3. Export cookie\n"
, txt_ag_no_app_start_no
, txt_ag_no_app_format
, "F:\\QRIS HTTP\\qris_data.csv"
, "F:\\QRIS HTTP\\cookies.txt")

if not res then print("User cancelled.") return end

local no = 1
local t1 = os.clock()
local n_gagal = 0
local n_sukses = 0
local rc, headers, content
http.set_conf(http.OPT_REFERER, 'https://agen.bri.co.id/agent/index.php/agent_branch/add_agent/1')
http.set_conf(http.OPT_TIMEOUT, 60)
http.set_conf(http.OPT_USERAGENT, 'Mozilla/5.0 (Windows NT 5.1; rv:47.0) Gecko/20100101 Firefox/47.0')
http.set_conf(http.OPT_COOKIEFILE, cookies_filename)
local res, err_code

for line in io.lines(QRIS_filename) do
	-- process header
	if no == 1 then
		sep = FindFirstSeparator(line)
	else -- process data
		field = csv.parse(line, sep)
		if field == nil then
			print('Error parsing CSV', line)
		else
		
		if field[1] ~= "" then
			print("Process data no "..(no-1).." Nama:"..field[1])
			res, err_desc = check_data(field)
			if res then
				 rc, headers, content = http.request('https://agen.bri.co.id/agent/index.php/agent_branch/add_agent/1')
				 if rc ~= 0 then
					 print("Error: "..http.error(rc), rc)
				 else
					 csrf_test_name = content:match('csrf_test_name" value="(%S+)"')
				 end

				 rc, headers, content = http.request('https://agen.bri.co.id/agent/index.php/agent_branch/add_agent/1', GeneratePostData(field))
				 if rc ~= 0 then
					 print("Error: "..http.error(rc), rc)
					 return false
				 end
				 kode_agen = content:match('agen <b>(%d+)</b>')
				 if kode_agen == nil then
					 local fo
					
					 fo = io.open("qris_fail.htm","w")	
					 if fo ~= nil then
						 fo:write(content)
						 fo:close()
					 end
					 
					 kode_agen = content:match('<div class="alert alert%-error">(.-)</div>')
					 if kode_agen == nil then kode_agen = "Gagal" end
					 print(string.format('%s GAGAL terupload: %s', field[1], kode_agen))
					 n_gagal = n_gagal + 1
				else
					print(string.format('%s sukses terupload dengan Agen ID = %s\n', field[1], kode_agen))
					n_sukses = n_sukses + 1
				 end
			 else
				kode_agen = err_desc
				n_gagal = n_gagal + 1
			 end
			 write_result(os.date("%Y%m%d").."_qris_result_"..trim(field[3]):sub(1,4)..".csv", string.format('"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"%s"', trim(field[1]), sep,trim(field[2]), sep, trim(field[3]), sep, trim(field[4]), sep, trim(field[5]), sep, trim(field[6]), sep, trim(field[7]), sep, trim(field[8]), sep, trim(field[9]), sep, kode_agen))
			txt_ag_no_app_start_no = txt_ag_no_app_start_no + 1
		end
		
		end
	end
	no = no + 1
end

print('=== Total upload '..(no-2)..' QRIS dalam waktu '..(os.clock()-t1)..' ===')
print('=== Total sukses '..n_sukses)
print('=== Total gagal '..n_gagal)

os.execute("pause")
