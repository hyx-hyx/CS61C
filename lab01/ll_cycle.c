#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *first=head;
    node *second=head;
    if(head==NULL||head->next==NULL){
        return 0;
    }else{
        do{
            second=second->next->next;
            first=first->next;
            if(first==second){
                return 1;
            }
        }while(second!=NULL&&second->next!=NULL);
    }
    return 0;
}