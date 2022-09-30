#!/usr/bin/env ruby

puts "This script takes 3 files: i) ensembl genes in one column file ii) 2 tab HGNC -> ENSEMBL; iii) HGNC -> semantic similarity tab file; iv) OPTIONAL. You can provide a file to translate ensembl from diferent organism (input genes ensembl must be first column)\n
USAGE:\n get_phenotypes_by_genes.rb ensembl_genes.txt HGNC_to_ensembl.txt HGNC_to_sim.txt [ensembl_ensembl]"


def load_and_index(file, index_col)
	indexed_file = {}
	p file
	File.open(file).each do |line| 
		line = line.chomp.split("\t")
		indexed_file[line[index_col]] = [] if indexed_file[line[index_col]].nil?
		#p line
		indexed_file[line.delete_at(index_col)] << line.first
	end
	return indexed_file
end




ensembl_genes = ARGV[0]
hgnc_to_ensembl = ARGV[1]
hgnc_to_sim = ARGV[2]
ensembl_ensembl = ARGV[3]

############ main

if !ensembl_ensembl.nil? 
	ensembl_ensembl_i = load_and_index(ensembl_ensembl, 0) 
end


ensembl_to_hgnc_i = load_and_index(hgnc_to_ensembl, 1)
hgnc_to_sim_i = load_and_index(hgnc_to_sim, 0)


File.open("ensembl_to_sem_sim.txt", 'w') do |output_file|
	File.open(ensembl_genes).each do |line|
		line.chomp!
		ensembl_sim = {}
		original_ensembl = line
		line = [line]
		#p ensembl_ensembl_i
		line = ensembl_ensembl_i[line.first] if !ensembl_ensembl_i.nil?
		next if line.nil?
		line.each do |ensembl_id|
			hgnc_ids = ensembl_to_hgnc_i[ensembl_id]
			next if hgnc_ids.nil?
			ensembl_sim[original_ensembl] = [] if ensembl_sim[original_ensembl].nil?
			hgnc_ids.each do |hgnc_id|
				next if hgnc_to_sim_i[hgnc_id].nil?
				ensembl_sim[original_ensembl] << hgnc_to_sim_i[hgnc_id].map(&:to_f)
			end
		end
		ensembl_sim.each do |ensembl_id, sim|
			next if sim.empty?
			sim.flatten!
			output_file.puts "#{ensembl_id}\t#{sim.first.to_s}"
   		end
	end
end

