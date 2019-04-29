set -ve -o pipefail
# You have to specify isoseq job root, e.g., replace the following 
#job_root=/pbi/dept/secondary/siv/smrtlink/smrtlink-alpha/smrtsuite_170220/userdata/jobs_root/042/042339/
if [  $# -eq  0 ]
  then 
    echo "Usage: isocollapse-on-merged-bam.sh isoseq_smrtlink_job_root"
    echo "e.g., "
    echo "bash isocollapse-on-merged-bam.sh /pbi/dept/secondary/siv/smrtlink/smrtlink-alpha/smrtsuite_170220/userdata/jobs_root/042/042339/"
    exit 1
fi 

job_root=$1
echo "SMRTLink IsoSeq job root directory is ${job_root}"

ls -1 ${job_root}/tasks/mapping.tasks.pbmm2_align-*/out.bam > fofn
samtools merge -b fofn merged.bam -@16 -p -c
samtools sort merged.bam -o merged.sorted.bam -@16
samtools index merged.sorted.bam -@16
pbindex merged.sorted.bam
dataset create --type TranscriptAlignmentSet merged.sorted.transcriptalignmentset.xml merged.sorted.bam
python reset-transcriptalignmentset.py  ${job_root}/tasks/isocollapse.tasks.collapse_mapped_isoforms-0/resolved-tool-contract.json merged.sorted.transcriptalignmentset.xml new.resolved-tool-contract.json
python -m isocollapse.tasks.collapse_mapped_isoforms --resolved-tool-contract new.resolved-tool-contract.json
# wait utill isocollapse finishes
ls out.gff
