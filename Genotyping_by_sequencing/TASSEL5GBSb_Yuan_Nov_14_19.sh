#!/bin/sh

minQuaScore=0
coverage=0.1 #percent of Taxa that need data
mnMAF=0.05
minQual=0
minPosQS=0
tassel=/home/lilabuser/sf_docs/programs/tassel/tassel-5-standalone/run_pipeline.pl
#Tetraploid wheat
loc=/home/lilabuser/sf_docs/wheat/TASSELGBS/temp_raw_sequence
db=/home/lilabuser/sf_docs/wheat/TASSELGBS/durumGBS5.db
key=/media/sf_docs/wheat/TASSELGBS/keyfile/GBS-52_key_file.txt
length=80
enzyme=PstI

# #Other
# loc=/media/sf_docs/canola/TASSELGBS/temp_sequence
# db=/media/sf_docs/canola/TASSELGBS/canola_core.db
# key=/media/sf_docs/canola/TASSELGBS/keyfile/Canola_core_keyfile.txt
# length=64
# enzyme=ApeKI


# 	#Step1 Fastq to DB Tag

#  $tassel -Xms5G -Xmx80G -fork1 -GBSSeqToTagDBPlugin -e $enzyme -i $loc -db $db -k $key -kmerLength $length -minKmerL 0 -mnQS $minQuaScore -mxKmerNum 100000000 -deleteOldData true -endPlugin -runfork1

#  #Step2 DB to fastq

#  $tassel -Xms5G -Xmx80G -fork1 -TagExportToFastqPlugin -db $db -o tagsforAlign.fa.gz -c 1 -endPlugin -runfork1

#  #Step3 align to reference
# # #Wheat
# # ref=/home/lilabuser/sf_docs/refs/wheat/ta_WGA_v1/CSv1_pm
# # #bwa aln -t 11 $ref tagsforAlign.fa.gz > tagsForAlign.sai
# #   #bwa samse $ref tagsForAlign.sai tagsforAlign.fa.gz > tagsForAlign.sam
# #   #grep -v "@" tagsForAlign.sam | awk -F"\t" 'BEGIN{print "flag\toccurrences"} {a[$2]++} END{for(i in a)print i"\t"a[i]}' >> samflags

# # 	#bowtie2 alignment
# #  gzip -k -d tagsforAlign.fa.gz
# #  bowtie2 -p 12 --very-sensitive -x /home/lilabuser/sf_docs/refs/wheat/ta_WGA_v1/CSv1_pm -U tagsforAlign.fa -S tagsforAlign.sam
rm tagsforAlign.fa*

# #Other species
#  gzip -k -d tagsforAlign.fa.gz
#  bowtie2 -p 12 --very-sensitive -x /home/lilabuser/sf_docs/refs/canola/canola_v4.1 -U tagsforAlign.fa -S tagsforAlign.sam



#  	#Step4 back to DB
#  $tassel -Xms5G -Xmx80G -fork1 -SAMToGBSdbPlugin -i tagsForAlign.sam -db $db -aProp 0.0 -aLen 0 -endPlugin -runfork1

# # 	#Step5 call SNPs
#  $tassel -Xms5G -Xmx80G -fork1 -DiscoverySNPCallerPluginV2 -db $db -mnLCov $coverage -mnMAF $mnMAF -deleteOldData false -endPlugin -runfork1

# # 	#Step 6 SNP stats
#  $tassel -Xms5G -Xmx80G -fork1 -SNPQualityProfilerPlugin -db $db -statFile SNPstats.Cov.$coverage.MAF.$mnMAF -deleteOldData false -endPlugin -runfork1

#  qsFile= some manipulation of outputStats.txt # Tab-delimited Headers CHROM	POS	QUALITYSCORE

# # 	#Step 7 Using OutputStats.txt, user-supplied position quality scores can be added to the database
#  $tassel -Xms5G -Xmx80G -fork1 -UpdateSNPPositionQualityPlugin -db $db -qsFile $qsFile -endPlugin -runfork1

# # 	# Taxa distribution of single sites. Loop to determine areas I suppose
# # chr=4a
# # pos=345267

# # #$tasselv -Xms5G -Xmx80G -fork1 -SNPCutPosTagVerificationPlugin -db $db -chr $chr -pos $pos -type snp -outFile ${chr}_${pos}.out -endPlugin -runfork1

#  	#output db to tab-delimited
#  #$tassel -Xms5G -Xmx80G -fork1 -GetTagSequenceFromDBPlugin -db $db -o allTags.out -endPlugin -runfork1



# 	#Production Caller - once we have a bunch of good SNPs in the db, go from fastq to vcf in one step
 $tassel -Xms5G -Xmx80G -fork1 -ProductionSNPCallerPluginV2 -db $db -e $enzyme -minPosQS $minQual -i $loc -k $key -mnQS $minQuaScore -kmerLength $length -o ${key}Cov${coverage}.MAF${mnMAF}.vcf -endPlugin -runfork1

#vcftools --vcf Cov0.1.MAF0.01.vcf --minDP 2 --recode --out Cov0.1MAF0.01MinDP2
 
#vcftools --vcf Cov0.1MAF0.01MinDP2.recode.vcf --snps ../AYT/AYT_12_17_GS_markers/marker_name_list.txt --recode --out Cov0.1MAF0.01MinDP2PreviousSites

#convert hets to missing, refilter for coverage- Hapmap
#$tassel -Xms5G -Xmx80G -fork1 -vcf Cov0.1MAF0.01MinDP2PreviousSites.recode.vcf -homozygous  -export Cov0.1MAF0.01MinDP2PreviousSitesNoHet -exportType Hapmap -runfork1
#tassel -Xms5G -Xmx80G -fork1 -vcf Cov0.1MAF0.01MinDP2.recode.vcf -homozygous  -export Cov0.1MAF0.01MinDP2NoHet -exportType Hapmap -runfork1

#convert hets to missing, refilter for coverage- vcf
#$tassel -Xms5G -Xmx80G -fork1 -vcf $input -homozygous -export $pre.C${coverage}.nh -exportType VCF -runfork1



















