org 100h

jmp inizio           

    menu0 db "-={ Tris }=-$"  
    menu1 db "> Giocatore vs. Giocatore <$"
    menu2 db "  Giocatore vs. CPU  $"
    menu3 db "  Esci  $"   
                                                              
    vince_x_msg  db "Vince X!$" 
    vince_o_msg  db "Vince O!$"                                               
    pareggio_msg db "Pareggio!$" 
    continua_msg db "Premi invio per continuare...$"

    fine_gioco db "Termine gioco.$"   
    
    punteggio_x db "Punteggio X:$"
    punteggio_o db "Punteggio O:$"
    
    turno_msg db "Turno: $"
    
    pensando db "Pensando...$"
    pensando_fine db "           $"
                        
    opzione db 0          
    
    bot db 0    ; 1 se si gioca contro la cpu, 0 se 2 giocatori
    
    cifre db 6 DUP(0)    ; vettore per la stampa di un numero
    
    punteggio1 dw 0
    punteggio2 dw 0
                
    turno db 0 
    
    giocatore db 0 
    giocatori db 'x', 'o'
    
    partite db 0                          
    
    tabmezzo db 196, 196, 196, 196, 196, 197, 196, 196, 196, 196, 196, 197, 196, 196, 196, 196, 196, "$"
    tab db      "     ", 179, "     ", 179, "     $"
    
    righe   dw offset vittoria_riga1, offset vittoria_riga2, offset vittoria_riga3            ; vettori con offset per i jmp per evitare molti cmp 
    colonne dw offset vittoria_colonna1, offset vittoria_colonna2, offset vittoria_colonna3   ;
    
inizio:    
           
    mov ah, 05h
    mov al, 0         ; selezionare pagina video 0
    int 10h 

    stampamenu:   
    
        call clear   
        
        mov ah, 5  
        mov bx, 12
        mov dx, offset menu0
        call stampa  
        
        mov ah, 9 
        mov bx, 27                           ; stampa menu
        mov dx, offset menu1
        call stampa
        
        mov ah, 10  
        mov bx, 21
        mov dx, offset menu2
        call stampa
        
        mov ah, 13
        mov bx, 8
        mov dx, offset menu3
        call stampa 
        
        input:
        
        mov ah, 0
        int 16h      
        
        cmp ah, 1ch
        je scelta
                                  
        cmp ah, 50h          ; freccia in giu
        je incrementa
        
        cmp ah, 48h          ; freccia in su
        je decrementa
        
        jmp input
        
        incrementa:
            cmp opzione, 2
            je input
            
            inc opzione
            jmp fine_menu 
            
        decrementa:
            cmp opzione, 0
            je input
            
            dec opzione
            jmp fine_menu
            
        fine_menu: 
        
            cmp opzione, 0
            je opzione1   
            
            cmp opzione, 1
            je opzione2  
            
            cmp opzione, 2
            je opzione3
            
            opzione1:
                
                mov menu1[0], ">"
                mov menu1[26], "<" 
                mov menu2[0], " "
                mov menu2[20], " "            ; cambia cursore
                mov menu3[0], " "
                mov menu3[7], " "
                
                jmp stampamenu
            
            opzione2:  
                
                mov menu1[0], " "
                mov menu1[26], " " 
                mov menu2[0], ">"
                mov menu2[20], "<"
                mov menu3[0], " "
                mov menu3[7], " "
                
                jmp stampamenu
                
            opzione3:  
                
                mov menu1[0], " "
                mov menu1[26], " " 
                mov menu2[0], " "
                mov menu2[20], " "
                mov menu3[0], ">"
                mov menu3[7], "<"
                
                jmp stampamenu   
                
scelta:   

    mov ax, 0      ; inizializza mouse
    int 33h    
       
    cmp opzione, 0
    je gioco
    
    cmp opzione, 1
    je contro_cpu
    
    cmp opzione, 2
    je esci 
    
contro_cpu:

    mov bot, 1

