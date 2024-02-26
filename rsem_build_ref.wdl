version 1.0

# A WDL task to build RSEM reference
task task_build_rsem_reference {
    input {
        String genome_name = "rsem"
        File genome_annotation_gtf
        File genome_fasta

        # Runtime option
        Int? memory_gb
        Int? threads
    }
    command {
        set -e
        rsem-prepare-reference -p ${threads} --gtf ${genome_annotation_gtf} ${genome_fasta} ${genome_name}
    }

    # Define output prefix
    String prefix = "${genome_name}"

    output {
        File ref_chrlist= "${prefix}.chrlist"
        File ref_grp= "${prefix}.grp"
        File idx_fa= "${prefix}.idx.fa"
        File n2g_idx_fa= "${prefix}.n2g.idx.fa"
        File seq= "${prefix}.seq"
        File ti= "${prefix}.ti"
        File transcripts_fa= "${prefix}.transcripts.fa"
    }
    runtime {
        docker: "biocontainers/rsem:v1.3.1dfsg-1-deb_cv1"
        # local test
        # docker: "niccwwy/rsem_arm:latest"
        memory: "${memory_gb}GB"
        cpu: "${threads}"
        maxRetries: 0
    }
}

# Add workflow and call task directly

workflow build_rsem_reference {
    input {
        File genome_annotation_gtf
        File genome_fasta
        String genome_name = "rsem"
        Int? memory_gb
        Int? threads
    }

    meta {
        version: 'v0.1'
            author: 'Nicola Wong (w.wong@garvan.org.au) @ Garvan Institute of Medical Research - Computational Biology'
            description: 'RSEM build reference'
    }
    
    call task_build_rsem_reference{
        input:
            genome_annotation_gtf = genome_annotation_gtf,
            genome_fasta = genome_fasta,
            genome_name = genome_name,
            memory_gb = memory_gb,
            threads = threads
    }
    
    output {
        File ref_chrlist= task_build_rsem_reference.ref_chrlist
        File ref_grp= task_build_rsem_reference.ref_grp
        File idx_fa= task_build_rsem_reference.idx_fa
        File n2g_idx_fa= task_build_rsem_reference.n2g_idx_fa
        File seq= task_build_rsem_reference.seq
        File ti= task_build_rsem_reference.ti
        File transcripts_fa= task_build_rsem_reference.transcripts_fa
    }
}

