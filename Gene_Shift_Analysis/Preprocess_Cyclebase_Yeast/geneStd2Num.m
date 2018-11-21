function num = geneStd2Num (name)

global gene_names_std;

num = find(ismember(gene_names_std,lower(name))==1);

if (isempty(num))
    num = -1;
end