gioco:     

    mov turno, 0

    call clear
    
    call reset  
    
    inc partite   
    
    stampa_giocatore:
    
        mov ah, 1
        mov bx, 7
        mov dx, offset turno_msg
        call stampa    
        
        call stampa_turno
        
    stampa_punteggio:
        
        mov ah, 2
        mov dh, 2
        mov dl, 1
        mov bh, 0
        int 10h
        
        mov ah, 9
        mov dx, offset punteggio_x
        int 21h
        
        mov ah, 2
        mov dh, 3
        mov dl, 5
        mov bh, 0
        int 10h
        
        mov ax, punteggio1
        call stampa_numero 
        
        mov ah, 2
        mov dh, 2
        mov dl, 25
        mov bh, 0
        int 10h   
        
        mov ah, 9
        mov dx, offset punteggio_o
        int 21h
        
        mov ah, 2
        mov dh, 3
        mov dl, 30
        mov bh, 0
        int 10h
        
        mov ax, punteggio2
        call stampa_numero
        
    
    stampa_tabella:   
                  
        mov bx, 0           
                  
        mov ah, 6           
        mov bx, 17
        mov dx, offset tab
        call stampa
          
        mov ah, 7 
        mov bx, 17
        mov dx, offset tab
        call stampa
        
        mov ah, 8
        mov bx, 17
        mov dx, offset tab
        call stampa
         
        mov ah, 9 
        mov bx, 17
        mov dx, offset tabmezzo
        call stampa
        
        mov ah, 10        
        mov bx, 17
        mov dx, offset tab
        call stampa
             
        mov ah, 11
        mov bx, 17
        mov dx, offset tab
        call stampa
        
        mov ah, 12
        mov bx, 17 
        mov dx, offset tab
        call stampa            
        
        mov ah, 13
        mov bx, 17
        mov dx, offset tabmezzo
        call stampa
        
        mov ah, 14        
        mov bx, 17
        mov dx, offset tab
        call stampa
        
        mov ah, 15 
        mov bx, 17
        mov dx, offset tab
        call stampa      
        
        mov ah, 16
        mov bx, 17
        mov dx, offset tab
        call stampa 
        
    cmp bot, 1           ; controllo per vedere se il bot deve fare una mossa
    je mossa_bot
    
    input_mouse:
        
        mov ax, 0003
        int 33h 
        
        cmp bx, 1               ; quando si clicca tasto sinistro sul mouse
        je tasto_premuto
        
    jmp input_mouse       
    
    tasto_premuto:   

        controllo_orizzontale:
        
            cmp cx, 5fh
            ja controllo_verticale
        
            jmp input_mouse             ; controlla che sia entro il bordo della tabella
            
        controllo_verticale:
            
            cmp dx, 30h
            ja trova_casella
            
            jmp input_mouse  
        
    trova_casella:      
    
        colonna1:      
                                   ; controllo in quale riga e colonna il cursore ha cliccato
            cmp cx, 89h            ; e imposta su al e ah le posizioni, e su bl e bh le coordinate
            ja colonna2
            mov al, 0  
            mov bl, 14
            jmp riga1 
            
        colonna2:
        
            cmp cx, 0b9h
            ja colonna3  
            mov al, 1 
            mov bl, 20
            jmp riga1 
        
        colonna3:    
            
            cmp cx, 0e6h
            ja input_mouse
            mov al, 2 
            mov bl, 26
            jmp riga1
            
        riga1:
        
            cmp dx, 04ah
            ja riga2
            mov ah, 0 
            mov bh, 7
            jmp continua_casella
            
        riga2:
        
            cmp dx, 06ah
            ja riga3 
            mov ah, 1 
            mov bh, 11
            jmp continua_casella
            
        riga3:
            
            cmp dx, 086h 
            ja input_mouse
            mov ah, 2     
            mov bh, 15
            jmp continua_casella 
                  
                  
