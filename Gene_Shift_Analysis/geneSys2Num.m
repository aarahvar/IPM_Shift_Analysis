function num = geneStd2Num (name)

global gene_names_sys;

num = find(ismember(gene_names_sys,lower(name))==1);

if (isempty(num))
    num = -1;
end
