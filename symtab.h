#define SIZE 211
 
#define MAXTOKENLEN 40

#define UNDEF 0
#define INT_TYPE 1
#define CHAR_TYPE 2
#define FUNCTION_TYPE 6
 
#define BY_VALUE 1
#define BY_REFER 2
 

typedef struct Param{
    int par_type;
    char param_name[MAXTOKENLEN];
    int ival; double fval; char *st_sval;
    int passing; 
}Param;
 
typedef struct RefList{ 
    int lineno;
    struct RefList *next;
    int type;
}RefList;
 
typedef struct list_t{
    char st_name[MAXTOKENLEN];
    int st_size;
    int scope;
    RefList *lines;
    int st_ival; double st_fval; char *st_sval;
    int st_type;

    int *i_vals; double *f_vals; char **s_vals;
    int array_size;

    Param *parameters;
    int num_of_pars;

    struct list_t *next;
}list_t;
 

static list_t **hash_table;
 

void init_hash_table(); 
unsigned int hash(char *key); 
void insert(char *name, int len, int type, int lineno); 
list_t *lookup(char *name);
list_t *lookup_scope(char *name, int scope);
void hide_scope(); 
void incr_scope(); 
void symtab_dump(FILE *of); 