controllo_casella:  

        colonna1_2:      
        
            cmp al, 0  
            jne colonna2_2       ; mette su bl e bh le coordinate 
            mov bl, 14           ; dove stampare per la mossa del bot
            jmp riga1_2 
            
        colonna2_2:
         
            cmp al, 1 
            jne colonna3_2
            mov bl, 20
            jmp riga1_2 
        
        colonna3_2:    
            
            mov bl, 26
            jmp riga1_2
            
        riga1_2:
        
            cmp ah, 0 
            jne riga2_2
            mov bh, 7
            jmp continua_casella
            
        riga2_2:
        
            cmp ah, 1
            jne riga3_2 
            mov bh, 11
            jmp continua_casella
            
        riga3_2:
                
            mov bh, 15
            jmp continua_casella
            
        continua_casella: 

        push ax
        push bx     

        calcola_indice: 
        
            mov bh, ah
                                ; calcola l'indirizzo di memoria della casella
            add ah, bh
            add ah, bh  
            
            add ah, al    
            
        cambia:  
        
            mov bx, 0800h
            add bl, ah
            
            cmp [bx], 0
            jne input_mouse 
                                    ; mette il carattere del giocatore nella casella
            mov ah, giocatore                           
            mov [bx], ah
            inc [bx]
            
        stampa_carattere:
               
            pop dx   
            
            mov ah, 2
            mov bh, 0
            int 10h        
           
            mov bl, giocatore
            mov dl, giocatori[bx]
            int 21h  
            
        controllo_vittoria: 
        
            pop ax           
            
            cmp turno, 4
            jb prossimo_turno   
                                        ; controlla se c'e' una vittoria
            mov ch, giocatore
            
            inc ch
                             
            call controlla_vittoria
            
            cmp ah, 1
            je vittoria   

        prossimo_turno:  
            
            xor giocatore, 1
            
            inc turno   
                                            ; continua al prossimo turno
            call stampa_turno
            
            cmp turno, 9
            je pareggio 
            
            cmp bot, 1
            je mossa_bot 
                  
       jmp input_mouse  
       
       mossa_bot:  
       
            cmp giocatore, 1
            jne input_mouse 
       
            mov ah, 20
            mov bx, 11
            mov dx, offset pensando
            call stampa     
            
            mov cx, 8
            
            controlla_mosse_vincenti:    
                       
                mov ax, cx
                
                mov dh, 3
                
                div dh
                
                xchg ah, al    ; scambia ah e al dato che su ah c'e' la riga e su al la colonna
                
                mov bx, 0800h
                
                add bx, cx 
                
                cmp [bx], 0
                jne salta_controllo  
                
                push cx
                        
                mov ch, giocatore
                                           ; controlla ogni mossa per vedere se c'e' una mossa che lo
                inc ch                     ; farebbe vincere
                        
                mov [bx], ch
                
                push bx 
                
                push ax
                
                call controlla_vittoria
                       
                mov dh, ah
                
                pop ax
                       
                pop bx 
                
                pop cx      
                
                mov [bx], 0 
                
                cmp dh, 1
                je mossa_trovata           
                
                salta_controllo:           
            
            loop controlla_mosse_vincenti
            
                mov cx, 8
            
            controlla_mosse_blocca:    
                       
                mov ax, cx
                
                mov dh, 3
                
                div dh
                
                xchg ah, al    
                
                mov bx, 0800h
                
                add bx, cx 
                
                cmp [bx], 0
                jne salta_controllo2  
                
                push cx
                        
                mov ch, giocatore
                
                xor ch, 1                           ; controlla se c'e' una mossa che potrebbe far vincere l'avversiario
                                                    ; e la blocca
                inc ch    
                        
                mov [bx], ch
                
                push bx 
                
                push ax
                
                call controlla_vittoria
                       
                mov dh, ah
                
                pop ax
                       
                pop bx 
                
                pop cx 
                
                mov [bx], 0 
                
                cmp dh, 1
                je mossa_trovata          
                
                salta_controllo2:           
            
            loop controlla_mosse_blocca         

            centro:
                cmp [0804h], 0
                jne angoli
                mov ax, 101h                 ; controlla se il centro e' vuoto
                jmp mossa_trovata

            angoli:   
            
                a1:
                    cmp [0800h], 0
                    jne a2
                    mov ax, 0h
                    jmp mossa_trovata 
                
                a2:
                     cmp [0802h], 0
                    jne a3
                    mov ax, 2h
                    jmp mossa_trovata
                a3:  
                                                   ; controlla gli angoli della tabella
                    cmp [0806h], 0
                    jne a4
                    mov ax, 200h
                    jmp mossa_trovata
                
                a4:
                     cmp [0808h], 0
                    jne bordi
                    mov ax, 202h
                    jmp mossa_trovata

            bordi: 
            
                b1:  
                
                    cmp [0801h], 0
                    jne b2
                    mov ax, 1h
                    jmp mossa_trovata
                
                b2:                  
                
                    cmp [0803h], 0
                    jne b3
                    mov ax, 100h
                    jmp mossa_trovata
                                                    ; controlla i bordi della tabella
                b3:                  
                
                    cmp [0805h], 0
                    jne b4
                    mov ax, 102h
                    jmp mossa_trovata
                
                b4: 
                
                    cmp [0807h], 0
                    jne pareggio
                    mov ax, 201h
                    jmp mossa_trovata
                
                jmp pareggio
                
       mossa_trovata:  
       
            push ax
       
            mov ah, 20
            mov bx, 11                             ; se trova una mossa, dove la posizione della mossa scelta e' in ax,
            mov dx, offset pensando_fine           ; allora fai quella mossa
            call stampa
            
            pop ax   
       
       jmp controllo_casella  
       
       vittoria: 
    
            cmp giocatore, 0
            je vince_x
            jmp vince_o
       
       pareggio:  
       
            call clear
            
            mov ah, 9
            mov bx, 9                                 ; stampa messaggi di vittoria/pareggio
            mov dx, offset pareggio_msg
            call stampa
       
       jmp continua_partita
       
       vince_x:   
       
           call clear
       
           mov ah, 9
           mov bx, 8
           mov dx, offset vince_x_msg
           call stampa      
       
           inc punteggio1
       
       jmp continua_partita
       
       vince_o:    
       
           call clear
           
           mov ah, 9
           mov bx, 8
           mov dx, offset vince_o_msg
           call stampa  
           
           inc punteggio2 
           
       jmp continua_partita   
       
       
       
       continua_partita: 
       
           xor giocatore, 1 ; chi ha perso comincia        
       
           mov ah, 13
           mov bx, 29                                     ; ricomincia partita
           mov dx, offset continua_msg
           call stampa
            
           mov ah, 7
           int 21h
       
       jmp gioco      


                     
