import sys

def reduce(line):
	REVISION = line[6]
	DOB_YY = line[14:18]
	DOB_MM = line[18:20]
	DOB_WK = line[28]
	OTERR = line[29:31]
	OCNTY = line[36:39]
	OCNTY_POP = line[39]
	BFACIL = line[40]
	UBFACIL = line[41]
	BFACIL3 = line[58]
	MAGE_IMPFLG = line[86]
	MAGE_REPFLG = line[87]
	MAGER = line[88:90]
	MAGER14 = line[90:92]
	MAGER9 = line[92]
	MBCNTRY = line[93:95]
	MRTERR = line[108:110]
	MRCNTY = line[113:116]
	RCNTY_POP = line[131]
	RECTYPE = line[136]
	RESTATUS = line[137]
	MBRACE = line[138:140]
	MRACE = line[140:142]
	MRACEREC = line[142]
	MRACEIMP = line[143]
	UMHISP = line[147]
	MRACEHISP = line[148]
	MAR = line[152]
	MAR_IMP = line[153]
	MEDUC = line[154]
	DMEDUC = line[155:157]
	MEDUC_REC = line[157]
	FAGERPT_FLG = line[174]
	FAGECOMB = line[181:183]
	UFAGECOMB = line[183:185]
	FAGEREC11 = line[185:187]
	FBRACE = line[187:189]
	FRACEREC = line[190]
	UFHISP = line[194]
	FRACEHISP = line[195]
	FRACE = line[198:200]
	LBO_REC = line[211]
	TBO_REC = line[216]
	DLLB_MM = line[219:221]
	DLLB_YY = line[221:225]
	PRECARE = line[244:246]
	PRECARE_REC = line[246]
	MPCB = line[255:257]
	MPCP_REC6 = line[257]
	MPCP_REC5 = line[258]
	UPREVIS = line[269:271]
	PREVIS_REC = line[271:273]
	WTGAIN = line[275:277]
	WTGAIN_REC = line[277]
	DFPC_IMP = line[279]
	CIG_1 = line[283:285]
	CIG_2 = line[285:287]
	CIG_3 = line[287:289]
	TOBUSE = line[289]
	CIGS = line[290:292]
	CIG_REC6 = line[292]
	CIG_REC = line[293]
	PWGT = line[304:307]
	DWGT = line[308:311]
	RF_DIAB = line[312]
	RF_GEST = line[313]
	RF_PHYP = line[314]
	RF_GHYP = line[315]
	RF_ECLAM = line[316]
	RF_PPTERM = line[317]
	RF_PPOUTC = line[318]
	RF_CESAR = line[323]
	RF_CESARN = line[324:326]
	URF_DIAB = line[330]
	URF_CHYPER = line[334]
	URF_PHYPER = line[335]
	URF_ECLAM = line[336]
	OP_CERV = line[350]
	OP_TOCOL = line[351]
	OP_ECVS = line[352]
	OP_ECVF = line[353]
	UOP_INDUC = line[356]
	UOP_TOCOL = line[358]
	ON_RUPTR = line[361]
	ON_PRECIP = line[362]
	ON_PROL = line[363]
	LD_INDL = line[364]
	LD_AUGM = line[365]
	LD_NVPR = line[366]
	LD_STER = line[367]
	LD_ANTI = line[368]
	LD_CHOR = line[369]
	LD_MECS = line[370]
	LD_FINT = line[371]
	LD_ANES = line[372]
	ULD_MECO = line[374]
	ULD_PRECIP = line[380]
	ULD_BREECH = line[383]
	ME_ATTF = line[389]
	ME_ATTV = line[390]
	ME_PRES = line[391]
	ME_ROUT = line[392]
	ME_TRIAL = line[393]
	UME_VAG = line[394]
	UME_VBAC = line[395]
	UME_PRIMC = line[396]
	UME_REPEC = line[397]
	UME_FORCP = line[398]
	UME_VAC = line[399]
	RDMETH_REC = line[400]
	UDMETH_REC = line[401]
	DMETH_REC = line[402]
	ATTEND = line[409]
	APGAR5 = line[414:416]
	APGAR5R = line[416]
	DPLURAL = line[422]
	IMP_PLUR = line[424]
	SEX = line[435]
	IMP_SEX = line[436]
	DLMP_MM = line[437:439]
	DLMP_DD = line[439:441]
	DLMP_YY = line[441:445]
	ESTGEST = line[445:447]
	COMBGEST = line[450:452]
	GESTREC10 = line[452:454]
	GESTREC3 = line[454]
	OBGEST_FLG = line[455]
	GEST_IMP = line[456]
	DBWT = line[462:466]
	BWTR12 = line[470:472]
	BWTR4 = line[472]
	AB_AVEN1 = line[475]
	AB_AVEN6 = line[476]
	AB_NICU = line[477]
	AB_SURF = line[478]
	AB_ANTI = line[479]
	AB_SEIZ = line[480]
	AB_BINJ = line[481]
	CA_ANEN = line[491]
	CA_MNSB = line[492]
	CA_CCHD = line[493]
	CA_CDH = line[494]
	CA_OMPH = line[495]
	CA_GAST = line[496]
	CA_LIMB = line[497]
	CA_CLEFT = line[498]
	CA_CLPAL = line[499]
	CA_DOWNS = line[500]
	CA_DISOR = line[501]
	CA_HYPO = line[502]
	UCA_ANEN = line[503]
	UCA_SPINA = line[504]
	UCA_OMPHA = line[512]
	UCA_CELFTLP = line[517]
	UCA_HERNIA = line[520]
	UCA_DOWNS = line[522]
	F_MORIGIN = line[568]
	F_FORIGIN = line[569]
	F_MEDUC = line[570]
	F_CLINEST = line[572]
	F_APGAR5 = line[573]
	F_TOBACO = line[574]
	F_PWGT = line[576]
	F_DWGT = line[577]
	F_RF_PDIAB = line[581]
	F_RF_GDIAB = line[582]
	F_RF_PHYPER = line[583]
	F_RF_GHYPER = line[584]
	F_RF_ECLAMP = line[585]
	F_RF_PPB = line[586]
	F_RF_PPO = line[587]
	F_RF_CESAR = line[592]
	F_RF_NCESAR = line[593]
	F_OB_CERVIC = line[600]
	F_OB_TOCO = line[601]
	F_OB_SUCC = line[602]
	F_OB_FAIL = line[603]
	F_OL_RUPTURE = line[604]
	F_OL_PRECIP = line[605]
	F_OL_PROLONG = line[606]
	F_LD_INDUCT = line[607]
	F_LD_AUGMENT = line[608]
	F_LD_NVRTX = line[610] ##
	F_LD_STEROIDS = line[610]
	F_LD_ANTIBIO = line[611]
	F_LD_CHORIO = line[612]
	F_LD_MECON = line[613]
	F_LD_FINTOL = line[614]
	F_LD_ANESTH = line[615]
	F_MD_ATTFOR = line[616] ##
	F_MD_ATTVAC = line[617] ##
	F_MD_PRESENT = line[618]
	F_MD_ROUTE = line[619]
	F_MD_TRIAL = line[620]
	F_AB_VENT = line[627]
	F_AB_VENT6 = line[628]
	F_AB_NIUC = line[629]
	F_AB_SURFAC = line[630]
	F_AB_ANTIBIO = line[631]
	F_AB_SEIZ = line[632]
	F_AB_INJ = line[633]
	F_CA_ANEN = line[634]
	F_CA_MENIN = line[635]
	F_CA_HEART = line[636]
	F_CA_HERNIA = line[637]
	F_CA_OMPHA = line[638]
	F_CA_GASTRO = line[639]
	F_CA_LIMB = line[640]
	F_CA_CLEFTLP = line[641]
	F_CA_CLEFT = line[642]
	F_CA_DOWNS = line[643]
	F_CA_CHROM = line[644]
	F_CA_HYPOS = line[645]
	F_MED = line[646]
	F_WTGAIN = line[647]
	F_TOBAC = line[666]
	F_MPCB = line[667]
	F_MPCB_U = line[668]
	F_URF_DIABETES = line[683]
	F_URF_CHYPER = line[687]
	F_URF_PHYPER = line[688]
	F_URF_ECLAMP = line[689]
	F_UOB_INDUCT = line[702]
	F_UOB_TOCOL = line[704]
	F_ULD_MECONIUM = line[711]
	F_ULD_PRECIP = line[717]
	F_ULD_BREECH = line[720]
	F_U_VAGINAL = line[729]
	F_U_VBAC = line[730]
	F_U_PRIMAC = line[731]
	F_U_REPEAC = line[732]
	F_U_FORCEP = line[733]
	F_U_VACUUM = line[734]
	F_UCA_ANEN = line[751]
	F_UCA_SPINA = line[752]
	F_UCA_OMPHALO = line[760]
	F_UCA_CLEFTLP = line[765]
	F_UCA_HERNIA = line[768]
	F_UCA_DOWNS = line[770]
	
	print "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s" % (REVISION, DOB_YY, DOB_MM, DOB_WK, OTERR, OCNTY, OCNTY_POP, BFACIL, UBFACIL, BFACIL3, MAGE_IMPFLG, MAGE_REPFLG, MAGER, MAGER14, MAGER9, MBCNTRY, MRTERR, MRCNTY, RCNTY_POP, RECTYPE, RESTATUS, MBRACE, MRACE, MRACEREC, MRACEIMP, UMHISP, MRACEHISP, MAR, MAR_IMP, MEDUC, DMEDUC, MEDUC_REC, FAGERPT_FLG, FAGECOMB, UFAGECOMB, FAGEREC11, FBRACE, FRACEREC, UFHISP, FRACEHISP, FRACE, LBO_REC, TBO_REC, DLLB_MM, DLLB_YY, PRECARE, PRECARE_REC, MPCB, MPCP_REC6, MPCP_REC5, UPREVIS, PREVIS_REC, WTGAIN, WTGAIN_REC, DFPC_IMP, CIG_1, CIG_2, CIG_3, TOBUSE, CIGS, CIG_REC6, CIG_REC, PWGT, DWGT, RF_DIAB, RF_GEST, RF_PHYP, RF_GHYP, RF_ECLAM, RF_PPTERM, RF_PPOUTC, RF_CESAR, RF_CESARN, URF_DIAB, URF_CHYPER, URF_PHYPER, URF_ECLAM, OP_CERV, OP_TOCOL, OP_ECVS, OP_ECVF, UOP_INDUC, UOP_TOCOL, ON_RUPTR, ON_PRECIP, ON_PROL, LD_INDL, LD_AUGM, LD_NVPR, LD_STER, LD_ANTI, LD_CHOR, LD_MECS, LD_FINT, LD_ANES, ULD_MECO, ULD_PRECIP, ULD_BREECH, ME_ATTF, ME_ATTV, ME_PRES, ME_ROUT, ME_TRIAL, UME_VAG, UME_VBAC, UME_PRIMC, UME_REPEC, UME_FORCP, UME_VAC, RDMETH_REC, UDMETH_REC, DMETH_REC, ATTEND, APGAR5, APGAR5R, DPLURAL, IMP_PLUR, SEX, IMP_SEX, DLMP_MM, DLMP_DD, DLMP_YY, ESTGEST, COMBGEST, GESTREC10, GESTREC3, OBGEST_FLG, GEST_IMP, DBWT, BWTR12, BWTR4, AB_AVEN1, AB_AVEN6, AB_NICU, AB_SURF, AB_ANTI, AB_SEIZ, AB_BINJ, CA_ANEN, CA_MNSB, CA_CCHD, CA_CDH, CA_OMPH, CA_GAST, CA_LIMB, CA_CLEFT, CA_CLPAL, CA_DOWNS, CA_DISOR, CA_HYPO, UCA_ANEN, UCA_SPINA, UCA_OMPHA, UCA_CELFTLP, UCA_HERNIA, UCA_DOWNS, F_MORIGIN, F_FORIGIN, F_MEDUC, F_CLINEST, F_APGAR5, F_TOBACO, F_PWGT, F_DWGT, F_RF_PDIAB, F_RF_GDIAB, F_RF_PHYPER, F_RF_GHYPER, F_RF_ECLAMP, F_RF_PPB, F_RF_PPO, F_RF_CESAR, F_RF_NCESAR, F_OB_CERVIC, F_OB_TOCO, F_OB_SUCC, F_OB_FAIL, F_OL_RUPTURE, F_OL_PRECIP, F_OL_PROLONG, F_LD_INDUCT, F_LD_AUGMENT, F_LD_STEROIDS, F_LD_ANTIBIO, F_LD_CHORIO, F_LD_MECON, F_LD_FINTOL, F_LD_ANESTH, F_MD_ATTFOR, F_MD_ATTVAC, F_MD_PRESENT, F_MD_ROUTE, F_MD_TRIAL, F_AB_VENT, F_AB_VENT6, F_AB_NIUC, F_AB_SURFAC, F_AB_ANTIBIO, F_AB_SEIZ, F_AB_INJ, F_CA_ANEN, F_CA_MENIN, F_CA_HEART, F_CA_HERNIA, F_CA_OMPHA, F_CA_GASTRO, F_CA_LIMB, F_CA_CLEFTLP, F_CA_CLEFT, F_CA_DOWNS, F_CA_CHROM, F_CA_HYPOS, F_MED, F_WTGAIN, F_TOBAC, F_MPCB, F_MPCB_U, F_URF_DIABETES, F_URF_CHYPER, F_URF_PHYPER, F_URF_ECLAMP, F_UOB_INDUCT, F_UOB_TOCOL, F_ULD_MECONIUM, F_ULD_PRECIP, F_ULD_BREECH, F_U_VAGINAL, F_U_VBAC, F_U_PRIMAC, F_U_REPEAC, F_U_FORCEP, F_U_VACUUM, F_UCA_ANEN, F_UCA_SPINA, F_UCA_OMPHALO, F_UCA_CLEFTLP, F_UCA_HERNIA, F_UCA_DOWNS)
	

