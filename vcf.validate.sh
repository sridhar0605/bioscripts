#!/bin/bash

# validate vcf file against genome in a bottle calls for NA12878
# based on bcbio logs

# rtg manual
# https://github.com/RealTimeGenomics/rtg-tools/blob/master/installer/resources/tools/RTGOperationsManual.pdf


#bedtools intersect -nonamecheck -a NA12878-sort-callable_sample.bed -b GiaB_v2_19_regions.bed > NA12878-sort-callable_sample-NA12878-wrm.bed

#uses PASS variants only
export PATH=/hpf/largeprojects/ccmbio/naumenko/tools/bcbio/anaconda/bin:$PATH &&  \
   export RTG_JAVA_OPTS='-Xms750m' && export RTG_MEM=9100m && \
   rtg vcfeval --threads 5 -b /hpf/largeprojects/ccmbio/naumenko/tools/bcbio/genomes/Hsapiens/GRCh37/validation/giab-NA12878/truth_small_variants.vcf.gz \
   --bed-regions $2 \
   -c $1 \
   -t /hpf/largeprojects/ccmbio/naumenko/tools/bcbio/genomes/Hsapiens/GRCh37/rtg/GRCh37.sdf \
   -o rtg --vcf-score-field='GQ' 
#   --all-records

module load bcftools
for f in {tp-baseline,fp,fn};
do
    echo snp $f `bcftools view --types snps rtg/$f.vcf.gz | grep -vc "^#"` >> $1.stat
    echo indels $f `bcftools view --exclude-types snps rtg/$f.vcf.gz | grep -vc "^#"` >> $1.stat
done