esci:  

        call clear     
                                                        ; uscita dal gioco
        mov ah, 9    
        mov bx, 14
        mov dx, offset fine_gioco
        call stampa

ret 

clear PROC
       
    mov ax, 0
    int 10h  
                                    ; cancella lo schermo
    mov cx, 2607h
    mov ah, 1
    int 10h   
          
    ret          
          
clear ENDP

reset PROC
    
    mov cx, 8
    
    reset_memoria:
    
        mov bx, 0800h
        add bx, cx
        
        mov [bx], 0
                                  ; resetta la memoria della tabella
    loop reset_memoria 
    
    mov [0800h], 0
    
    ret
    
reset ENDP

stampa PROC     
             
    ; stampa centrato         
             
    ; ah riga   
    ; bx lunghezza stringa - 1 ($)
    ; dx offset stringa  
    
    push dx                                      
    push ax                                      
    
    mov ax, bx         
              
    mov dl, 20
    mov dh, 2
    
    div dh
    
    sub dl, al   
    
    pop ax
    
    mov dh, ah
    mov ah, 2
    mov bh, 0
    int 10h
    
    pop dx
    
    mov ah, 9
    int 21h
    
    mov bx, 0
    
    ret
    
stampa ENDP     

stampa_numero PROC   
       
    ; ax -> cifre da stampare  
    
    mov si, 0
    mov bx, 10    
    
    prendi_cifre:                   
        
        cmp ax, 10
        jb fine_ultima
        
        mov dx, 0 ; Mettere a 0 per prendere il resto della divisione
        
        div bx    
        
        add dx, 30h
        
        mov cifre[si], dl
        inc si 
        
    jmp prendi_cifre
    
    fine_ultima:
    
        add ax, 30h
        
        mov cifre[si], al 
    
    fine:         
    
        inc si
    
        mov cifre[si], '$'
        
        mov bx, 0
        
        dec si  
        
        cmp si, 0
        je stampa_num
        
    scambia:   
        
        mov al, cifre[si]
        mov ah, cifre[bx]
        
        mov cifre[bx], al
        mov cifre[si], ah
        
        dec si
        cmp si, bx
        je stampa_num
        inc bx   
        cmp si, bx
        je stampa_num
        
    jmp scambia

    stampa_num:    
      
        mov ah,9
        mov dx, offset cifre
        int 21h                 
                 
    ret          

