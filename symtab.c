#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

int cur_scope = 0;
 
void init_hash_table(){
    int i; 
    hash_table = malloc(SIZE * sizeof(list_t*));
    
    for(i = 0; i < SIZE; i++) {
        hash_table[i] = NULL;
    }
}
 
unsigned int hash(char *key){
    unsigned int hashval = 0;
    for(;*key!='\0';key++) {
        hashval += *key;
    } 
    hashval += key[0] % 11 + (key[0] << 3) - key[0];
    
    return hashval % SIZE;
}
 
void insert(char *name, int len, int type, int lineno){
    unsigned int hashval = hash(name);
    list_t *l = hash_table[hashval];
    
    while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
    
    /* nueva file */
    if (l == NULL){
        l = (list_t*) malloc(sizeof(list_t));
        strncpy(l->st_name, name, len);  
        l->st_type = type;
        l->scope = cur_scope;
        l->lines = (RefList*) malloc(sizeof(RefList));
        l->lines->lineno = lineno;
        l->lines->next = NULL;
        l->next = hash_table[hashval];
        hash_table[hashval] = l; 
    }
    /* cuando ya existe */
    else{
        l->scope = cur_scope;
        RefList *t = l->lines;
        while (t->next != NULL) t = t->next;
        t->next = (RefList*) malloc(sizeof(RefList));
        t->next->lineno = lineno;
        t->next->next = NULL;
    }
}
 
list_t *lookup(char *name){ 
    unsigned int hashval = hash(name);
    list_t *l = hash_table[hashval];
    while ((l != NULL) && (strcmp(name,l->st_name) != 0)) {
        l = l->next;
    }
    
    return l;
}
 
list_t *lookup_scope(char *name, int scope){
    unsigned int hashval = hash(name);
    list_t *l = hash_table[hashval];
    while ((l != NULL) && (strcmp(name,l->st_name) != 0) && (scope != l->scope)) {
        l = l->next;
    } 
    
    return l; 
}
 
void hide_scope(){
    if(cur_scope > 0) {
        cur_scope--;
    }
}
 
void incr_scope(){ 
    cur_scope++;
}
 
void symtab_dump(FILE * of){  
  fprintf(of,"Nombre                 Tipo           Linea\n");
  fprintf(of,"----------------- ----------------- ---------\n");
  
  for (int i=0; i < SIZE; ++i){ 
    if (hash_table[i] != NULL){ 
        list_t *l = hash_table[i];
        while (l != NULL){ 
            RefList *t = l->lines;
            fprintf(of,"%s ",l->st_name);
            
            if (l->st_type == INT_TYPE) {
                fprintf(of,"%s","int");
            } else if (l->st_type == CHAR_TYPE) {
                 fprintf(of,"%s","char");
            } else if (l->st_type == FUNCTION_TYPE) {
                fprintf(of,"%s","function returns ");
                
                if (l->st_type == INT_TYPE) {
                    fprintf(of,"%s","int");
                } else if (l->st_type  == CHAR_TYPE) {
                    fprintf(of,"%s","real");
                } else {
                    fprintf(of,"%s","undef");
                } 
            } else {
                fprintf(of,"%s","undef");
            }  
            
            
            while(t != NULL) {
                fprintf(of,"%d ",t->lineno);
                t = t->next;
            }
            
            fprintf(of,"\n");
            l = l->next;
        }
     }
  }
}
