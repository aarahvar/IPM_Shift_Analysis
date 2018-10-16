function num = geneStd2Num (name)

global gene_names_std;

num = find(ismember(gene_names_std,name)==1);

if (isempty(num))
    num = -1;
end