stampa_numero ENDP

controlla_vittoria PROC    
                
            mov bx, 0

            mov bl, ah     ; ah = riga
            
            shl bl, 1      ; moltiplica per 2 l'indice dato che gli indirizzi sono 2 byte
                                               
            jmp righe[bx]  ; salta al label corretto e controlla la vittoria a seconda della posizione
            
            vittoria_riga1:
             
                cmp [0800h], ch
                jne trova_colonna
                
                cmp [0801h], ch
                jne trova_colonna
                
                cmp [0802h], ch
                jne trova_colonna  
                
                jmp trovata
            
            vittoria_riga2:   
            
                cmp [0803h], ch
                jne trova_colonna
                
                cmp [0804h], ch
                jne trova_colonna
                
                cmp [0805h], ch
                jne trova_colonna 
                
                jmp trovata
            
            vittoria_riga3:
            
                cmp [0806h], ch
                jne trova_colonna
                
                cmp [0807h], ch
                jne trova_colonna
                
                cmp [0808h], ch
                jne trova_colonna
                
                jmp trovata
            
            trova_colonna: 
            
                mov bl, al        ; al = colonna
                
                shl bl, 1            
                                       
                jmp colonne[bx]
            
            vittoria_colonna1:
            
                cmp [0800h], ch
                jne controlla_diagonali
                
                cmp [0803h], ch
                jne controlla_diagonali
                
                cmp [0806h], ch
                jne controlla_diagonali
                
                jmp trovata
            
            vittoria_colonna2:
            
                cmp [0801h], ch
                jne controlla_diagonali
                
                cmp [0804h], ch
                jne controlla_diagonali
                
                cmp [0807h], ch
                jne controlla_diagonali
                
                jmp trovata
            
            vittoria_colonna3: 
            
                cmp [0802h], ch
                jne controlla_diagonali
                
                cmp [0805h], ch
                jne controlla_diagonali
                
                cmp [0808h], ch
                jne controlla_diagonali
                
                jmp trovata
                
            controlla_diagonali:  
            
             ;    0  1  2 
             ;    3  4  5 
             ;    6  7  8
             ;   
             ;   0 1 2 3 4 5 6 7 8
             ;   
             ;   0,0  0,1 0,2        
             ;   1,0  1,1 1,2        
             ;   2,0  2,1 2,2        
             
             ; x = y     allora diagonale 1
             ; x + y = 2 allora diagonale 2
             ; 1,1       allora diagonale 1 e 2  
                
                cmp ah, 1
                je controllo_centro                      
                                      
                cmp ah, al
                je vittoria_diagonale1
                
                add ah, al
                
                cmp ah, 2
                je vittoria_diagonale2
                
                jmp non_trovata
                
            controllo_centro:
            
                cmp al, 1
                jne non_trovata

                cmp [0800h], ch
                jne vittoria_diagonale2
                    
                cmp [0804h], ch
                jne vittoria_diagonale2
                    
                cmp [0808h], ch
                jne vittoria_diagonale2
                    
                jmp trovata
                
            vittoria_diagonale1:
                
                cmp [0800h], ch
                jne non_trovata
                
                cmp [0804h], ch
                jne non_trovata
                
                cmp [0808h], ch
                jne non_trovata
                
                jmp trovata
            
            vittoria_diagonale2:
            
                cmp [0802h], ch
                jne non_trovata
                
                cmp [0804h], ch
                jne non_trovata
                
                cmp [0806h], ch
                jne non_trovata
                
                jmp trovata 
                
     trovata:
     
        mov ah, 1
        
        jmp fine_controllo_vittoria 
        
     non_trovata:
     
        mov ah, 0
        
     fine_controllo_vittoria:    
                
     ret
                
controlla_vittoria ENDP                   

stampa_turno PROC
    
        mov ah, 2
        mov dh, 2
        mov dl, 20
        mov bh, 0
        int 10h
        
        mov bx, 0
              
        mov bl, giocatore
        mov ah, giocatori[bx]
        
        mov dl, ah
        mov ah, 2
        int 21h
     
        ret
     
stampa_turno ENDP