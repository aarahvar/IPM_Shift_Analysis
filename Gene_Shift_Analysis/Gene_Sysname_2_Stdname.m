function std_name= Gene_Sysname_2_Stdname(sys_name)

global gene_names_std;
global gene_names_sys;

num = find(ismember(gene_names_sys,lower(sys_name))==1);

if (isempty(num))
    std_name = '';
else
    std_name =  gene_names_std{num};
end












