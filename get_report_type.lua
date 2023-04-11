
local GIRO_HEADER_LIST = {
{"DWH-20-DI321", "periode,branch,curr,currdesc,acctno,status,sname,dlstm6,textbox1,textbox2,oddlim,accrue,odint,odunac,textbox3"},
{"DWH-7-DI321", "periode,branch,curr,currdesc,cifno,acctno,status,sname,dlstm6,textbox1,textbox2,oddlim,accrue,odint,odunac,textbox3,textbox8,textbox14"},
{"DI321MULTIPN", "periode,branch,curr,currdesc,cifno,acctno,status,sname,dlstm6,textbox1,textbox2,oddlim,accrue,odint,odunac,textbox3,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"},
{"EDW-176-DI321", "periode,branch,curr,currdesc,cifno,acctno,sccode,status,sname,dlstm6,datop7_dt,textbox1,textbox2,oddlim,accrue,odint,odunac,textbox3,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"},
{"EDW-176-DI321v2", "periode,branch,curr,currdesc,cifno,acctno,sccode,status,sname,dlstm6,datop7_dt,textbox1,textbox2,oddlim,accrue,odint,odunac,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"}
}
--EDW-176-DI321 field ke 17 masih sama dengan EDW-176-DI321v2
--penyesuaian:
-- EDW-176-DI321 f[1] = EDW-176-DI321v2 f[1]
-- EDW-176-DI321 f[17] = EDW-176-DI321v2 f[17]
-- EDW-176-DI321 f[19] = EDW-176-DI321v2 f[18]
-- EDW-176-DI321 f[27] = EDW-176-DI321v2 f[26]

local TABUNGAN_HEADER_LIST = {
{"DWH-2-DI319", 	"textbox16,textbox8,textbox14,textbox22,textbox15,textbox4,textbox38,textbox6,DLT,textbox2,BALANCE,AVAILBALANCE,INTCREDIT,ACCRUEINT,AVRGBALANCE,textbox11,textbox18,textbox23,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA"},
{"DI319MULTIPN", 	"textbox16,textbox8,textbox14,textbox22,textbox15,textbox4,textbox38,textbox6,DLT,textbox2,BALANCE,AVAILBALANCE,INTCREDIT,ACCRUEINT,AVRGBALANCE,textbox11,textbox18,textbox23,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"},
{"EDW-212-DI319/DWH-1-DI319",   "textbox16,textbox8,textbox14,textbox22,textbox15,textbox4,textbox38,DLT,textbox2,BALANCE,AVAILBALANCE,INTCREDIT,ACCRUEINT,AVRGBALANCE,textbox11,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"},
{"EDW-212-DI319/DWH-1-DI319v2", "textbox16,textbox8,textbox14,textbox22,textbox15,textbox4,textbox38,DLT,textbox2,BALANCE,AVAILBALANCE,INTCREDIT,ACCRUEINT,textbox11,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"}
}
--EDW-212-DI319/DWH-1-DI319 field ke 13 masih sama dengan EDW-212-DI319/DWH-1-DI319v2
--penyesuaian:
-- EDW-176-DI321 f[1] = EDW-176-DI321v2 f[1]
-- EDW-176-DI321 f[13] = EDW-176-DI321v2 f[13]
-- EDW-176-DI321 f[15] = EDW-176-DI321v2 f[14]
-- EDW-176-DI321 f[30] = EDW-176-DI321v2 f[29]