def main():
	data = open(sys.argv[1])
	print "REVISION, DOB_YY, DOB_MM, DOB_WK, OTERR, OCNTY, OCNTY_POP, BFACIL, UBFACIL, BFACIL3, MAGE_IMPFLG, MAGE_REPFLG, MAGER, MAGER14, MAGER9, MBCNTRY, MRTERR, MRCNTY, RCNTY_POP, RECTYPE, RESTATUS, MBRACE, MRACE, MRACEREC, MRACEIMP, UMHISP, MRACEHISP, MAR, MAR_IMP, MEDUC, DMEDUC, MEDUC_REC, FAGERPT_FLG, FAGECOMB, UFAGECOMB, FAGEREC11, FBRACE, FRACEREC, UFHISP, FRACEHISP, FRACE, LBO_REC, TBO_REC, DLLB_MM, DLLB_YY, PRECARE, PRECARE_REC, MPCB, MPCP_REC6, MPCP_REC5, UPREVIS, PREVIS_REC, WTGAIN, WTGAIN_REC, DFPC_IMP, CIG_1, CIG_2, CIG_3, TOBUSE, CIGS, CIG_REC6, CIG_REC, PWGT, DWGT, RF_DIAB, RF_GEST, RF_PHYP, RF_GHYP, RF_ECLAM, RF_PPTERM, RF_PPOUTC, RF_CESAR, RF_CESARN, URF_DIAB, URF_CHYPER, URF_PHYPER, URF_ECLAM, OP_CERV, OP_TOCOL, OP_ECVS, OP_ECVF, UOP_INDUC, UOP_TOCOL, ON_RUPTR, ON_PRECIP, ON_PROL, LD_INDL, LD_AUGM, LD_NVPR, LD_STER, LD_ANTI, LD_CHOR, LD_MECS, LD_FINT, LD_ANES, ULD_MECO, ULD_PRECIP, ULD_BREECH, ME_ATTF, ME_ATTV, ME_PRES, ME_ROUT, ME_TRIAL, UME_VAG, UME_VBAC, UME_PRIMC, UME_REPEC, UME_FORCP, UME_VAC, RDMETH_REC, UDMETH_REC, DMETH_REC, ATTEND, APGAR5, APGAR5R, DPLURAL, IMP_PLUR, SEX, IMP_SEX, DLMP_MM, DLMP_DD, DLMP_YY, ESTGEST, COMBGEST, GESTREC10, GESTREC3, OBGEST_FLG, GEST_IMP, DBWT, BWTR12, BWTR4, AB_AVEN1, AB_AVEN6, AB_NICU, AB_SURF, AB_ANTI, AB_SEIZ, AB_BINJ, CA_ANEN, CA_MNSB, CA_CCHD, CA_CDH, CA_OMPH, CA_GAST, CA_LIMB, CA_CLEFT, CA_CLPAL, CA_DOWNS, CA_DISOR, CA_HYPO, UCA_ANEN, UCA_SPINA, UCA_OMPHA, UCA_CELFTLP, UCA_HERNIA, UCA_DOWNS, F_MORIGIN, F_FORIGIN, F_MEDUC, F_CLINEST, F_APGAR5, F_TOBACO, F_PWGT, F_DWGT, F_RF_PDIAB, F_RF_GDIAB, F_RF_PHYPER, F_RF_GHYPER, F_RF_ECLAMP, F_RF_PPB, F_RF_PPO, F_RF_CESAR, F_RF_NCESAR, F_OB_CERVIC, F_OB_TOCO, F_OB_SUCC, F_OB_FAIL, F_OL_RUPTURE, F_OL_PRECIP, F_OL_PROLONG, F_LD_INDUCT, F_LD_AUGMENT, F_LD_STEROIDS, F_LD_ANTIBIO, F_LD_CHORIO, F_LD_MECON, F_LD_FINTOL, F_LD_ANESTH, F_MD_ATTFOR, F_MD_ATTVAC, F_MD_PRESENT, F_MD_ROUTE, F_MD_TRIAL, F_AB_VENT, F_AB_VENT6, F_AB_NIUC, F_AB_SURFAC, F_AB_ANTIBIO, F_AB_SEIZ, F_AB_INJ, F_CA_ANEN, F_CA_MENIN, F_CA_HEART, F_CA_HERNIA, F_CA_OMPHA, F_CA_GASTRO, F_CA_LIMB, F_CA_CLEFTLP, F_CA_CLEFT, F_CA_DOWNS, F_CA_CHROM, F_CA_HYPOS, F_MED, F_WTGAIN, F_TOBAC, F_MPCB, F_MPCB_U, F_URF_DIABETES, F_URF_CHYPER, F_URF_PHYPER, F_URF_ECLAMP, F_UOB_INDUCT, F_UOB_TOCOL, F_ULD_MECONIUM, F_ULD_PRECIP, F_ULD_BREECH, F_U_VAGINAL, F_U_VBAC, F_U_PRIMAC, F_U_REPEAC, F_U_FORCEP, F_U_VACUUM, F_UCA_ANEN, F_UCA_SPINA, F_UCA_OMPHALO, F_UCA_CLEFTLP, F_UCA_HERNIA, F_UCA_DOWNS"
	for line in data:
		reduce(line)
		

if __name__ == '__main__':
	main()