local PINJAMAN_HEADER_LIST = {
{"DWH-4-LW321", "textbox61,textbox49,textbox39,textbox26,textbox8,textbox10,textbox141,textbox11,textbox13,textbox16,textbox21,textbox18,textbox27,textbox24,textbox29,textbox32,textbox35,textbox31,textbox22,textbox42,textbox56,textbox76,textbox88,textbox99,textbox111,textbox40,textbox44,CODE,DESCRIPTION,KOL_ADK,AVG,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA"},
{"DWH-28-LW321", "textbox61,textbox49,textbox39,textbox26,textbox8,textbox10,textbox141,textbox11,textbox13,textbox16,textbox21,textbox18,textbox27,textbox24,textbox29,textbox32,textbox35,textbox31,textbox22,textbox42,textbox56,textbox76,textbox88,textbox99,textbox111"},
{"EDW-89-LW321", "Textbox47,BRANCH1,CURTYP,Textbox188,LNTYP,Textbox190,SNAME,PLAFON,SEGMEN,PRODUK,Textbox192,RATE_PROGAM1,TGL_AKAD,TGL_MAINTAIN,JGKWKT,FLGRES,CIFNO,LANCAR,DPK,KURANGLANCAR,DIRAGUKAN,MACET,POKOK,BUNGA,PINALTI,PN,Textbox204,CODE,DESCRIPTION,KOL_ADK,Textbox208,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA,DEFFERED_BUNGA,SAI_TUNGGAKAN,SAI_DEFFERED,FLAG_RESTRUK_COVID"},
{"EDW-90-LW321", "Textbox47,BRANCH1,CURTYP,Textbox188,LNTYP,Textbox190,SNAME,PLAFON,SEGMEN,PRODUK,Textbox192,RATE_PROGAM1,TGL_AKAD,TGL_MAINTAIN,JGKWKT,FLGRES,CIFNO,LANCAR,DPK,KURANGLANCAR,DIRAGUKAN,MACET,POKOK,BUNGA,PINALTI,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN,JUMLAH_PN_ALL,CODE,DESCRIPTION,KOL_ADK,Textbox208,KECAMATAN_T_TINGGAL,KELURAHAN_T_TINGGAL,KODEPOS_T_TINGGAL,KECAMATAN_T_USAHA,KELURAHAN_T_USAHA,KODEPOS_T_USAHA,DEFFERED_BUNGA,SAI_TUNGGAKAN,SAI_DEFFERED,FLAG_RESTRUK_COVID"},
{"EDW-190-LW321", "textbox61,textbox49,textbox39,textbox26,textbox8,textbox10,textbox141,textbox11,textbox13,textbox16,textbox21,textbox18,textbox27,textbox24,textbox29,textbox32,textbox35,textbox31,textbox22,textbox42,textbox56,textbox76,textbox88,textbox99,textbox111"}
}

local DEPOSITO_HEADER_LIST = {
{"DWH-26-CI324", "periode,branch,curr,currdesc,prodtype,acctno,serialno,princpamt,sname,wdrint,issuedt,matdt,rate,intdisp,textbox22"},
{"DWH-6-CI324", "periode,branch,curr,currdesc,prodtype,acctno,serialno,princpamt,sname,wdrint,issuedt,matdt,rate,intdisp,textbox22,CFAREF,SNAME_FO"},
{"EDW-216-CI324", "periode,branch,curr,currdesc,prodtype,acctno,serialno,princpamt,sname,wdrint,issuedt,matdt,rate,intdisp,textbox22,PN_Customer_Service,PN_RM_Dana,PN_RM_Pinjaman,PN_RM_Merchant,PN_Relationship_Officer,PN_Sales_Person,PN_PAB,PN_RM_Referral,JUMLAH_PN"}
}

function Get_Report_Type(header, filename)
	local report_type = nil
	local header_list = nil
	
	if filename:match('DI321') ~= nil then
		header_list = GIRO_HEADER_LIST
	elseif filename:match('DI319') ~= nil then
		header_list = TABUNGAN_HEADER_LIST
	elseif filename:match('LW321') ~= nil then
		header_list = PINJAMAN_HEADER_LIST
	elseif filename:match('CI324') ~= nil then
		header_list = DEPOSITO_HEADER_LIST
	end
	
	if header_list == nil then
		print("[Error] Nama file salah. Tidak mengandung DI319, DI321, LW321, CI324 ["..filename.."]")
		return nil
	end
	
	header = header:gsub(string.char(0x0D),'')
	header = header:gsub(string.char(0x0A),'')
	for i,v in pairs(header_list) do
		if header == v[2] or header == string.char(0xEF, 0xBB, 0xBF)..v[2] then
			report_type = v[1]
		end
	end
	return report_type
end